import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/clock/clock.dart';
import '../../../core/errors/app_failure.dart';
import '../../../platform/storage/app_database.dart';
import '../domain/fitness_profile.dart';
import '../domain/units.dart';

class DriftProfileRepository implements ProfileRepository {
  DriftProfileRepository(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  static DateTime _utc(int ms) =>
      DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);

  Future<T> _guard<T>(String action, Future<T> Function() body) async {
    try {
      return await body();
    } on AppFailure {
      rethrow;
    } on Exception catch (e) {
      throw PersistenceFailure('Could not $action', cause: e);
    }
  }

  SimpleSelectStatement<$FitnessProfilesTable, ProfileRow> get _profileQuery =>
      _db.select(_db.fitnessProfiles)
        ..where((t) => t.id.equals(AppDatabase.profileId));

  FitnessProfile _toProfile(ProfileRow? r) => r == null
      ? FitnessProfile.empty
      : FitnessProfile(
          heightMm: r.heightMm,
          heightUnit: HeightUnit.fromStorage(r.preferredHeightUnit),
          weightUnit: WeightUnit.fromStorage(r.preferredWeightUnit),
        );

  @override
  Stream<FitnessProfile> watchProfile() =>
      _profileQuery.watchSingleOrNull().map(_toProfile);

  @override
  Future<FitnessProfile> loadProfile() => _guard('load profile', () async {
    return _toProfile(await _profileQuery.getSingleOrNull());
  });

  Future<void> _upsert({
    required Value<int?> heightMm,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
  }) async {
    final current = await loadProfile();
    await _db
        .into(_db.fitnessProfiles)
        .insertOnConflictUpdate(
          FitnessProfilesCompanion.insert(
            id: const Value(AppDatabase.profileId),
            heightMm: heightMm.present ? heightMm : Value(current.heightMm),
            preferredHeightUnit: (heightUnit ?? current.heightUnit).storageKey,
            preferredWeightUnit: (weightUnit ?? current.weightUnit).storageKey,
            updatedAtUtc: _clock.now().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> saveHeight(int? heightMm) => _guard('save height', () async {
    if (heightMm != null) {
      final error = BodyUnits.validateHeightMm(heightMm);
      if (error != null) throw ValidationFailure(error);
    }
    await _upsert(heightMm: Value(heightMm));
  });

  @override
  Future<void> saveUnits({HeightUnit? heightUnit, WeightUnit? weightUnit}) =>
      _guard(
        'save units',
        () => _upsert(
          heightMm: const Value.absent(),
          heightUnit: heightUnit,
          weightUnit: weightUnit,
        ),
      );

  WeightMeasurement _toWeight(WeightRow r) => WeightMeasurement(
    id: r.id,
    measuredAt: _utc(r.measuredAtUtc),
    weightGrams: r.weightGrams,
    note: r.note,
  );

  @override
  Stream<List<WeightMeasurement>> watchWeights() {
    final q = _db.select(_db.weightMeasurements)
      ..orderBy([
        (t) => OrderingTerm.desc(t.measuredAtUtc),
        (t) => OrderingTerm.desc(t.createdAtUtc),
      ]);
    return q.watch().map((rows) => [for (final r in rows) _toWeight(r)]);
  }

  @override
  Future<WeightMeasurement?> weightAt(DateTime at) => _guard(
    'load weight',
    () async {
      final q = _db.select(_db.weightMeasurements)
        ..where(
          (t) =>
              t.measuredAtUtc.isSmallerOrEqualValue(at.millisecondsSinceEpoch),
        )
        ..orderBy([
          (t) => OrderingTerm.desc(t.measuredAtUtc),
          (t) => OrderingTerm.desc(t.createdAtUtc),
        ])
        ..limit(1);
      final row = await q.getSingleOrNull();
      return row == null ? null : _toWeight(row);
    },
  );

  @override
  Future<void> addWeight({
    required DateTime measuredAt,
    required int weightGrams,
    String? note,
  }) => _guard('save weight', () async {
    final error = BodyUnits.validateWeightGrams(weightGrams);
    if (error != null) throw ValidationFailure(error);
    final trimmed = note?.trim();
    await _db
        .into(_db.weightMeasurements)
        .insert(
          WeightMeasurementsCompanion.insert(
            id: const Uuid().v4(),
            measuredAtUtc: measuredAt.toUtc().millisecondsSinceEpoch,
            weightGrams: weightGrams,
            note: Value(trimmed == null || trimmed.isEmpty ? null : trimmed),
            createdAtUtc: _clock.now().millisecondsSinceEpoch,
          ),
        );
  });

  @override
  Future<void> deleteWeight(String id) => _guard(
    'delete weight entry',
    () => (_db.delete(
      _db.weightMeasurements,
    )..where((t) => t.id.equals(id))).go(),
  );

  @override
  Future<void> deleteAllProfileData() => _guard(
    'delete profile data',
    () => _db.transaction(() async {
      await _db.delete(_db.weightMeasurements).go();
      await _db.delete(_db.fitnessProfiles).go();
    }),
  );
}
