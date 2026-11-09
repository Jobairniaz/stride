import '../../../../core/utils/duration_format.dart';
import '../entities/workout_enums.dart';
import '../entities/workout_snapshot.dart';
import 'workout_engine.dart';

enum CueKind {
  phaseStart,
  tenSeconds,
  countdown3,
  countdown2,
  countdown1,
  workoutComplete,
  catchUp,
}

/// A spoken cue. [id] is deterministic so callers can deduplicate.
class Announcement {
  const Announcement({
    required this.id,
    required this.kind,
    required this.text,
    required this.dueAt,
  });

  final String id;
  final CueKind kind;
  final String text;
  final DateTime dueAt;

  @override
  String toString() => 'Announcement($id, "$text")';
}

class CuePreferences {
  const CuePreferences({
    required this.tenSecondWarning,
    required this.countdown321,
  });

  final bool tenSecondWarning;
  final bool countdown321;
}

/// Decides which cues are due in a time window. Pure; no plugins.
///
/// A cue is due when its instant lies in `[windowStart, now]` and is not
/// older than [staleAfter]. Cues missed while the app was suspended are
/// therefore dropped; if phase boundaries were missed, a single catch-up cue
/// describes the current state instead of replaying a burst.
class AnnouncementPlanner {
  const AnnouncementPlanner({
    this.staleAfter = const Duration(milliseconds: 1500),
  });

  final Duration staleAfter;

  static const _tenSecondMinPhase = Duration(seconds: 13);
  static const _countdownMinPhase = Duration(seconds: 5);

  List<Announcement> dueCues({
    required DateTime windowStart,
    required DateTime now,
    required List<PhaseTransition> transitions,
    required WorkoutSnapshot? snapshot,
    required CuePreferences preferences,
  }) {
    // Inclusive start: a user action at the same instant as the previous
    // check still counts. Deterministic ids let callers drop duplicates.
    bool fresh(DateTime t) =>
        !t.isBefore(windowStart) &&
        !t.isAfter(now) &&
        now.difference(t) <= staleAfter;

    final cues = <Announcement>[];

    if (transitions.isNotEmpty) {
      final last = transitions.last;
      if (fresh(last.at)) {
        cues.add(transitionCue(last, sessionId: snapshot?.sessionId));
      } else if (snapshot != null && !snapshot.isPaused) {
        cues.add(catchUpCue(snapshot, now));
      }
    }

    if (snapshot != null && !snapshot.isPaused) {
      final phase = snapshot.current;
      final deadline = phase.deadline!;
      final marks = <(CueKind, int)>[
        if (preferences.tenSecondWarning &&
            phase.plannedDuration >= _tenSecondMinPhase)
          (CueKind.tenSeconds, 10),
        if (preferences.countdown321 &&
            phase.plannedDuration >= _countdownMinPhase) ...[
          (CueKind.countdown3, 3),
          (CueKind.countdown2, 2),
          (CueKind.countdown1, 1),
        ],
      ];
      for (final (kind, seconds) in marks) {
        final at = deadline.subtract(Duration(seconds: seconds));
        if (!fresh(at)) continue;
        cues.add(
          Announcement(
            id: '${phase.id}:${kind.name}',
            kind: kind,
            text: kind == CueKind.tenSeconds
                ? _tenSecondText(snapshot.nextPhase)
                : '$seconds',
            dueAt: at,
          ),
        );
      }
    }
    return cues;
  }

  Announcement phaseStartCue(ActivePhase phase) => Announcement(
    id: '${phase.id}:${CueKind.phaseStart.name}',
    kind: CueKind.phaseStart,
    text: phaseStartText(phase),
    dueAt: phase.startedAt,
  );

  Announcement transitionCue(PhaseTransition t, {String? sessionId}) {
    final to = t.to;
    if (to == null) {
      return Announcement(
        id: '${t.from.id}:${CueKind.workoutComplete.name}',
        kind: CueKind.workoutComplete,
        text: 'Workout completed',
        dueAt: t.at,
      );
    }
    return phaseStartCue(to);
  }

  Announcement catchUpCue(WorkoutSnapshot snapshot, DateTime now) {
    final phase = snapshot.current;
    return Announcement(
      id: '${phase.id}:${CueKind.catchUp.name}',
      kind: CueKind.catchUp,
      text:
          '${phase.type.label}. ${spokenDuration(phase.remainingAt(now))} left',
      dueAt: now,
    );
  }

  static String phaseStartText(ActivePhase phase) => switch (phase.type) {
    PhaseType.walking =>
      phase.isResumption ? 'Resume walking' : 'Start walking',
    PhaseType.running =>
      phase.isResumption ? 'Resume running' : 'Start running',
    PhaseType.rest =>
      phase.insertedByUser
          ? 'Rest time. ${spokenDuration(phase.plannedDuration)}'
          : 'Rest time',
  };

  static String _tenSecondText(NextPhasePreview next) => next.isFinish
      ? '10 seconds left'
      : '10 seconds. ${next.type!.label} next';
}
