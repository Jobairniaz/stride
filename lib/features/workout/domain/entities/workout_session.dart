import '../../../profile/domain/calorie_estimator.dart';
import 'phase_segment.dart';
import 'workout_enums.dart';
import 'workout_plan.dart';

/// A finished, saved workout.
class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.startedAt,
    required this.endedAt,
    required this.completionReason,
    required this.walkingDuration,
    required this.runningDuration,
    required this.restDuration,
    required this.completedRounds,
    required this.plan,
    required this.segments,
    this.calorieEstimate,
  });

  /// Builds aggregates from the phase segments (the audit source).
  factory WorkoutSession.fromSegments({
    required String id,
    required DateTime startedAt,
    required DateTime endedAt,
    required CompletionReason reason,
    required int completedRounds,
    required WorkoutPlan plan,
    required List<PhaseSegment> segments,
  }) {
    var walking = Duration.zero;
    var running = Duration.zero;
    var rest = Duration.zero;
    for (final s in segments) {
      switch (s.type) {
        case PhaseType.walking:
          walking += s.actualDuration;
        case PhaseType.running:
          running += s.actualDuration;
        case PhaseType.rest:
          rest += s.actualDuration;
      }
    }
    return WorkoutSession(
      id: id,
      startedAt: startedAt,
      endedAt: endedAt,
      completionReason: reason,
      walkingDuration: walking,
      runningDuration: running,
      restDuration: rest,
      completedRounds: completedRounds,
      plan: plan,
      segments: List.unmodifiable(segments),
    );
  }

  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final CompletionReason completionReason;
  final Duration walkingDuration;
  final Duration runningDuration;
  final Duration restDuration;
  final int completedRounds;
  final WorkoutPlan plan;
  final List<PhaseSegment> segments;
  final CalorieEstimate? calorieEstimate;

  /// Walking + running.
  Duration get activeDuration => walkingDuration + runningDuration;

  /// Walking + running + rest (pauses excluded).
  Duration get movingDuration => activeDuration + restDuration;

  /// Wall-clock duration from start to end, including pauses.
  Duration get totalElapsed => endedAt.difference(startedAt);

  WorkoutSession withCalorieEstimate(CalorieEstimate? estimate) =>
      WorkoutSession(
        id: id,
        startedAt: startedAt,
        endedAt: endedAt,
        completionReason: completionReason,
        walkingDuration: walkingDuration,
        runningDuration: runningDuration,
        restDuration: restDuration,
        completedRounds: completedRounds,
        plan: plan,
        segments: segments,
        calorieEstimate: estimate,
      );
}
