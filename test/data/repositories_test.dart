import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stride/core/errors/app_failure.dart';
import 'package:stride/features/profile/data/drift_profile_repository.dart';
import 'package:stride/features/profile/domain/calorie_estimator.dart';
import 'package:stride/features/profile/domain/units.dart';
import 'package:stride/features/workout/data/drift_workout_repository.dart';
import 'package:stride/features/workout/domain/entities/workout_enums.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/services/workout_engine.dart';
import 'package:stride/platform/storage/app_database.dart';

import '../helpers/fake_clock.dart';

void main() {
  late AppDatabase db;
  late FakeClock clock;
  late DriftWorkoutRepository workouts;
  late DriftProfileRepository profiles;
  const engine = WorkoutEngine();
  final t0 = DateTime.utc(2026, 11, 9, 6);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    clock = FakeClock(t0);
    workouts = DriftWorkoutRepository(db, clock);
    profiles = DriftProfileRepository(db, clock);
  });
  tearDown(() => db.close());

  group('active snapshot', () {
    test('saves, updates and loads a running snapshot', () async {
      var snap = engine.start(
        plan: const WorkoutPlan(targetRounds: 3),
        sessionId: 'S1',
        now: t0,
      );
      await workouts.saveActiveSnapshot(snap);
      snap = engine
          .insertBreak(
            snap,
            const Duration(seconds: 45),
            t0.add(const Duration(seconds: 30)),
          )
          .snapshot!;
      await workouts.saveActiveSnapshot(snap);

      final loaded = (await workouts.loadActiveSnapshot())!;
      expect(loaded.sessionId, 'S1');
      expect(loaded.plan, snap.plan);
      expect(loaded.current, snap.current);
      expect(loaded.resumeRemaining, const Duration(seconds: 90));
      expect(loaded.completedSegments, snap.completedSegments);
      expect(loaded.lastReconciledAt, snap.lastReconciledAt);
    });

    test('paused snapshot keeps frozen remaining', () async {
      final snap = engine
          .pause(
            engine.start(plan: const WorkoutPlan(), sessionId: 'S', now: t0),
            t0.add(const Duration(seconds: 20)),
          )
          .snapshot!;
      await workouts.saveActiveSnapshot(snap);
      final loaded = (await workouts.loadActiveSnapshot())!;
      expect(loaded.isPaused, isTrue);
      expect(loaded.current.frozenRemaining, const Duration(seconds: 100));
    });

    test('only one unfinished workout is kept', () async {
      await workouts.saveActiveSnapshot(
        engine.start(plan: const WorkoutPlan(), sessionId: 'A', now: t0),
      );
      await workouts.saveActiveSnapshot(
        engine.start(plan: const WorkoutPlan(), sessionId: 'B', now: t0),
      );
      expect((await workouts.loadActiveSnapshot())!.sessionId, 'B');
      expect(await db.select(db.activeWorkoutSnapshots).get(), hasLength(1));
    });
  });

  group('completed sessions', () {
    Future<void> completeOne(String id, DateTime start) async {
      final snap = engine.start(
        plan: const WorkoutPlan(targetRounds: 1),
        sessionId: id,
        now: start,
      );
      await workouts.saveActiveSnapshot(snap);
      final session = engine
          .reconcile(snap, start.add(const Duration(minutes: 5)))
          .finished!;
      await workouts.saveCompletedSession(
        session.withCalorieEstimate(
          CalorieEstimator.estimate(
            walking: session.walkingDuration,
            running: session.runningDuration,
            rest: session.restDuration,
            weightGrams: 70000,
          ),
        ),
      );
    }

    test('saving writes session + segments and clears the snapshot', () async {
      await completeOne('S', t0);
      expect(await workouts.loadActiveSnapshot(), isNull);
      final s = (await workouts.watchSession('S').first)!;
      expect(s.segments, hasLength(2));
      expect(s.walkingDuration, const Duration(minutes: 2));
      expect(s.runningDuration, const Duration(minutes: 2));
      expect(s.completionReason, CompletionReason.targetReached);
      expect(s.calorieEstimate!.weightGrams, 70000);
      expect(s.calorieEstimate!.methodVersion, 'met-v1');
    });

    test('duplicate completion does not double count', () async {
      await completeOne('S', t0);
      final again = (await workouts.watchSession('S').first)!;
      await workouts.saveCompletedSession(again);
      final month = await workouts
          .watchSessionsBetween(
            t0.subtract(const Duration(days: 1)),
            t0.add(const Duration(days: 1)),
          )
          .first;
      expect(month, hasLength(1));
      expect(await db.select(db.workoutPhaseSegments).get(), hasLength(2));
    });

    test('a failed transaction rolls back completely', () async {
      final snap = engine.start(
        plan: const WorkoutPlan(targetRounds: 1),
        sessionId: 'X',
        now: t0,
      );
      final session = engine
          .reconcile(snap, t0.add(const Duration(minutes: 5)))
          .finished!;
      // A pre-existing segment with the same id forces a PK conflict.
      await db
          .into(db.workoutSessions)
          .insert(
            WorkoutSessionsCompanion.insert(
              id: 'other',
              startedAtUtc: 0,
              status: 'completed',
              totalElapsedMs: 0,
              activeDurationMs: 0,
              walkingDurationMs: 0,
              runningDurationMs: 0,
              restDurationMs: 0,
              completedRounds: 0,
              planSnapshotJson: '{}',
              createdAtUtc: 0,
              updatedAtUtc: 0,
            ),
          );
      await db
          .into(db.workoutPhaseSegments)
          .insert(
            WorkoutPhaseSegmentsCompanion.insert(
              id: session.segments.first.id,
              sessionId: 'other',
              sequenceIndex: 0,
              phaseType: 'walking',
              plannedDurationMs: 0,
              actualDurationMs: 0,
              startedAtUtc: 0,
              insertedByUser: false,
              completionStatus: 'completed',
            ),
          );
      await expectLater(
        workouts.saveCompletedSession(session),
        throwsA(isA<PersistenceFailure>()),
      );
      expect(await workouts.watchSession('X').first, isNull);
    });

    test('queries by month boundaries and lists start times', () async {
      await completeOne('oct', DateTime.utc(2026, 10, 31, 12));
      await completeOne('nov', DateTime.utc(2026, 11, 15, 12));
      final nov = await workouts
          .watchSessionsBetween(DateTime.utc(2026, 11), DateTime.utc(2026, 12))
          .first;
      expect(nov.map((s) => s.id), ['nov']);
      expect(await workouts.watchAllSessionStarts().first, hasLength(2));
      expect((await workouts.watchLatestSession().first)!.id, 'nov');
    });

    test('delete removes the session and its segments', () async {
      await completeOne('S', t0);
      await workouts.deleteSession('S');
      expect(await workouts.watchSession('S').first, isNull);
      expect(await db.select(db.workoutPhaseSegments).get(), isEmpty);
    });

    test('clear history removes everything', () async {
      await completeOne('A', t0);
      await completeOne('B', t0.add(const Duration(days: 1)));
      await workouts.clearHistory();
      expect(await workouts.watchAllSessionStarts().first, isEmpty);
      expect(await db.select(db.workoutPhaseSegments).get(), isEmpty);
    });
  });

  group('profile', () {
    test('profile is optional and defaults to metric', () async {
      final p = await profiles.loadProfile();
      expect(p.heightMm, isNull);
      expect(p.heightUnit, HeightUnit.cm);
    });

    test('height and units can be saved, edited and cleared', () async {
      await profiles.saveHeight(1750);
      await profiles.saveUnits(weightUnit: WeightUnit.lb);
      var p = await profiles.loadProfile();
      expect(p.heightMm, 1750);
      expect(p.weightUnit, WeightUnit.lb);
      await profiles.saveHeight(null);
      p = await profiles.loadProfile();
      expect(p.heightMm, isNull);
      expect(p.weightUnit, WeightUnit.lb);
    });

    test('invalid height is rejected', () async {
      await expectLater(
        profiles.saveHeight(10),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('weight entries are dated and history is retained', () async {
      await profiles.addWeight(
        measuredAt: DateTime.utc(2026, 10, 1),
        weightGrams: 82000,
      );
      await profiles.addWeight(
        measuredAt: DateTime.utc(2026, 11, 1),
        weightGrams: 80000,
        note: '  after holiday ',
      );
      final all = await profiles.watchWeights().first;
      expect(all.map((w) => w.weightGrams), [80000, 82000]);
      expect(all.first.note, 'after holiday');
      // Weight in effect at a given time.
      expect(
        (await profiles.weightAt(DateTime.utc(2026, 10, 15)))!.weightGrams,
        82000,
      );
      expect(await profiles.weightAt(DateTime.utc(2026, 9, 1)), isNull);
    });

    test('historical estimates are unchanged by a new weight entry', () async {
      await profiles.addWeight(measuredAt: t0, weightGrams: 70000);
      final snap = engine.start(
        plan: const WorkoutPlan(targetRounds: 1),
        sessionId: 'S',
        now: t0,
      );
      final s = engine
          .reconcile(snap, t0.add(const Duration(hours: 1)))
          .finished!;
      final weight = await profiles.weightAt(s.endedAt);
      await workouts.saveCompletedSession(
        s.withCalorieEstimate(
          CalorieEstimator.estimate(
            walking: s.walkingDuration,
            running: s.runningDuration,
            rest: s.restDuration,
            weightGrams: weight!.weightGrams,
          ),
        ),
      );
      final before = (await workouts.watchSession('S').first)!.calorieEstimate!;
      await profiles.addWeight(
        measuredAt: t0.add(const Duration(days: 1)),
        weightGrams: 90000,
      );
      final after = (await workouts.watchSession('S').first)!.calorieEstimate!;
      expect(after.weightGrams, 70000);
      expect(after.exerciseKcal, before.exerciseKcal);
    });

    test('delete profile data removes height and weights only', () async {
      await profiles.saveHeight(1800);
      await profiles.addWeight(measuredAt: t0, weightGrams: 75000);
      await profiles.deleteAllProfileData();
      expect((await profiles.loadProfile()).heightMm, isNull);
      expect(await profiles.watchWeights().first, isEmpty);
    });
  });

  test('schema version is 1 with foreign keys enabled', () async {
    expect(db.schemaVersion, 1);
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.data.values.first, 1);
  });

  test(
    'deleting a session row cascades to segments at the SQL level',
    () async {
      final snap = engine.start(
        plan: const WorkoutPlan(targetRounds: 1),
        sessionId: 'C',
        now: t0,
      );
      await workouts.saveCompletedSession(
        engine.reconcile(snap, t0.add(const Duration(hours: 1))).finished!,
      );
      await (db.delete(
        db.workoutSessions,
      )..where((t) => t.id.equals('C'))).go();
      expect(await db.select(db.workoutPhaseSegments).get(), isEmpty);
    },
  );
}
