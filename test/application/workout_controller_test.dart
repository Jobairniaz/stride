import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stride/app/providers.dart';
import 'package:stride/features/settings/application/settings_controller.dart';
import 'package:stride/features/workout/application/workout_controller.dart';
import 'package:stride/features/workout/application/workout_state.dart';
import 'package:stride/features/workout/domain/entities/workout_enums.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/services/workout_engine.dart';
import 'package:stride/platform/notifications/workout_notification_service.dart';
import 'package:stride/platform/storage/app_database.dart';

import '../helpers/test_harness.dart';

Duration s(int n) => Duration(seconds: n);

/// Lets queued async work (database writes, loads) complete.
Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 30));

void main() {
  late Harness h;
  late ProviderContainer c;

  WorkoutState state() => c.read(workoutControllerProvider);
  WorkoutController ctrl() => c.read(workoutControllerProvider.notifier);

  Future<void> boot([Harness? harness]) async {
    h = harness ?? Harness();
    await h.init();
    c = h.container();
    c.listen(workoutControllerProvider, (_, _) {});
    await settle();
    expect(state().loading, isFalse);
  }

  tearDown(() async {
    c.dispose();
  });

  test('start enters walking, speaks once and persists a snapshot', () async {
    await boot();
    ctrl().start();
    expect(state().active!.current.type, PhaseType.walking);
    expect(h.announcer.texts, ['Start walking']);
    await settle();
    final saved = await c.read(workoutRepositoryProvider).loadActiveSnapshot();
    expect(saved!.sessionId, state().active!.sessionId);
  });

  test('ticks drive transitions from the clock; no stale burst', () async {
    await boot();
    ctrl().start();
    h.clock.advance(s(120));
    ctrl().tick();
    expect(state().active!.current.type, PhaseType.running);
    // The 10 s / 3-2-1 cues were not "heard" in time, so they are dropped.
    expect(h.announcer.texts, ['Start walking', 'Start running']);
    expect(h.haptics.count, 2);
  });

  test('duplicate ticks do not duplicate transitions or cues', () async {
    await boot();
    ctrl().start();
    h.clock.advance(s(110));
    ctrl()
      ..tick()
      ..tick()
      ..tick();
    expect(
      h.announcer.texts.where((t) => t.startsWith('10 seconds')),
      hasLength(1),
    );
  });

  test('pause, resume, skip and break are routed through the engine', () async {
    await boot();
    ctrl().start();
    h.clock.advance(s(30));
    ctrl().pause();
    expect(state().active!.isPaused, isTrue);
    h.clock.advance(const Duration(minutes: 10));
    ctrl().tick();
    expect(state().active!.remainingAt(h.clock.now()), s(90));
    ctrl().resume();
    ctrl().skip();
    expect(state().active!.current.type, PhaseType.running);
    ctrl().insertBreak(s(60));
    expect(state().active!.current.type, PhaseType.rest);
    expect(h.announcer.texts.last, 'Rest time. 1 minute');
  });

  test('finish(save) stores one session with a calorie snapshot', () async {
    await boot();
    await c
        .read(profileRepositoryProvider)
        .addWeight(measuredAt: h.clock.now(), weightGrams: 80000);
    ctrl().start();
    h.clock.advance(s(150));
    ctrl().tick();
    await ctrl().finish(save: true);
    final id = state().completedSessionId!;
    expect(state().active, isNull);
    final session = (await c
        .read(workoutRepositoryProvider)
        .watchSession(id)
        .first)!;
    expect(session.walkingDuration, s(120));
    expect(session.runningDuration, s(30));
    expect(session.completionReason, CompletionReason.userStopped);
    expect(session.calorieEstimate!.weightGrams, 80000);
    expect(
      await c.read(workoutRepositoryProvider).loadActiveSnapshot(),
      isNull,
    );
  });

  test('reaching the round target auto-saves exactly once', () async {
    await boot();
    await c
        .read(settingsRepositoryProvider)
        .save(
          c
              .read(settingsRepositoryProvider)
              .load()
              .copyWith(targetRounds: () => 1),
        );
    c.invalidate(workoutControllerProvider);
    await settle();
    ctrl().start();
    h.clock.advance(s(600));
    ctrl()
      ..tick()
      ..tick();
    await settle();
    expect(state().completedSessionId, isNotNull);
    final all = await c
        .read(workoutRepositoryProvider)
        .watchAllSessionStarts()
        .first;
    expect(all, hasLength(1));
  });

  test('discard leaves no history and no snapshot', () async {
    await boot();
    ctrl().start();
    await ctrl().finish(save: false);
    expect(state().active, isNull);
    expect(state().completedSessionId, isNull);
    expect(
      await c.read(workoutRepositoryProvider).loadActiveSnapshot(),
      isNull,
    );
  });

  test('speech failure never stops the timer', () async {
    await boot(Harness(announcer: RecordingAnnouncer(fail: true)));
    ctrl().start();
    h.clock.advance(s(240));
    ctrl().tick();
    expect(state().active!.currentRound, 2);
    // Speech is down, so the phase change falls back to a haptic.
    expect(h.haptics.count, greaterThan(0));
  });

  group('recovery after restart', () {
    Future<(AppDatabase, Harness)> crashMidWorkout() async {
      await boot();
      ctrl().start();
      h.clock.advance(s(30));
      ctrl().tick();
      ctrl().onBackgrounded(); // checkpoint
      await settle();
      final db = h.db;
      final clock = h.clock;
      c.dispose();
      // "Process death": a new container over the same database.
      final next = Harness(db: db, clock: clock);
      return (db, next);
    }

    test('offers recovery instead of resuming silently', () async {
      final (_, next) = await crashMidWorkout();
      await boot(next);
      expect(state().recovery, isNotNull);
      expect(state().active, isNull);
      expect(state().canStart, isFalse);
    });

    test('resume applies elapsed time with one catch-up cue', () async {
      final (_, next) = await crashMidWorkout();
      next.clock.advance(const Duration(minutes: 5));
      await boot(next);
      ctrl().resumeRecovered();
      final active = state().active!;
      // 30 s + 5 min = 330 s → third phase (walking), 30 s remaining.
      expect(active.current.type, PhaseType.walking);
      expect(active.remainingAt(h.clock.now()), s(30));
      expect(state().missedCues, isTrue);
      expect(h.announcer.texts, ['Walking. 30 seconds left']);
    });

    test(
      'save-at-checkpoint ends the workout at the last saved time',
      () async {
        final (_, next) = await crashMidWorkout();
        next.clock.advance(const Duration(days: 2));
        await boot(next);
        expect(state().canResumeRecovery, isFalse);
        await ctrl().saveRecovered();
        final id = state().completedSessionId!;
        final s30 = (await c
            .read(workoutRepositoryProvider)
            .watchSession(id)
            .first)!;
        expect(s30.completionReason, CompletionReason.recovered);
        expect(s30.walkingDuration, s(30));
        expect(state().recovery, isNull);
      },
    );

    test('discard clears the unfinished workout', () async {
      final (_, next) = await crashMidWorkout();
      await boot(next);
      await ctrl().discardRecovered();
      expect(state().recovery, isNull);
      expect(state().canStart, isTrue);
    });
  });

  group('background notifications', () {
    test('backgrounding schedules future cues; foreground cancels', () async {
      await boot(Harness());
      await c
          .read(settingsRepositoryProvider)
          .save(
            c
                .read(settingsRepositoryProvider)
                .load()
                .copyWith(targetRounds: () => 2),
          );
      c.invalidate(workoutControllerProvider);
      await settle();
      ctrl().start();
      ctrl().onBackgrounded();
      await settle();
      final cues = h.notifications.scheduled.single;
      expect(cues, hasLength(4));
      expect(cues.first.title, 'Start running');
      expect(cues.last.title, 'Workout completed');
      expect(cues.map((c) => c.id).toSet(), hasLength(4));
      expect(cues.map((c) => c.sound), [
        CueSound.run,
        CueSound.walk,
        CueSound.run,
        CueSound.finish,
      ]);
      ctrl().onForegrounded();
      await settle();
      expect(h.notifications.cancelCount, 1);
    });

    test('nothing is scheduled without notification permission', () async {
      await boot(Harness(notifications: FakeNotifications(granted: false)));
      ctrl().start();
      ctrl().onBackgrounded();
      await settle();
      expect(h.notifications.scheduled, isEmpty);
    });

    test('alive in background: notification speaks the phase change, '
        'TTS does not repeat it', () async {
      await boot();
      ctrl().start();
      ctrl().onBackgrounded();
      await settle();
      h.clock.advance(s(110));
      ctrl().tick();
      h.clock.advance(s(10));
      ctrl().tick();
      expect(state().active!.current.type, PhaseType.running);
      expect(h.announcer.texts, ['Start walking', '10 seconds. Running next']);

      // Back in the foreground, live TTS speaks phase changes again.
      ctrl().onForegrounded();
      h.clock.advance(state().active!.remainingAt(h.clock.now()));
      ctrl().tick();
      expect(h.announcer.texts.last, 'Start walking');
    });

    test('without notifications, TTS still speaks in background', () async {
      await boot(Harness(notifications: FakeNotifications(granted: false)));
      ctrl().start();
      ctrl().onBackgrounded();
      await settle();
      h.clock.advance(s(120));
      ctrl().tick();
      expect(h.announcer.texts.last, 'Start running');
    });

    test('voice off: notifications use the default sound', () async {
      await boot();
      final repo = c.read(settingsRepositoryProvider);
      await repo.save(repo.load().copyWith(voiceEnabled: false));
      c
        ..invalidate(settingsControllerProvider)
        ..invalidate(workoutControllerProvider);
      await settle();
      ctrl().start();
      ctrl().onBackgrounded();
      await settle();
      final cues = h.notifications.scheduled.single;
      expect(cues, isNotEmpty);
      expect(cues.map((c) => c.sound).toSet(), {null});
    });
  });

  test('engine guard: resume gap constant is documented', () {
    expect(WorkoutEngine.maxResumeGap, const Duration(hours: 6));
    expect(const WorkoutPlan().walkDuration, s(120));
  });
}
