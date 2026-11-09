import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// All timestamps are UTC epoch milliseconds. See docs/DATA_MODEL.md.

@DataClassName('SessionRow')
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  IntColumn get startedAtUtc => integer()();
  IntColumn get endedAtUtc => integer().nullable()();
  TextColumn get status => text()();
  TextColumn get completionReason => text().nullable()();

  /// Wall-clock duration including pauses.
  IntColumn get totalElapsedMs => integer()();
  IntColumn get activeDurationMs => integer()();
  IntColumn get walkingDurationMs => integer()();
  IntColumn get runningDurationMs => integer()();
  IntColumn get restDurationMs => integer()();
  IntColumn get completedRounds => integer()();
  TextColumn get planSnapshotJson => text()();

  /// Estimated walking + running kcal (rest is in the assumptions JSON).
  RealColumn get estimatedCaloriesKcal => real().nullable()();
  TextColumn get calorieMethodVersion => text().nullable()();
  IntColumn get calorieWeightGrams => integer().nullable()();
  TextColumn get calorieAssumptionsJson => text().nullable()();
  IntColumn get createdAtUtc => integer()();
  IntColumn get updatedAtUtc => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SegmentRow')
class WorkoutPhaseSegments extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get sequenceIndex => integer()();
  TextColumn get phaseType => text()();
  IntColumn get plannedDurationMs => integer()();
  IntColumn get actualDurationMs => integer()();
  IntColumn get startedAtUtc => integer()();
  IntColumn get endedAtUtc => integer().nullable()();
  BoolColumn get insertedByUser => boolean()();
  TextColumn get completionStatus => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The single unfinished workout, for process-death recovery.
@DataClassName('SnapshotRow')
class ActiveWorkoutSnapshots extends Table {
  TextColumn get sessionId => text()();
  TextColumn get status => text()();
  TextColumn get currentPhaseId => text()();
  TextColumn get currentPhaseType => text()();
  IntColumn get currentSequenceIndex => integer()();
  IntColumn get phasePlannedMs => integer()();
  IntColumn get phaseDeadlineUtcMs => integer().nullable()();
  IntColumn get frozenRemainingMs => integer().nullable()();
  IntColumn get phaseStartedAtUtcMs => integer()();
  BoolColumn get phaseInsertedByUser => boolean()();
  BoolColumn get phaseIsResumption => boolean()();
  IntColumn get workoutStartedAtUtcMs => integer()();
  IntColumn get lastReconciledAtUtcMs => integer()();
  IntColumn get workIndex => integer()();
  IntColumn get currentRound => integer()();
  IntColumn get resumeRemainingMs => integer().nullable()();
  TextColumn get serializedPlanSnapshot => text()();
  TextColumn get completedSegmentsJson => text()();

  @override
  Set<Column> get primaryKey => {sessionId};
}

@DataClassName('ProfileRow')
class FitnessProfiles extends Table {
  /// Always [AppDatabase.profileId].
  IntColumn get id => integer()();
  IntColumn get heightMm => integer().nullable()();
  TextColumn get preferredHeightUnit => text()();
  TextColumn get preferredWeightUnit => text()();
  IntColumn get updatedAtUtc => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WeightRow')
class WeightMeasurements extends Table {
  TextColumn get id => text()();
  IntColumn get measuredAtUtc => integer()();
  IntColumn get weightGrams => integer()();
  TextColumn get note => text().nullable()();
  IntColumn get createdAtUtc => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    WorkoutSessions,
    WorkoutPhaseSegments,
    ActiveWorkoutSnapshots,
    FitnessProfiles,
    WeightMeasurements,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'stride'));

  static const profileId = 1;

  /// Bump and add a step in [migration] for every schema change. Never drop
  /// user workout history during an upgrade.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_sessions_started '
        'ON workout_sessions (started_at_utc)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_segments_session '
        'ON workout_phase_segments (session_id, sequence_index)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_weights_measured '
        'ON weight_measurements (measured_at_utc)',
      );
    },
    onUpgrade: (m, from, to) async {
      // No migrations yet (schema v1).
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
