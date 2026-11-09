import 'units.dart';

enum AdultBmiCategory {
  underweight('Below 18.5'),
  healthyRange('18.5–24.9'),
  overweight('25–29.9'),
  obesity('30 or above');

  const AdultBmiCategory(this.range);
  final String range;
}

/// Whether adult BMI categories may be applied. v1 does not collect age, so
/// the app passes [unknown] and only the numeric value is shown.
enum AdultStatus { unknown, confirmedAdult }

class BmiResult {
  const BmiResult({required this.value, required this.adultCategory});

  /// Rounded to one decimal place.
  final double value;

  /// Only set when adult status is confirmed.
  final AdultBmiCategory? adultCategory;
}

/// BMI = weight_kg / (height_m × height_m).
///
/// BMI is a screening measure, not a diagnosis, and does not measure body
/// composition. Adult categories are never applied unless adult status is
/// confirmed.
abstract final class BmiCalculator {
  /// Returns `null` when either input is missing or implausible.
  static BmiResult? calculate({
    required int? heightMm,
    required int? weightGrams,
    AdultStatus adultStatus = AdultStatus.unknown,
  }) {
    if (BodyUnits.validateHeightMm(heightMm) != null) return null;
    if (BodyUnits.validateWeightGrams(weightGrams) != null) return null;
    final heightM = heightMm! / 1000;
    final kg = weightGrams! / 1000;
    final raw = kg / (heightM * heightM);
    final value = (raw * 10).round() / 10;
    return BmiResult(
      value: value,
      adultCategory: adultStatus == AdultStatus.confirmedAdult
          ? _category(value)
          : null,
    );
  }

  static AdultBmiCategory _category(double bmi) {
    if (bmi < 18.5) return AdultBmiCategory.underweight;
    if (bmi < 25) return AdultBmiCategory.healthyRange;
    if (bmi < 30) return AdultBmiCategory.overweight;
    return AdultBmiCategory.obesity;
  }
}
