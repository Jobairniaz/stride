import 'package:flutter_test/flutter_test.dart';
import 'package:stride/core/errors/app_failure.dart';
import 'package:stride/features/workout/domain/entities/workout_enums.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/entities/workout_snapshot.dart';
import 'package:stride/features/workout/domain/services/workout_engine.dart';

const engine = WorkoutEngine();
final t0 = DateTime.utc(2026, 11, 9, 6, 0);
const sec = Duration(seconds: 1);
Duration s(int n) => Duration(seconds: n);

WorkoutSnapshot startPlan([WorkoutPlan plan = const WorkoutPlan()]) =>
    engine.start(plan: plan, sessionId: 'S', now: t0);

WorkoutSnapshot active(EngineResult r) {
  expect(r.isFinished, isFalse);
  return r.snapshot!;
}

void main() {
  group('defaults and start', () {
    test('default walk and run durations are 120 seconds', () {
      const plan = WorkoutPlan();
      expect(plan.walkDuration, s(120));
      expect(plan.runDuration, s(120));
      expect(plan.targetRounds, isNull);
    });

    test('start enters the first walking phase with a deadline', () {
      final snap = startPlan();
      expect(snap.status, WorkoutStatus.running);
      expect(snap.current.type, PhaseType.walking);
      expect(snap.current.deadline, t0.add(s(120)));
      expect(snap.remainingAt(t0), s(120));
      expect(snap.currentRound, 1);
    });

    test('invalid plans are rejected', () {
      expect(
        () => engine.start(
          plan: const WorkoutPlan(walkDuration: Duration(seconds: 4)),
          sessionId: 'S',
          now: t0,
        ),
        throwsA(isA<InvalidWorkoutPlanFailure>()),
      );
      expect(
        () => engine.start(
          plan: const WorkoutPlan(targetRounds: 0),
          sessionId: 'S',
          now: t0,
        ),
        throwsA(isA<InvalidWorkoutPlanFailure>()),
      );
    });
  });

  group('alternation', () {
    test('walk transitions to run and run back to walk', () {
      var snap = startPlan();
      var r = engine.reconcile(snap, t0.add(s(119)));
      expect(active(r).current.type, PhaseType.walking);
      expect(r.transitions, isEmpty);

      r = engine.reconcile(snap, t0.add(s(120)));
      snap = active(r);
      expect(snap.current.type, PhaseType.running);
      expect(snap.current.startedAt, t0.add(s(120)));
      expect(r.transitions.single.to!.type, PhaseType.running);

      snap = active(engine.reconcile(snap, t0.add(s(240))));
      expect(snap.current.type, PhaseType.walking);
      expect(snap.currentRound, 2);
      expect(snap.completedRounds, 1);
    });

    test('remaining time is derived from the deadline, not ticks', () {
      final snap = startPlan();
      // Reconcile at irregular instants; remaining is always exact.
      for (final ms in [1, 333, 999, 45000, 119999]) {
        final now = t0.add(Duration(milliseconds: ms));
        final next = active(engine.reconcile(snap, now));
        expect(next.remainingAt(now), Duration(milliseconds: 120000 - ms));
      }
    });
  });

  group('finite and infinite rounds', () {
    test('finite round count completes exactly once at the right instant', () {
      final snap = startPlan(const WorkoutPlan(targetRounds: 2));
      // 2 rounds = 4 phases x 120 s = 480 s.
      final before = engine.reconcile(snap, t0.add(s(479)));
      expect(before.isFinished, isFalse);

      final r = engine.reconcile(snap, t0.add(s(600)));
      expect(r.isFinished, isTrue);
      final session = r.finished!;
      expect(session.endedAt, t0.add(s(480)));
      expect(session.completionReason, CompletionReason.targetReached);
      expect(session.completedRounds, 2);
      expect(session.walkingDuration, s(240));
      expect(session.runningDuration, s(240));
      expect(session.segments, hasLength(4));
      expect(r.transitions.where((t) => t.isFinish), hasLength(1));
    });

    test('infinite mode keeps alternating until stopped', () {
      final snap = startPlan();
      final r = engine.reconcile(snap, t0.add(const Duration(hours: 2)));
      expect(r.isFinished, isFalse);
      // 2 h / 2 min = 60 boundaries.
      expect(r.transitions, hasLength(60));
      expect(r.snapshot!.completedRounds, 30);
    });
  });

  group('pause and resume', () {
    test('pause freezes remaining and resume continues exactly', () {
      var snap = startPlan();
      snap = active(engine.pause(snap, t0.add(s(30))));
      expect(snap.isPaused, isTrue);
      expect(snap.remainingAt(t0.add(s(30))), s(90));
      // Long pause: nothing advances.
      final later = t0.add(const Duration(minutes: 30));
      expect(active(engine.reconcile(snap, later)).remainingAt(later), s(90));

      snap = active(engine.resume(snap, later));
      expect(snap.current.deadline, later.add(s(90)));
      final r = engine.reconcile(snap, later.add(s(90)));
      expect(active(r).current.type, PhaseType.running);
    });

    test('paused time is excluded from durations', () {
      var snap = startPlan(const WorkoutPlan(targetRounds: 1));
      snap = active(engine.pause(snap, t0.add(s(60))));
      snap = active(engine.resume(snap, t0.add(s(660)))); // 10 min pause
      final r = engine.reconcile(snap, t0.add(s(660 + 60 + 120)));
      final session = r.finished!;
      expect(session.walkingDuration, s(120));
      expect(session.runningDuration, s(120));
      expect(session.activeDuration, s(240));
      expect(session.totalElapsed, s(840)); // wall time includes the pause
    });

    test('pause and resume are idempotent', () {
      var snap = startPlan();
      final p1 = active(engine.pause(snap, t0.add(s(10))));
      final p2 = active(engine.pause(p1, t0.add(s(20))));
      expect(p2.current.frozenRemaining, s(110));
      snap = active(engine.resume(p2, t0.add(s(30))));
      final r2 = active(engine.resume(snap, t0.add(s(40))));
      expect(r2.current.deadline, t0.add(s(140)));
    });
  });

  group('skip', () {
    test('skip advances exactly one phase', () {
      var snap = startPlan();
      final r = engine.skip(snap, t0.add(s(10)));
      snap = active(r);
      expect(snap.current.type, PhaseType.running);
      expect(snap.current.deadline, t0.add(s(130)));
      expect(r.transitions, hasLength(1));
      final skipped = snap.completedSegments.single;
      expect(skipped.completion, SegmentCompletion.skipped);
      expect(skipped.actualDuration, s(10));
    });

    test('skip cannot finish a finite workout', () {
      var snap = startPlan(const WorkoutPlan(targetRounds: 1));
      snap = active(engine.skip(snap, t0.add(s(5)))); // now final run
      expect(snap.canSkip, isFalse);
      final r = engine.skip(snap, t0.add(s(10)));
      expect(r.isFinished, isFalse);
      expect(r.snapshot!.current.type, PhaseType.running);
    });

    test('skip is ignored while paused', () {
      final paused = active(engine.pause(startPlan(), t0.add(s(5))));
      final r = engine.skip(paused, t0.add(s(6)));
      expect(r.snapshot!.current.type, PhaseType.walking);
    });
  });

  group('inserted break', () {
    test('break interrupts work and the same phase resumes afterwards', () {
      var snap = startPlan();
      // Running from 120 s; break at 150 s with 90 s of run left.
      snap = active(engine.reconcile(snap, t0.add(s(120))));
      final r = engine.insertBreak(snap, s(60), t0.add(s(150)));
      snap = active(r);
      expect(snap.current.type, PhaseType.rest);
      expect(snap.current.insertedByUser, isTrue);
      expect(snap.nextPhase.type, PhaseType.running);
      expect(
        snap.completedSegments.last.completion,
        SegmentCompletion.interrupted,
      );
      expect(snap.completedSegments.last.actualDuration, s(30));

      snap = active(engine.reconcile(snap, t0.add(s(210))));
      expect(snap.current.type, PhaseType.running);
      expect(snap.current.isResumption, isTrue);
      expect(snap.current.plannedDuration, s(90));

      snap = active(engine.reconcile(snap, t0.add(s(300))));
      expect(snap.current.type, PhaseType.walking);
      expect(snap.completedRounds, 1);
    });

    test('break on the final phase still finishes after resuming', () {
      var snap = startPlan(const WorkoutPlan(targetRounds: 1));
      snap = active(engine.reconcile(snap, t0.add(s(120)))); // final run
      snap = active(engine.insertBreak(snap, s(60), t0.add(s(180))));
      final r = engine.reconcile(snap, t0.add(s(400)));
      expect(r.isFinished, isTrue);
      // 60 s run + 60 s rest + 60 s remaining run
      expect(r.finished!.endedAt, t0.add(s(300)));
      expect(r.finished!.runningDuration, s(120));
      expect(r.finished!.restDuration, s(60));
    });

    test('adding a break during rest extends the rest', () {
      var snap = active(engine.insertBreak(startPlan(), s(60), t0.add(s(10))));
      snap = active(engine.insertBreak(snap, s(30), t0.add(s(20))));
      expect(snap.current.type, PhaseType.rest);
      expect(snap.current.plannedDuration, s(90));
      expect(snap.remainingAt(t0.add(s(20))), s(80));
    });

    test('skipping a rest resumes the interrupted work phase', () {
      var snap = active(engine.insertBreak(startPlan(), s(60), t0.add(s(20))));
      snap = active(engine.skip(snap, t0.add(s(25))));
      expect(snap.current.type, PhaseType.walking);
      expect(snap.current.plannedDuration, s(100));
    });

    test('rejects invalid break durations', () {
      expect(
        () => engine.insertBreak(startPlan(), s(2), t0),
        throwsA(isA<InvalidWorkoutPlanFailure>()),
      );
    });
  });

  group('reconciliation after suspension', () {
    test('multiple elapsed phases reconcile in order', () {
      final snap = startPlan(
        const WorkoutPlan(
          walkDuration: Duration(seconds: 60),
          runDuration: Duration(seconds: 30),
        ),
      );
      // 0-60 walk | 60-90 run | 90-150 walk | 150-180 run | 180-240 walk
      final r = engine.reconcile(snap, t0.add(s(200)));
      final next = active(r);
      expect(r.transitions.map((t) => t.to!.type).toList(), [
        PhaseType.running,
        PhaseType.walking,
        PhaseType.running,
        PhaseType.walking,
      ]);
      expect(next.current.type, PhaseType.walking);
      expect(next.remainingAt(t0.add(s(200))), s(40));
      expect(next.completedSegments.map((s) => s.sequenceIndex), [0, 1, 2, 3]);
    });

    test('reconciling twice at the same instant is a no-op', () {
      final snap = startPlan();
      final a = active(engine.reconcile(snap, t0.add(s(130))));
      final r = engine.reconcile(a, t0.add(s(130)));
      expect(r.transitions, isEmpty);
      expect(r.snapshot!.current, a.current);
      expect(r.snapshot!.completedSegments, a.completedSegments);
    });
  });

  group('clock policy', () {
    test('backward clock jump preserves time already done', () {
      var snap = active(engine.reconcile(startPlan(), t0.add(s(30))));
      // Clock jumps back one hour.
      final jumped = t0.add(s(30)).subtract(const Duration(hours: 1));
      snap = active(engine.reconcile(snap, jumped));
      expect(snap.remainingAt(jumped), s(90));
      expect(snap.current.type, PhaseType.walking);
      final r = engine.reconcile(snap, jumped.add(s(90)));
      expect(active(r).current.type, PhaseType.running);
    });

    test('forward clock jump is treated as elapsed time', () {
      final snap = startPlan();
      final r = engine.reconcile(snap, t0.add(s(125)));
      expect(active(r).current.type, PhaseType.running);
    });
  });

  group('finish', () {
    test('user stop records the partial phase as interrupted', () {
      var snap = active(engine.reconcile(startPlan(), t0.add(s(150))));
      final session = engine.finish(
        snap,
        t0.add(s(150)),
        CompletionReason.userStopped,
      );
      expect(session.walkingDuration, s(120));
      expect(session.runningDuration, s(30));
      expect(session.completedRounds, 0);
      expect(session.segments.last.completion, SegmentCompletion.interrupted);
      expect(session.completionReason, CompletionReason.userStopped);
    });

    test('finish while paused counts only time before the pause', () {
      var snap = active(engine.pause(startPlan(), t0.add(s(40))));
      final session = engine.finish(
        snap,
        t0.add(const Duration(minutes: 20)),
        CompletionReason.userStopped,
      );
      expect(session.walkingDuration, s(40));
      expect(session.endedAt, t0.add(const Duration(minutes: 20)));
    });

    test('finish after target reached returns the target completion', () {
      final snap = startPlan(const WorkoutPlan(targetRounds: 1));
      final session = engine.finish(
        snap,
        t0.add(s(1000)),
        CompletionReason.userStopped,
      );
      expect(session.completionReason, CompletionReason.targetReached);
      expect(session.endedAt, t0.add(s(240)));
    });
  });

  group('projection', () {
    test('projects future boundaries and stops at finish', () {
      final snap = startPlan(const WorkoutPlan(targetRounds: 2));
      final upcoming = engine.projectUpcoming(snap);
      expect(upcoming.map((u) => u.at), [
        t0.add(s(120)),
        t0.add(s(240)),
        t0.add(s(360)),
        t0.add(s(480)),
      ]);
      expect(upcoming.last.isFinish, isTrue);
      expect(upcoming.first.to!.type, PhaseType.running);
    });

    test('nothing is projected while paused; open-ended is capped', () {
      final paused = active(engine.pause(startPlan(), t0.add(sec)));
      expect(engine.projectUpcoming(paused), isEmpty);
      expect(engine.projectUpcoming(startPlan(), limit: 10), hasLength(10));
    });
  });
}
