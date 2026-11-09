import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/clock/clock.dart';
import '../../../core/errors/app_failure.dart';
import '../../../platform/storage/app_database.dart';
import '../../profile/domain/calorie_estimator.dart';
import '../domain/entities/phase_segment.dart';
import '../domain/entities/workout_enums.dart';
import '../domain/entities/workout_plan.dart';
import '../domain/entities/workout_session.dart';
import '../domain/entities/workout_snapshot.dart';
import '../domain/repositories/workout_repository.dart';

class DriftWorkoutRepository implements WorkoutRepository {
  DriftWorkoutRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  static DateTime _utc(int ms) =>
      DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

  /// Storage boundary: converts database exceptions (which arrive in several
  /// wrapped forms depending on isolate setup) into a typed failure that
  /// keeps the original cause. Errors (programming bugs) are not caught.
  Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } on AppFailure {
      rethrow;
    } on Exception catch (e) {
      throw PersistenceFailure('Could not $action', cause: e);
    }
  }

  // --- Active snapshot -------------------------------------------------------

  @override
  Future<void> saveActiveSnapshot(
    WorkoutSnapshot s,
  ) => _guard('save the active workout', () async {
    final c = s.current;
    await _db.transaction(() async {
      // Only one unfinished workout may exist.
      await (_db.delete(
        _db.activeWorkoutSnapshots,
      )..where((t) => t.sessionId.equals(s.sessionId).not())).go();
      await _db
          .into(_db.activeWorkoutSnapshots)
          .insertOnConflictUpdate(
            ActiveWorkoutSnapshotsCompanion.insert(
              sessionId: s.sessionId,
              status: s.status.name,
              currentPhaseId: c.id,
              currentPhaseType: c.type.name,
              currentSequenceIndex: c.sequenceIndex,
              phasePlannedMs: c.plannedDuration.inMilliseconds,
              phaseDeadlineUtcMs: Value(c.deadline?.millisecondsSinceEpoch),
              frozenRemainingMs: Value(c.frozenRemaining?.inMilliseconds),
              phaseStartedAtUtcMs: c.startedAt.millisecondsSinceEpoch,
              phaseInsertedByUser: c.insertedByUser,
              phaseIsResumption: c.isResumption,
              workoutStartedAtUtcMs: s.workoutStartedAt.millisecondsSinceEpoch,
              lastReconciledAtUtcMs: s.lastReconciledAt.millisecondsSinceEpoch,
              workIndex: s.workIndex,
              currentRound: s.currentRound,
              resumeRemainingMs: Value(s.resumeRemaining?.inMilliseconds),
              serializedPlanSnapshot: jsonEncode(s.plan.toJson()),
              completedSegmentsJson: jsonEncode([
                for (final seg in s.completedSegments) seg.toJson(),
              ]),
            ),
          );
    });
  });

  @override
  Future<WorkoutSnapshot?> loadActiveSnapshot() =>
      _guard('load the unfinished workout', () async {
        final row = await (_db.select(
          _db.activeWorkoutSnapshots,
        )..limit(1)).getSingleOrNull();
        if (row == null) return null;
        final status = WorkoutStatus.values.byName(row.status);
        return WorkoutSnapshot(
          sessionId: row.sessionId,
          plan: WorkoutPlan.fromJson(
            jsonDecode(row.serializedPlanSnapshot) as Map<String, Object?>,
          ),
          status: status,
          workoutStartedAt: _utc(row.workoutStartedAtUtcMs),
          current: ActivePhase(
            id: row.currentPhaseId,
            sequenceIndex: row.currentSequenceIndex,
            type: PhaseType.values.byName(row.currentPhaseType),
            plannedDuration: Duration(milliseconds: row.phasePlannedMs),
            startedAt: _utc(row.phaseStartedAtUtcMs),
            deadline: row.phaseDeadlineUtcMs == null
                ? null
                : _utc(row.phaseDeadlineUtcMs!),
            frozenRemaining: row.frozenRemainingMs == null
                ? null
                : Duration(milliseconds: row.frozenRemainingMs!),
            insertedByUser: row.phaseInsertedByUser,
            isResumption: row.phaseIsResumption,
          ),
          workIndex: row.workIndex,
          resumeRemaining: row.resumeRemainingMs == null
              ? null
              : Duration(milliseconds: row.resumeRemainingMs!),
          completedSegments: List.unmodifiable([
            for (final j in jsonDecode(row.completedSegmentsJson) as List)
              PhaseSegment.fromJson(j as Map<String, Object?>),
          ]),
          lastReconciledAt: _utc(row.lastReconciledAtUtcMs),
        );
      });

  @override
  Future<void> clearActiveSnapshot() => _guard(
    'clear the unfinished workout',
    () => _db.delete(_db.activeWorkoutSnapshots).go(),
  );

  // --- Completed sessions ----------------------------------------------------

  @override
  Future<void> saveCompletedSession(WorkoutSession s) =>
      _guard('save the workout', () async {
        final nowMs = _clock.now().millisecondsSinceEpoch;
        final estimate = s.calorieEstimate;
        await _db.transaction(() async {
          final existing = await (_db.select(
            _db.workoutSessions,
          )..where((t) => t.id.equals(s.id))).getSingleOrNull();
          if (existing == null) {
            await _db
                .into(_db.workoutSessions)
                .insert(
                  WorkoutSessionsCompanion.insert(
                    id: s.id,
                    startedAtUtc: s.startedAt.millisecondsSinceEpoch,
                    endedAtUtc: Value(s.endedAt.millisecondsSinceEpoch),
                    status: WorkoutStatus.completed.name,
                    completionReason: Value(s.completionReason.storageKey),
                    totalElapsedMs: s.totalElapsed.inMilliseconds,
                    activeDurationMs: s.activeDuration.inMilliseconds,
                    walkingDurationMs: s.walkingDuration.inMilliseconds,
                    runningDurationMs: s.runningDuration.inMilliseconds,
                    restDurationMs: s.restDuration.inMilliseconds,
                    completedRounds: s.completedRounds,
                    planSnapshotJson: jsonEncode(s.plan.toJson()),
                    estimatedCaloriesKcal: Value(estimate?.exerciseKcal),
                    calorieMethodVersion: Value(estimate?.methodVersion),
                    calorieWeightGrams: Value(estimate?.weightGrams),
                    calorieAssumptionsJson: Value(estimate?.assumptionsJson()),
                    createdAtUtc: nowMs,
                    updatedAtUtc: nowMs,
                  ),
                );
            await _db.batch((b) {
              b.insertAll(_db.workoutPhaseSegments, [
                for (final seg in s.segments)
                  WorkoutPhaseSegmentsCompanion.insert(
                    id: seg.id,
                    sessionId: s.id,
                    sequenceIndex: seg.sequenceIndex,
                    phaseType: seg.type.name,
                    plannedDurationMs: seg.plannedDuration.inMilliseconds,
                    actualDurationMs: seg.actualDuration.inMilliseconds,
                    startedAtUtc: seg.startedAt.millisecondsSinceEpoch,
                    endedAtUtc: Value(seg.endedAt.millisecondsSinceEpoch),
                    insertedByUser: seg.insertedByUser,
                    completionStatus: seg.completion.name,
                  ),
              ]);
            });
          }
          await (_db.delete(
            _db.activeWorkoutSnapshots,
          )..where((t) => t.sessionId.equals(s.id))).go();
        });
      });

  SimpleSelectStatement<$WorkoutSessionsTable, SessionRow> _completed() =>
      _db.select(_db.workoutSessions)
        ..where((t) => t.status.equals(WorkoutStatus.completed.name));

  WorkoutSession _toSession(SessionRow r, List<SegmentRow> segments) =>
      WorkoutSession(
        id: r.id,
        startedAt: _utc(r.startedAtUtc),
        endedAt: _utc(r.endedAtUtc ?? r.startedAtUtc + r.totalElapsedMs),
        completionReason: CompletionReason.fromStorage(
          r.completionReason ?? CompletionReason.userStopped.storageKey,
        ),
        walkingDuration: Duration(milliseconds: r.walkingDurationMs),
        runningDuration: Duration(milliseconds: r.runningDurationMs),
        restDuration: Duration(milliseconds: r.restDurationMs),
        completedRounds: r.completedRounds,
        plan: WorkoutPlan.fromJson(
          jsonDecode(r.planSnapshotJson) as Map<String, Object?>,
        ),
        segments: [
          for (final seg in segments)
            PhaseSegment(
              id: seg.id,
              sequenceIndex: seg.sequenceIndex,
              type: PhaseType.values.byName(seg.phaseType),
              plannedDuration: Duration(milliseconds: seg.plannedDurationMs),
              actualDuration: Duration(milliseconds: seg.actualDurationMs),
              startedAt: _utc(seg.startedAtUtc),
              endedAt: _utc(seg.endedAtUtc ?? seg.startedAtUtc),
              insertedByUser: seg.insertedByUser,
              completion: SegmentCompletion.values.byName(seg.completionStatus),
            ),
        ],
        calorieEstimate: CalorieEstimate.fromStored(
          exerciseKcal: r.estimatedCaloriesKcal,
          methodVersion: r.calorieMethodVersion,
          weightGrams: r.calorieWeightGrams,
          assumptionsJson: r.calorieAssumptionsJson,
        ),
      );

  @override
  Stream<List<WorkoutSession>> watchSessionsBetween(
    DateTime startUtc,
    DateTime endUtc,
  ) {
    final q = _completed()
      ..where(
        (t) =>
            t.startedAtUtc.isBiggerOrEqualValue(
              startUtc.millisecondsSinceEpoch,
            ) &
            t.startedAtUtc.isSmallerThanValue(endUtc.millisecondsSinceEpoch),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.startedAtUtc)]);
    return q.watch().map(
      (rows) => [for (final r in rows) _toSession(r, const [])],
    );
  }

  @override
  Stream<WorkoutSession?> watchSession(String id) {
    final sessionQuery = _db.select(_db.workoutSessions)
      ..where((t) => t.id.equals(id));
    return sessionQuery.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      final segments =
          await (_db.select(_db.workoutPhaseSegments)
                ..where((t) => t.sessionId.equals(id))
                ..orderBy([(t) => OrderingTerm.asc(t.sequenceIndex)]))
              .get();
      return _toSession(row, segments);
    });
  }

  @override
  Stream<List<DateTime>> watchAllSessionStarts() {
    final q = _db.selectOnly(_db.workoutSessions)
      ..addColumns([_db.workoutSessions.startedAtUtc])
      ..where(_db.workoutSessions.status.equals(WorkoutStatus.completed.name));
    return q.watch().map(
      (rows) => [
        for (final r in rows) _utc(r.read(_db.workoutSessions.startedAtUtc)!),
      ],
    );
  }

  @override
  Stream<WorkoutSession?> watchLatestSession() {
    final q = _completed()
      ..orderBy([(t) => OrderingTerm.desc(t.startedAtUtc)])
      ..limit(1);
    return q.watchSingleOrNull().map(
      (r) => r == null ? null : _toSession(r, const []),
    );
  }

  @override
  Future<void> deleteSession(String id) => _guard(
    'delete the workout',
    () => _db.transaction(() async {
      await (_db.delete(
        _db.workoutPhaseSegments,
      )..where((t) => t.sessionId.equals(id))).go();
      await (_db.delete(
        _db.workoutSessions,
      )..where((t) => t.id.equals(id))).go();
    }),
  );

  @override
  Future<void> clearHistory() => _guard(
    'clear workout history',
    () => _db.transaction(() async {
      await _db.delete(_db.workoutPhaseSegments).go();
      await _db.delete(_db.workoutSessions).go();
    }),
  );
}
