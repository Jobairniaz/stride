import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/utils/duration_format.dart';
import '../../../platform/audio/speech_announcer.dart';
import '../../../platform/notifications/workout_notification_service.dart';
import '../../profile/domain/calorie_estimator.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/entities/workout_enums.dart';
import '../domain/entities/workout_session.dart';
import '../domain/entities/workout_snapshot.dart';
import '../domain/services/announcement_planner.dart';
import '../domain/services/workout_engine.dart';
import 'workout_state.dart';

final workoutControllerProvider =
    NotifierProvider<WorkoutController, WorkoutState>(WorkoutController.new);

/// Orchestrates workout commands. It owns no timer arithmetic: every state
/// change goes through [WorkoutEngine], and the periodic ticker only triggers
/// reconciliation against the clock.
class WorkoutController extends Notifier<WorkoutState> {
  /// UI refresh / reconciliation cadence. Not the authoritative clock.
  static const tickInterval = Duration(milliseconds: 200);

  /// Low-frequency checkpoint so recovery is reasonably fresh without
  /// writing to SQLite every second.
  static const checkpointInterval = Duration(seconds: 30);

  /// iOS allows 64 pending notifications per app; stay well below.
  static const maxScheduledCues = 30;
  static const _cueIdBase = 100;

  static const _engine = WorkoutEngine();
  static const _planner = AnnouncementPlanner();

  Timer? _ticker;
  DateTime? _lastCueCheck;
  DateTime? _lastPersistAt;
  final _spokenIds = <String>{};
  Future<void> _writes = Future.value();
  bool _inBackground = false;

  /// Set while scheduled notifications are speaking the phase changes, so a
  /// process that stays alive in the background does not say them twice.
  bool _notificationsSpeakCues = false;
  bool _finishing = false;

  @override
  WorkoutState build() {
    ref.onDispose(_stopTicker);
    scheduleMicrotask(_loadUnfinished);
    return WorkoutState(now: ref.read(clockProvider).now());
  }

  /// Only notify listeners when something visible changed; reconciliation
  /// runs 5×/s but the countdown changes once per second.
  @override
  bool updateShouldNotify(WorkoutState previous, WorkoutState next) {
    if (previous.loading != next.loading ||
        !identical(previous.recovery, next.recovery) ||
        !identical(previous.failure, next.failure) ||
        previous.completedSessionId != next.completedSessionId ||
        previous.saving != next.saving ||
        previous.missedCues != next.missedCues) {
      return true;
    }
    final a = previous.active;
    final b = next.active;
    if (a == null || b == null) return !identical(a, b);
    if (a.status != b.status ||
        a.current != b.current ||
        a.workIndex != b.workIndex) {
      return true;
    }
    return _displayKey(a, previous.now) != _displayKey(b, next.now);
  }

  static (int, int) _displayKey(WorkoutSnapshot s, DateTime now) => (
    (s.remainingAt(now).inMilliseconds + 999) ~/ 1000,
    s.movingElapsedAt(now).inSeconds,
  );

  DateTime _now() => ref.read(clockProvider).now();

  // --- Commands --------------------------------------------------------------

  /// Starts a new workout from the saved settings. Throws
  /// [InvalidWorkoutPlanFailure] if the configured plan is invalid.
  void start() {
    if (!state.canStart) return;
    final settings = ref.read(settingsControllerProvider);
    final now = _now();
    final snapshot = _engine.start(
      plan: settings.plan,
      sessionId: const Uuid().v4(),
      now: now,
    );
    _spokenIds.clear();
    _lastCueCheck = now;
    state = state.copyWith(
      active: () => snapshot,
      now: now,
      failure: () => null,
      missedCues: false,
      completedSessionId: () => null,
    );
    if (settings.voiceEnabled) _speak(_planner.phaseStartCue(snapshot.current));
    _transitionFeedback();
    _persist(snapshot);
    _startTicker();
  }

  void pause() => _command(_engine.pause);

  void resume() => _command(_engine.resume);

  void skip() => _command(_engine.skip);

  void insertBreak(Duration duration) =>
      _command((s, now) => _engine.insertBreak(s, duration, now));

  /// Ends the workout. With [save] the session is stored; otherwise it is
  /// discarded. Safe to call again to retry a failed save.
  Future<void> finish({required bool save}) async {
    final active = state.active;
    if (active == null || _finishing) return;
    if (!save) {
      _finishing = true;
      _stopTicker();
      try {
        final repo = ref.read(workoutRepositoryProvider);
        await _enqueue(repo.clearActiveSnapshot);
        if (!ref.mounted) return;
        state = state.copyWith(active: () => null, missedCues: false);
        await _cancelNotifications();
      } on AppFailure catch (e) {
        if (ref.mounted) state = state.copyWith(failure: () => e);
      } finally {
        _finishing = false;
      }
      return;
    }
    await _complete(
      _engine.finish(active, _now(), CompletionReason.userStopped),
    );
  }

  /// Resume an unfinished workout found at launch. Missed boundaries are
  /// applied; their cues are not replayed.
  void resumeRecovered() {
    final recovered = state.recovery;
    if (recovered == null || !state.canResumeRecovery) return;
    final now = _now();
    _spokenIds.clear();
    _lastCueCheck = recovered.lastReconciledAt;
    state = state.copyWith(recovery: () => null, active: () => recovered);
    final result = _engine.reconcile(recovered, now);
    _apply(result, now, userAction: true);
    if (!result.isFinished) _startTicker();
  }

  /// Save an unfinished workout as ended at its last checkpoint.
  Future<void> saveRecovered() async {
    final recovered = state.recovery;
    if (recovered == null || _finishing) return;
    await _complete(
      _engine.finish(
        recovered,
        recovered.lastReconciledAt,
        CompletionReason.recovered,
      ),
    );
  }

  Future<void> discardRecovered() async {
    if (state.recovery == null) return;
    try {
      final repo = ref.read(workoutRepositoryProvider);
      await _enqueue(repo.clearActiveSnapshot);
      if (ref.mounted) state = state.copyWith(recovery: () => null);
    } on AppFailure catch (e) {
      if (ref.mounted) state = state.copyWith(failure: () => e);
    }
  }

  void acknowledgeCompletion() =>
      state = state.copyWith(completedSessionId: () => null);

  void clearFailure() => state = state.copyWith(failure: () => null);

  void dismissMissedCues() => state = state.copyWith(missedCues: false);

  // --- App lifecycle ---------------------------------------------------------

  /// Reconciles against the clock now (what the periodic ticker does).
  @visibleForTesting
  void tick() => _tick();

  /// Called when the app is hidden. Checkpoints and schedules OS
  /// notifications as a fallback; Dart code may be suspended after this.
  void onBackgrounded() {
    if (_inBackground) return;
    _inBackground = true;
    final active = state.active;
    if (active == null) return;
    final now = _now();
    final result = _engine.reconcile(active, now);
    _apply(result, now, userAction: false);
    final snapshot = state.active;
    if (snapshot == null) return;
    _persist(snapshot);
    unawaited(_scheduleBackgroundNotifications(snapshot));
  }

  /// Called when the app is visible again: reconcile immediately.
  void onForegrounded() {
    if (!_inBackground) return;
    _inBackground = false;
    _notificationsSpeakCues = false;
    if (state.active == null) return;
    unawaited(_cancelNotifications());
    _tick();
  }

  // --- Internals -------------------------------------------------------------

  void _command(
    EngineResult Function(WorkoutSnapshot snapshot, DateTime now) op,
  ) {
    final active = state.active;
    if (active == null || _finishing) return;
    final now = _now();
    _apply(op(active, now), now, userAction: true);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(tickInterval, (_) => _tick());
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _tick() {
    final active = state.active;
    if (active == null || _finishing) return;
    final now = _now();
    _apply(_engine.reconcile(active, now), now, userAction: false);
  }

  void _apply(EngineResult result, DateTime now, {required bool userAction}) {
    final settings = ref.read(settingsControllerProvider);
    final windowStart = _lastCueCheck ?? now;
    _lastCueCheck = now;

    if (settings.voiceEnabled) {
      final cues = _planner.dueCues(
        windowStart: windowStart,
        now: now,
        transitions: result.transitions,
        snapshot: result.snapshot,
        preferences: settings.cuePreferences,
      );
      for (final cue in cues) {
        if (_notificationsSpeakCues && _spokenByNotification(cue)) continue;
        _speak(cue);
      }
    }

    final transitioned = result.transitions.isNotEmpty;
    final missed =
        transitioned &&
        now.difference(result.transitions.last.at) > _planner.staleAfter;
    if (transitioned && !missed) _transitionFeedback();

    final finished = result.finished;
    if (finished != null) {
      unawaited(_complete(finished));
      return;
    }

    final snapshot = result.snapshot!;
    state = state.copyWith(
      active: () => snapshot,
      now: now,
      missedCues: missed ? true : null,
    );

    final checkpointDue =
        _lastPersistAt == null ||
        now.difference(_lastPersistAt!) >= checkpointInterval ||
        now.isBefore(_lastPersistAt!);
    if (transitioned || userAction || checkpointDue) _persist(snapshot);
    if (transitioned && _inBackground) {
      unawaited(
        ref
            .read(notificationServiceProvider)
            .showOngoing(_ongoingInfo(snapshot, now)),
      );
    }
  }

  Future<void> _complete(WorkoutSession session) async {
    if (_finishing) return;
    _finishing = true;
    _stopTicker();
    state = state.copyWith(saving: true, now: session.endedAt);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final toSave = session.withCalorieEstimate(await _estimate(session));
      await _enqueue(() => repo.saveCompletedSession(toSave));
      if (!ref.mounted) return;
      state = state.copyWith(
        active: () => null,
        recovery: () => null,
        saving: false,
        missedCues: false,
        completedSessionId: () => session.id,
      );
      await _cancelNotifications();
    } on AppFailure catch (e) {
      // Not saved: keep the unfinished workout so the user can retry.
      if (ref.mounted) state = state.copyWith(saving: false, failure: () => e);
    } finally {
      _finishing = false;
    }
  }

  /// Snapshot of the weight in effect at the end of the workout. Stored with
  /// the session and never recalculated.
  Future<CalorieEstimate?> _estimate(WorkoutSession session) async {
    try {
      final weight = await ref
          .read(profileRepositoryProvider)
          .weightAt(session.endedAt);
      return CalorieEstimator.estimate(
        walking: session.walkingDuration,
        running: session.runningDuration,
        rest: session.restDuration,
        weightGrams: weight?.weightGrams,
      );
    } on PersistenceFailure {
      // The workout itself matters more than the estimate.
      return null;
    }
  }

  static bool _spokenByNotification(Announcement cue) =>
      cue.kind == CueKind.phaseStart || cue.kind == CueKind.workoutComplete;

  void _speak(Announcement announcement) {
    if (!_spokenIds.add(announcement.id)) return;
    // Never awaited: timing must not depend on speech. The announcer
    // contract is not to throw; log defensively if one does.
    unawaited(
      ref.read(speechAnnouncerProvider).announce(announcement).catchError((
        Object e,
      ) {
        debugPrint('Announcement failed: ${e.runtimeType}');
        return false;
      }),
    );
  }

  void _transitionFeedback() {
    if (_inBackground) return;
    final settings = ref.read(settingsControllerProvider);
    final speechDown =
        settings.voiceEnabled &&
        ref.read(speechAnnouncerProvider).status == SpeechStatus.unavailable;
    if (settings.hapticsEnabled || speechDown) {
      unawaited(ref.read(hapticsProvider).phaseChanged());
    }
  }

  /// Serialises database writes so a late checkpoint can never overwrite a
  /// completion or discard.
  Future<void> _enqueue(Future<void> Function() op) {
    final result = _writes.then((_) => op());
    // Keep the chain alive after a failure; the caller handles the error.
    _writes = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  void _persist(WorkoutSnapshot snapshot) {
    _lastPersistAt = snapshot.lastReconciledAt;
    // Capture dependencies now: the write may run after this notifier is
    // disposed, and must not touch `ref` then.
    final repo = ref.read(workoutRepositoryProvider);
    unawaited(
      _enqueue(() => repo.saveActiveSnapshot(snapshot)).onError<AppFailure>((
        e,
        _,
      ) {
        if (ref.mounted) state = state.copyWith(failure: () => e);
      }),
    );
  }

  OngoingWorkoutInfo _ongoingInfo(WorkoutSnapshot s, DateTime now) {
    final rounds = s.plan.targetRounds;
    final round = rounds == null
        ? 'Round ${s.currentRound}'
        : 'Round ${s.currentRound} of $rounds';
    final next = s.nextPhase;
    return OngoingWorkoutInfo(
      title: '${s.current.type.label} · $round',
      body: s.isPaused
          ? 'Paused · ${formatCountdown(s.remainingAt(now))} left'
          : (next.isFinish ? 'Last phase' : 'Next: ${next.type!.label}'),
      countdownTo: s.isPaused ? null : s.current.deadline,
    );
  }

  Future<void> _scheduleBackgroundNotifications(WorkoutSnapshot s) async {
    final service = ref.read(notificationServiceProvider);
    final now = _now();
    if (await service.permission() != NotificationPermission.granted) return;
    await service.showOngoing(_ongoingInfo(s, now));
    final upcoming = _engine.projectUpcoming(s, limit: maxScheduledCues);
    final rounds = s.plan.targetRounds;
    final voice = ref.read(settingsControllerProvider).voiceEnabled;
    await service.scheduleCues([
      for (final (i, u) in upcoming.indexed)
        ScheduledCue(
          id: _cueIdBase + i,
          at: u.at,
          title: u.isFinish
              ? 'Workout completed'
              : AnnouncementPlanner.phaseStartText(u.to!),
          body: u.isFinish
              ? 'Open Stride to see your summary.'
              : '${formatDurationLabel(u.to!.plannedDuration)} · Round '
                    '${u.round}${rounds == null ? '' : ' of $rounds'}',
          sound: !voice
              ? null
              : switch (u.to?.type) {
                  null => CueSound.finish,
                  PhaseType.walking => CueSound.walk,
                  PhaseType.running => CueSound.run,
                  PhaseType.rest => CueSound.rest,
                },
        ),
    ]);
    // Still hidden: the scheduled notifications now speak phase changes.
    _notificationsSpeakCues = voice && _inBackground && upcoming.isNotEmpty;
  }

  Future<void> _cancelNotifications() =>
      ref.read(notificationServiceProvider).cancelWorkoutNotifications();

  Future<void> _loadUnfinished() async {
    try {
      final snapshot = await ref
          .read(workoutRepositoryProvider)
          .loadActiveSnapshot();
      if (!ref.mounted) return;
      state = state.copyWith(
        loading: false,
        recovery: () => snapshot,
        now: _now(),
      );
    } on AppFailure catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, failure: () => e);
      }
    }
  }
}
