import '../../../../core/errors/app_failure.dart';
import 'workout_enums.dart';

/// Immutable workout configuration: Walk → Run, repeated.
///
/// A *work step* is one walking or running phase in the planned sequence.
/// Work step `i` is walking when `i` is even and running when odd. A *round*
/// is one walk/run pair, so round `n` (1-based) is work steps `2n-2, 2n-1`.
class WorkoutPlan {
  const WorkoutPlan({
    this.walkDuration = defaultWalkDuration,
    this.runDuration = defaultRunDuration,
    this.targetRounds,
  });

  static const defaultWalkDuration = Duration(seconds: 120);
  static const defaultRunDuration = Duration(seconds: 120);
  static const defaultBreakDuration = Duration(seconds: 60);
  static const minPhaseDuration = Duration(seconds: 5);
  static const maxPhaseDuration = Duration(minutes: 180);
  static const maxRounds = 99;

  final Duration walkDuration;
  final Duration runDuration;

  /// `null` means continue until the user stops the workout.
  final int? targetRounds;

  bool get isOpenEnded => targetRounds == null;

  int? get totalWorkSteps => targetRounds == null ? null : targetRounds! * 2;

  PhaseType workTypeAt(int workIndex) =>
      workIndex.isEven ? PhaseType.walking : PhaseType.running;

  Duration durationFor(PhaseType type) => switch (type) {
    PhaseType.walking => walkDuration,
    PhaseType.running => runDuration,
    PhaseType.rest => throw ArgumentError('Rest is not part of the plan cycle'),
  };

  bool isFinalWorkStep(int workIndex) {
    final total = totalWorkSteps;
    return total != null && workIndex >= total - 1;
  }

  /// Returns an error message, or `null` when valid.
  static String? validatePhaseDuration(Duration d) {
    if (d < minPhaseDuration) return 'Minimum is 5 seconds';
    if (d > maxPhaseDuration) return 'Maximum is 180 minutes';
    return null;
  }

  static String? validateRounds(int? rounds) {
    if (rounds == null) return null;
    if (rounds < 1) return 'At least 1 round';
    if (rounds > maxRounds) return 'At most $maxRounds rounds';
    return null;
  }

  /// Throws [InvalidWorkoutPlanFailure] if this plan cannot be started.
  void validate() {
    final error =
        validatePhaseDuration(walkDuration) ??
        validatePhaseDuration(runDuration) ??
        validateRounds(targetRounds);
    if (error != null) throw InvalidWorkoutPlanFailure(error);
  }

  WorkoutPlan copyWith({
    Duration? walkDuration,
    Duration? runDuration,
    int? Function()? targetRounds,
  }) => WorkoutPlan(
    walkDuration: walkDuration ?? this.walkDuration,
    runDuration: runDuration ?? this.runDuration,
    targetRounds: targetRounds != null ? targetRounds() : this.targetRounds,
  );

  Map<String, Object?> toJson() => {
    'version': 1,
    'walkDurationMs': walkDuration.inMilliseconds,
    'runDurationMs': runDuration.inMilliseconds,
    'targetRounds': targetRounds,
  };

  factory WorkoutPlan.fromJson(Map<String, Object?> json) => WorkoutPlan(
    walkDuration: Duration(milliseconds: json['walkDurationMs']! as int),
    runDuration: Duration(milliseconds: json['runDurationMs']! as int),
    targetRounds: json['targetRounds'] as int?,
  );

  @override
  bool operator ==(Object other) =>
      other is WorkoutPlan &&
      other.walkDuration == walkDuration &&
      other.runDuration == runDuration &&
      other.targetRounds == targetRounds;

  @override
  int get hashCode => Object.hash(walkDuration, runDuration, targetRounds);
}
