import 'dart:convert';

/// Snapshot of a calorie estimate stored with a completed workout. Old
/// workouts keep the weight and assumptions used at the time; they are never
/// silently recalculated.
class CalorieEstimate {
  const CalorieEstimate({
    required this.exerciseKcal,
    required this.restKcal,
    required this.methodVersion,
    required this.weightGrams,
    required this.assumptions,
  });

  /// Walking + running only.
  final double exerciseKcal;

  /// Inserted rest phases, shown separately.
  final double restKcal;
  final String methodVersion;
  final int weightGrams;
  final MetAssumptions assumptions;

  double get totalKcal => exerciseKcal + restKcal;

  String assumptionsJson() =>
      jsonEncode({...assumptions.toJson(), 'restKcal': restKcal});

  static CalorieEstimate? fromStored({
    required double? exerciseKcal,
    required String? methodVersion,
    required int? weightGrams,
    required String? assumptionsJson,
  }) {
    if (exerciseKcal == null ||
        methodVersion == null ||
        weightGrams == null ||
        assumptionsJson == null) {
      return null;
    }
    final json = jsonDecode(assumptionsJson) as Map<String, Object?>;
    return CalorieEstimate(
      exerciseKcal: exerciseKcal,
      restKcal: (json['restKcal'] as num?)?.toDouble() ?? 0,
      methodVersion: methodVersion,
      weightGrams: weightGrams,
      assumptions: MetAssumptions.fromJson(json),
    );
  }
}

class MetAssumptions {
  const MetAssumptions({
    required this.walkingMet,
    required this.runningMet,
    required this.restMet,
  });

  final double walkingMet;
  final double runningMet;
  final double restMet;

  Map<String, Object?> toJson() => {
    'walkingMet': walkingMet,
    'runningMet': runningMet,
    'restMet': restMet,
    'formula': 'kcal = MET * 3.5 * weight_kg / 200 * minutes',
  };

  factory MetAssumptions.fromJson(Map<String, Object?> json) => MetAssumptions(
    walkingMet: (json['walkingMet']! as num).toDouble(),
    runningMet: (json['runningMet']! as num).toDouble(),
    restMet: (json['restMet']! as num).toDouble(),
  );
}

/// Versioned MET-based estimate:
/// `kcal ≈ MET × 3.5 × weight_kg / 200 × minutes`.
///
/// v1 MET assumptions (Compendium of Physical Activities, conservative):
/// * walking 3.5 — moderate pace (~3 mph / 5 km/h) on level ground
/// * running 7.0 — general jogging
/// * rest 1.3 — standing quietly
///
/// The app does not measure speed, terrain, incline or heart rate, so these
/// are rough estimates, never measurements. Paused time is excluded because
/// only actual phase durations are passed in.
abstract final class CalorieEstimator {
  static const methodVersion = 'met-v1';
  static const assumptions = MetAssumptions(
    walkingMet: 3.5,
    runningMet: 7.0,
    restMet: 1.3,
  );

  /// Returns `null` when weight is unknown.
  static CalorieEstimate? estimate({
    required Duration walking,
    required Duration running,
    required Duration rest,
    required int? weightGrams,
  }) {
    if (weightGrams == null || weightGrams <= 0) return null;
    final kg = weightGrams / 1000;
    double kcal(double met, Duration d) =>
        met * 3.5 * kg / 200 * (d.inMilliseconds / 60000);
    return CalorieEstimate(
      exerciseKcal:
          kcal(assumptions.walkingMet, walking) +
          kcal(assumptions.runningMet, running),
      restKcal: kcal(assumptions.restMet, rest),
      methodVersion: methodVersion,
      weightGrams: weightGrams,
      assumptions: assumptions,
    );
  }
}
