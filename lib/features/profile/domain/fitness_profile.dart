import 'units.dart';

class FitnessProfile {
  const FitnessProfile({
    this.heightMm,
    this.heightUnit = HeightUnit.cm,
    this.weightUnit = WeightUnit.kg,
  });

  static const empty = FitnessProfile();

  final int? heightMm;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
}

class WeightMeasurement {
  const WeightMeasurement({
    required this.id,
    required this.measuredAt,
    required this.weightGrams,
    this.note,
  });

  final String id;
  final DateTime measuredAt;
  final int weightGrams;
  final String? note;
}

abstract interface class ProfileRepository {
  Stream<FitnessProfile> watchProfile();
  Future<FitnessProfile> loadProfile();
  Future<void> saveHeight(int? heightMm);
  Future<void> saveUnits({HeightUnit? heightUnit, WeightUnit? weightUnit});

  /// Newest first.
  Stream<List<WeightMeasurement>> watchWeights();

  /// Latest measurement taken at or before [at], if any.
  Future<WeightMeasurement?> weightAt(DateTime at);
  Future<void> addWeight({
    required DateTime measuredAt,
    required int weightGrams,
    String? note,
  });
  Future<void> deleteWeight(String id);

  /// Removes height, unit preferences and all weight history.
  Future<void> deleteAllProfileData();
}
