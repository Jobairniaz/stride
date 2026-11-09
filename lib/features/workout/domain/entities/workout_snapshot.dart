import 'phase_segment.dart';
import 'workout_enums.dart';
import 'workout_plan.dart';

/// The phase instance that is currently active.
///
/// Remaining time is *derived*: while running it is `deadline - now`; while
/// paused it is the frozen remaining value. Nothing counts ticks.
class ActivePhase {
  const ActivePhase({
    required this.id,
    required this.sequenceIndex,
    required this.type,
    required this.plannedDuration,
    required this.startedAt,
    required this.deadline,
    required this.frozenRemaining,
    required this.insertedByUser,
    required this.isResumption,
  }) : assert(
         (deadline == null) != (frozenRemaining == null),
         'Exactly one of deadline / frozenRemaining must be set',
       );

  final String id;
  final int sequenceIndex;
  final PhaseType type;
  final Duration plannedDuration;
  final DateTime startedAt;

  /// Set while running.
  final DateTime? deadline;

  /// Set while paused.
  final Duration? frozenRemaining;

  /// Ad-hoc break inserted by the user.
  final bool insertedByUser;

  /// A work phase continuing after an inserted break ("Resume running").
  final bool isResumption;

  bool get isPaused => frozenRemaining != null;

  Duration remainingAt(DateTime now) {
    final frozen = frozenRemaining;
    if (frozen != null) return frozen;
    final left = deadline!.difference(now);
    if (left.isNegative) return Duration.zero;
    if (left > plannedDuration) return plannedDuration;
    return left;
  }

  /// Active (non-paused) time spent in this phase so far.
  Duration consumedAt(DateTime now) => plannedDuration - remainingAt(now);

  ActivePhase copyWith({
    Duration? plannedDuration,
    DateTime? startedAt,
    DateTime? Function()? deadline,
    Duration? Function()? frozenRemaining,
  }) => ActivePhase(
    id: id,
    sequenceIndex: sequenceIndex,
    type: type,
    plannedDuration: plannedDuration ?? this.plannedDuration,
    startedAt: startedAt ?? this.startedAt,
    deadline: deadline != null ? deadline() : this.deadline,
    frozenRemaining: frozenRemaining != null
        ? frozenRemaining()
        : this.frozenRemaining,
    insertedByUser: insertedByUser,
    isResumption: isResumption,
  );

  @override
  bool operator ==(Object other) =>
      other is ActivePhase &&
      other.id == id &&
      other.sequenceIndex == sequenceIndex &&
      other.type == type &&
      other.plannedDuration == plannedDuration &&
      other.startedAt == startedAt &&
      other.deadline == deadline &&
      other.frozenRemaining == frozenRemaining &&
      other.insertedByUser == insertedByUser &&
      other.isResumption == isResumption;

  @override
  int get hashCode => Object.hash(
    id,
    sequenceIndex,
    type,
    plannedDuration,
    startedAt,
    deadline,
    frozenRemaining,
    insertedByUser,
    isResumption,
  );
}

/// What comes after the current phase, for the "Next" preview.
class NextPhasePreview {
  const NextPhasePreview({required this.type, required this.isFinish});

  const NextPhasePreview.finish() : type = null, isFinish = true;

  final PhaseType? type;
  final bool isFinish;
}

/// Durable, immutable state of an unfinished workout. This is what gets
/// persisted for process-death recovery.
class WorkoutSnapshot {
  const WorkoutSnapshot({
    required this.sessionId,
    required this.plan,
    required this.status,
    required this.workoutStartedAt,
    required this.current,
    required this.workIndex,
    required this.resumeRemaining,
    required this.completedSegments,
    required this.lastReconciledAt,
  }) : assert(
         status == WorkoutStatus.running || status == WorkoutStatus.paused,
       );

  final String sessionId;
  final WorkoutPlan plan;

  /// Only [WorkoutStatus.running] or [WorkoutStatus.paused].
  final WorkoutStatus status;
  final DateTime workoutStartedAt;
  final ActivePhase current;

  /// The current work step, or (during a rest) the work step that resumes
  /// after the rest.
  final int workIndex;

  /// During an inserted rest: the remaining time of the interrupted work
  /// phase, which resumes afterwards.
  final Duration? resumeRemaining;

  final List<PhaseSegment> completedSegments;
  final DateTime lastReconciledAt;

  bool get isPaused => status == WorkoutStatus.paused;

  /// 1-based round the user is in.
  int get currentRound => workIndex ~/ 2 + 1;

  /// Walk/run pairs fully passed.
  int get completedRounds => workIndex ~/ 2;

  int get nextSequenceIndex => current.sequenceIndex + 1;

  Duration remainingAt(DateTime now) => current.remainingAt(now);

  /// Walking + running + rest time, excluding pauses.
  Duration movingElapsedAt(DateTime now) {
    var total = current.consumedAt(now);
    for (final s in completedSegments) {
      total += s.actualDuration;
    }
    return total;
  }

  NextPhasePreview get nextPhase {
    if (!current.type.isWork) {
      return NextPhasePreview(
        type: plan.workTypeAt(workIndex),
        isFinish: false,
      );
    }
    if (plan.isFinalWorkStep(workIndex)) return const NextPhasePreview.finish();
    return NextPhasePreview(
      type: plan.workTypeAt(workIndex + 1),
      isFinish: false,
    );
  }

  /// Skip is disabled on the final phase of a finite workout so it can never
  /// accidentally finish the workout; the user must use End instead.
  bool get canSkip =>
      !isPaused && !(current.type.isWork && plan.isFinalWorkStep(workIndex));

  bool get canInsertBreak => !isPaused;

  WorkoutSnapshot copyWith({
    WorkoutStatus? status,
    ActivePhase? current,
    int? workIndex,
    Duration? Function()? resumeRemaining,
    List<PhaseSegment>? completedSegments,
    DateTime? lastReconciledAt,
  }) => WorkoutSnapshot(
    sessionId: sessionId,
    plan: plan,
    status: status ?? this.status,
    workoutStartedAt: workoutStartedAt,
    current: current ?? this.current,
    workIndex: workIndex ?? this.workIndex,
    resumeRemaining: resumeRemaining != null
        ? resumeRemaining()
        : this.resumeRemaining,
    completedSegments: completedSegments ?? this.completedSegments,
    lastReconciledAt: lastReconciledAt ?? this.lastReconciledAt,
  );
}
