/// Unit conversion and validation for user-entered body measurements.
///
/// Canonical storage: height in millimetres, weight in grams (integers).
library;

enum HeightUnit {
  cm('cm'),
  ftIn('ft_in');

  const HeightUnit(this.storageKey);
  final String storageKey;

  static HeightUnit fromStorage(String? key) => values.firstWhere(
    (u) => u.storageKey == key,
    orElse: () => HeightUnit.cm,
  );
}

enum WeightUnit {
  kg('kg'),
  lb('lb');

  const WeightUnit(this.storageKey);
  final String storageKey;

  static WeightUnit fromStorage(String? key) => values.firstWhere(
    (u) => u.storageKey == key,
    orElse: () => WeightUnit.kg,
  );
}

abstract final class BodyUnits {
  static const mmPerInch = 25.4;
  static const gramsPerPound = 453.59237;

  /// Plausible human ranges. Values outside are rejected as input errors.
  static const minHeightMm = 500; // 50 cm
  static const maxHeightMm = 2720; // 272 cm
  static const minWeightGrams = 20000; // 20 kg
  static const maxWeightGrams = 350000; // 350 kg

  static int cmToMm(double cm) => (cm * 10).round();
  static double mmToCm(int mm) => mm / 10;

  static int feetInchesToMm(int feet, double inches) =>
      ((feet * 12 + inches) * mmPerInch).round();

  /// Returns (feet, inches) with inches rounded to one decimal.
  static (int, double) mmToFeetInches(int mm) {
    final totalInches = mm / mmPerInch;
    var feet = totalInches ~/ 12;
    var inches = double.parse((totalInches - feet * 12).toStringAsFixed(1));
    if (inches >= 12) {
      feet += 1;
      inches -= 12;
    }
    return (feet, inches);
  }

  static int kgToGrams(double kg) => (kg * 1000).round();
  static double gramsToKg(int g) => g / 1000;

  static int lbToGrams(double lb) => (lb * gramsPerPound).round();
  static double gramsToLb(int g) => g / gramsPerPound;

  static String? validateHeightMm(int? mm) {
    if (mm == null) return 'Enter a height';
    if (mm < minHeightMm || mm > maxHeightMm) {
      return 'Height must be between 50 and 272 cm';
    }
    return null;
  }

  static String? validateWeightGrams(int? g) {
    if (g == null) return 'Enter a weight';
    if (g < minWeightGrams || g > maxWeightGrams) {
      return 'Weight must be between 20 and 350 kg (44–772 lb)';
    }
    return null;
  }

  static String formatHeight(int mm, HeightUnit unit) {
    switch (unit) {
      case HeightUnit.cm:
        return '${mmToCm(mm).toStringAsFixed(mmToCm(mm) % 1 == 0 ? 0 : 1)} cm';
      case HeightUnit.ftIn:
        final (feet, inches) = mmToFeetInches(mm);
        final inchText = inches % 1 == 0
            ? inches.toStringAsFixed(0)
            : inches.toStringAsFixed(1);
        return '$feet ft $inchText in';
    }
  }

  static String formatWeight(int grams, WeightUnit unit) => switch (unit) {
    WeightUnit.kg => '${gramsToKg(grams).toStringAsFixed(1)} kg',
    WeightUnit.lb => '${gramsToLb(grams).toStringAsFixed(1)} lb',
  };

  /// Signed weight change, e.g. `+1.2 kg`.
  static String formatWeightDelta(int grams, WeightUnit unit) {
    final value = unit == WeightUnit.kg ? gramsToKg(grams) : gramsToLb(grams);
    final sign = value > 0 ? '+' : (value < 0 ? '−' : '±');
    return '$sign${value.abs().toStringAsFixed(1)} ${unit.storageKey}';
  }
}
