import '../../../../core/errors/app_failure.dart';
import '../entities/phase_segment.dart';
import '../entities/workout_enums.dart';
import '../entities/workout_plan.dart';
import '../entities/workout_session.dart';
import '../entities/workout_snapshot.dart';

/// A phase boundary that the engine crossed.
class PhaseTransition {
  const PhaseTransition({required this.at, required this.from, this.to});

  final DateTime at;
  final ActivePhase from;

  /// `null` when the workout finished at this boundary.
  final ActivePhase? to;

  bool get isFinish => to == null;
}

/// A future boundary, projected from the current snapshot assuming no pause
/// or user action. Used to schedule fallback notifications.
class UpcomingTransition {
  const UpcomingTransition({
    required this.at,
    required this.to,
    required this.round,
  });

  final DateTime at;

  /// `null` when the workout finishes at [at].
  final ActivePhase? to;
  final int? round;

  bool get isFinish => to == null;
}

/// Result of an engine command: either a still-active snapshot or a finished
/// session, plus any boundaries crossed while computing it.
class EngineResult {
  const EngineResult.active(WorkoutSnapshot this.snapshot, this.transitions)
    : finished = null;

  const EngineResult.finished(WorkoutSession this.finished, this.transitions)
    : snapshot = null;

  final WorkoutSnapshot? snapshot;
  final WorkoutSession? finished;
  final List<PhaseTransition> transitions;

  bool get isFinished => finished != null;
}

/// Pure, deterministic workout state machine.
///
/// Rules (see docs/WORKOUT_RULES.md):
/// * Time is derived from deadlines; nothing counts ticks.
/// * [reconcile] advances through every elapsed boundary, in order.
/// * Pause freezes remaining time; resume sets a new deadline. Both are
///   idempotent.
/// * An inserted break interrupts the current work phase; after the break the
///   interrupted phase resumes with its remaining time.
/// * Skip advances exactly one phase and is a no-op on the final phase of a
///   finite workout.
/// * Clock policy: if `now` is earlier than the last reconciliation (the wall
///   clock moved backwards), the running deadline is shifted back by the same
///   amount so time already done is preserved. Forward jumps are
///   indistinguishable from real elapsed time and are treated as such.
class WorkoutEngine {
  const WorkoutEngine();

  /// Beyond this gap since the last checkpoint, recovery only offers
  /// save-at-checkpoint or discard; resuming would fabricate hours of phases.
  static const maxResumeGap = Duration(hours: 6);

  static String phaseId(String sessionId, int sequenceIndex) =>
      '${sessionId}_p$sequenceIndex';

  WorkoutSnapshot start({
    required WorkoutPlan plan,
    required String sessionId,
    required DateTime now,
  }) {
    plan.validate();
    final type = plan.workTypeAt(0);
    final phase = _newPhase(
      sessionId: sessionId,
      sequenceIndex: 0,
      type: type,
      planned: plan.durationFor(type),
      at: now,
      insertedByUser: false,
      isResumption: false,
    );
    return WorkoutSnapshot(
      sessionId: sessionId,
      plan: plan,
      status: WorkoutStatus.running,
      workoutStartedAt: now,
      current: phase,
      workIndex: 0,
      resumeRemaining: null,
      completedSegments: const [],
      lastReconciledAt: now,
    );
  }

  EngineResult reconcile(WorkoutSnapshot snapshot, DateTime now) {
    var snap = _rebaseForClockJump(snapshot, now);
    if (snap.isPaused) {
      return EngineResult.active(
        snap.copyWith(lastReconciledAt: now),
        const [],
      );
    }
    if (now.isBefore(snap.current.deadline!)) {
      return EngineResult.active(
        snap.copyWith(lastReconciledAt: now),
        const [],
      );
    }

    // Mutable accumulator so long catch-ups stay linear.
    final segments = [...snap.completedSegments];
    final transitions = <PhaseTransition>[];
    while (!now.isBefore(snap.current.deadline!)) {
      final at = snap.current.deadline!;
      segments.add(
        _close(
          snap.current,
          endedAt: at,
          actual: snap.current.plannedDuration,
          completion: SegmentCompletion.completed,
        ),
      );
      final step = _advance(snap, segments, at);
      transitions.add(step.transition);
      if (step.finished != null) {
        return EngineResult.finished(step.finished!, transitions);
      }
      snap = step.snapshot!;
    }
    return EngineResult.active(
      snap.copyWith(
        completedSegments: List.unmodifiable(segments),
        lastReconciledAt: now,
      ),
      transitions,
    );
  }

  EngineResult pause(WorkoutSnapshot snapshot, DateTime now) {
    final r = reconcile(snapshot, now);
    final snap = r.snapshot;
    if (snap == null || snap.isPaused) return r;
    final c = snap.current;
    return EngineResult.active(
      snap.copyWith(
        status: WorkoutStatus.paused,
        current: c.copyWith(
          deadline: () => null,
          frozenRemaining: () => c.remainingAt(now),
        ),
      ),
      r.transitions,
    );
  }

  EngineResult resume(WorkoutSnapshot snapshot, DateTime now) {
    if (!snapshot.isPaused) return reconcile(snapshot, now);
    final c = snapshot.current;
    return EngineResult.active(
      snapshot.copyWith(
        status: WorkoutStatus.running,
        current: c.copyWith(
          deadline: () => now.add(c.frozenRemaining!),
          frozenRemaining: () => null,
        ),
        lastReconciledAt: now,
      ),
      const [],
    );
  }

  EngineResult skip(WorkoutSnapshot snapshot, DateTime now) {
    final r = reconcile(snapshot, now);
    final snap = r.snapshot;
    if (snap == null || !snap.canSkip) return r;
    final segments = [
      ...snap.completedSegments,
      _close(
        snap.current,
        endedAt: now,
        actual: snap.current.consumedAt(now),
        completion: SegmentCompletion.skipped,
      ),
    ];
    final step = _advance(snap, segments, now);
    // canSkip guarantees the workout cannot finish here.
    return EngineResult.active(
      step.snapshot!.copyWith(
        completedSegments: List.unmodifiable(segments),
        lastReconciledAt: now,
      ),
      [...r.transitions, step.transition],
    );
  }

  /// Inserts an ad-hoc rest. During a rest, extends the rest instead.
  EngineResult insertBreak(
    WorkoutSnapshot snapshot,
    Duration duration,
    DateTime now,
  ) {
    final error = WorkoutPlan.validatePhaseDuration(duration);
    if (error != null) throw InvalidWorkoutPlanFailure(error);

    final r = reconcile(snapshot, now);
    final snap = r.snapshot;
    if (snap == null || !snap.canInsertBreak) return r;
    final c = snap.current;

    if (!c.type.isWork) {
      return EngineResult.active(
        snap.copyWith(
          current: c.copyWith(
            plannedDuration: c.plannedDuration + duration,
            deadline: () => c.deadline!.add(duration),
          ),
        ),
        r.transitions,
      );
    }

    final rest = _newPhase(
      sessionId: snap.sessionId,
      sequenceIndex: snap.nextSequenceIndex,
      type: PhaseType.rest,
      planned: duration,
      at: now,
      insertedByUser: true,
      isResumption: false,
    );
    return EngineResult.active(
      snap.copyWith(
        current: rest,
        resumeRemaining: () => c.remainingAt(now),
        completedSegments: List.unmodifiable([
          ...snap.completedSegments,
          _close(
            c,
            endedAt: now,
            actual: c.consumedAt(now),
            completion: SegmentCompletion.interrupted,
          ),
        ]),
        lastReconciledAt: now,
      ),
      [...r.transitions, PhaseTransition(at: now, from: c, to: rest)],
    );
  }

  /// Ends the workout at [at]. If the target was already reached before
  /// [at], returns that completed session instead.
  WorkoutSession finish(
    WorkoutSnapshot snapshot,
    DateTime at,
    CompletionReason reason,
  ) {
    final r = reconcile(snapshot, at);
    if (r.finished != null) return r.finished!;
    final snap = r.snapshot!;
    final consumed = snap.current.consumedAt(at);
    final segments = [
      ...snap.completedSegments,
      if (consumed > Duration.zero)
        _close(
          snap.current,
          endedAt: at,
          actual: consumed,
          completion: SegmentCompletion.interrupted,
        ),
    ];
    final endedAt = at.isBefore(snap.workoutStartedAt)
        ? snap.workoutStartedAt.add(snap.movingElapsedAt(at))
        : at;
    return WorkoutSession.fromSegments(
      id: snap.sessionId,
      startedAt: snap.workoutStartedAt,
      endedAt: endedAt,
      reason: reason,
      completedRounds: snap.completedRounds,
      plan: snap.plan,
      segments: segments,
    );
  }

  /// Future boundaries if the workout continues untouched.
  List<UpcomingTransition> projectUpcoming(
    WorkoutSnapshot snapshot, {
    int limit = 30,
  }) {
    if (snapshot.isPaused) return const [];
    final result = <UpcomingTransition>[];
    final segments = <PhaseSegment>[];
    var snap = snapshot;
    while (result.length < limit) {
      final at = snap.current.deadline!;
      segments.add(
        _close(
          snap.current,
          endedAt: at,
          actual: snap.current.plannedDuration,
          completion: SegmentCompletion.completed,
        ),
      );
      final step = _advance(snap, segments, at);
      final next = step.snapshot;
      result.add(
        UpcomingTransition(
          at: at,
          to: next?.current,
          round: next?.currentRound,
        ),
      );
      if (next == null) break;
      snap = next;
    }
    return result;
  }

  // ---------------------------------------------------------------------------

  WorkoutSnapshot _rebaseForClockJump(WorkoutSnapshot s, DateTime now) {
    if (!now.isBefore(s.lastReconciledAt) || s.isPaused) return s;
    final delta = s.lastReconciledAt.difference(now);
    return s.copyWith(
      current: s.current.copyWith(
        deadline: () => s.current.deadline!.subtract(delta),
      ),
      lastReconciledAt: now,
    );
  }

  /// Moves past the current phase (whose segment is already the last element
  /// of [segments]).
  _Step _advance(
    WorkoutSnapshot snap,
    List<PhaseSegment> segments,
    DateTime at,
  ) {
    final from = snap.current;

    if (!from.type.isWork) {
      final type = snap.plan.workTypeAt(snap.workIndex);
      final resume = snap.resumeRemaining;
      final phase = _newPhase(
        sessionId: snap.sessionId,
        sequenceIndex: snap.nextSequenceIndex,
        type: type,
        planned: resume ?? snap.plan.durationFor(type),
        at: at,
        insertedByUser: false,
        isResumption: resume != null,
      );
      return _Step.active(
        snap.copyWith(
          current: phase,
          resumeRemaining: () => null,
          completedSegments: segments,
        ),
        PhaseTransition(at: at, from: from, to: phase),
      );
    }

    final nextWork = snap.workIndex + 1;
    final total = snap.plan.totalWorkSteps;
    if (total != null && nextWork >= total) {
      return _Step.finished(
        WorkoutSession.fromSegments(
          id: snap.sessionId,
          startedAt: snap.workoutStartedAt,
          endedAt: at,
          reason: CompletionReason.targetReached,
          completedRounds: snap.plan.targetRounds!,
          plan: snap.plan,
          segments: List.of(segments),
        ),
        PhaseTransition(at: at, from: from),
      );
    }

    final type = snap.plan.workTypeAt(nextWork);
    final phase = _newPhase(
      sessionId: snap.sessionId,
      sequenceIndex: snap.nextSequenceIndex,
      type: type,
      planned: snap.plan.durationFor(type),
      at: at,
      insertedByUser: false,
      isResumption: false,
    );
    return _Step.active(
      snap.copyWith(
        current: phase,
        workIndex: nextWork,
        completedSegments: segments,
      ),
      PhaseTransition(at: at, from: from, to: phase),
    );
  }

  ActivePhase _newPhase({
    required String sessionId,
    required int sequenceIndex,
    required PhaseType type,
    required Duration planned,
    required DateTime at,
    required bool insertedByUser,
    required bool isResumption,
  }) => ActivePhase(
    id: phaseId(sessionId, sequenceIndex),
    sequenceIndex: sequenceIndex,
    type: type,
    plannedDuration: planned,
    startedAt: at,
    deadline: at.add(planned),
    frozenRemaining: null,
    insertedByUser: insertedByUser,
    isResumption: isResumption,
  );

  PhaseSegment _close(
    ActivePhase phase, {
    required DateTime endedAt,
    required Duration actual,
    required SegmentCompletion completion,
  }) => PhaseSegment(
    id: phase.id,
    sequenceIndex: phase.sequenceIndex,
    type: phase.type,
    plannedDuration: phase.plannedDuration,
    actualDuration: actual,
    startedAt: phase.startedAt,
    endedAt: endedAt,
    insertedByUser: phase.insertedByUser,
    completion: completion,
  );
}

class _Step {
  _Step.active(WorkoutSnapshot this.snapshot, this.transition)
    : finished = null;
  _Step.finished(WorkoutSession this.finished, this.transition)
    : snapshot = null;

  final WorkoutSnapshot? snapshot;
  final WorkoutSession? finished;
  final PhaseTransition transition;
}
