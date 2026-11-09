import 'package:flutter_test/flutter_test.dart';
import 'package:stride/features/profile/domain/bmi_calculator.dart';
import 'package:stride/features/profile/domain/calorie_estimator.dart';
import 'package:stride/features/profile/domain/fitness_profile.dart';
import 'package:stride/features/profile/domain/units.dart';
import 'package:stride/features/profile/domain/weight_trend.dart';
import 'package:stride/features/profile/presentation/measurement_inputs.dart';

void main() {
  group('unit conversion', () {
    test('metric and imperial heights round-trip', () {
      for (final mm in [1500, 1655, 1778, 1900, 2100]) {
        final (feet, inches) = BodyUnits.mmToFeetInches(mm);
        final back = BodyUnits.feetInchesToMm(feet, inches);
        expect((back - mm).abs(), lessThanOrEqualTo(2), reason: 'mm=$mm');
      }
      expect(BodyUnits.feetInchesToMm(5, 10), 1778);
      expect(BodyUnits.cmToMm(172.5), 1725);
    });

    test('kg and lb weights round-trip', () {
      expect(BodyUnits.lbToGrams(1), 454);
      final g = BodyUnits.lbToGrams(165.3);
      expect(BodyUnits.gramsToLb(g), closeTo(165.3, 0.01));
      expect(BodyUnits.kgToGrams(72.4), 72400);
    });

    test('rejects implausible and zero values', () {
      expect(BodyUnits.validateHeightMm(0), isNotNull);
      expect(BodyUnits.validateHeightMm(3000), isNotNull);
      expect(BodyUnits.validateHeightMm(1700), isNull);
      expect(BodyUnits.validateWeightGrams(0), isNotNull);
      expect(BodyUnits.validateWeightGrams(400000), isNotNull);
      expect(BodyUnits.validateWeightGrams(70000), isNull);
    });

    test('input parsing accepts blanks and commas, rejects nonsense', () {
      expect(parseHeight(HeightUnit.cm, '').isBlank, isTrue);
      expect(parseHeight(HeightUnit.cm, '172,5').value, 1725);
      expect(parseHeight(HeightUnit.ftIn, '5', '10').value, 1778);
      expect(parseHeight(HeightUnit.ftIn, '5', '13').error, isNotNull);
      expect(parseHeight(HeightUnit.cm, '17').error, isNotNull);
      expect(parseWeight(WeightUnit.lb, '160').value, 72575);
      expect(parseWeight(WeightUnit.kg, 'abc').error, isNotNull);
    });
  });

  group('BMI', () {
    test('formula and rounding', () {
      final r = BmiCalculator.calculate(heightMm: 1750, weightGrams: 70000)!;
      expect(r.value, 22.9); // 70 / 1.75² = 22.857
    });

    test('no adult category when adult status is unknown', () {
      final r = BmiCalculator.calculate(heightMm: 1750, weightGrams: 95000)!;
      expect(r.adultCategory, isNull);
      final adult = BmiCalculator.calculate(
        heightMm: 1750,
        weightGrams: 95000,
        adultStatus: AdultStatus.confirmedAdult,
      )!;
      expect(adult.adultCategory, AdultBmiCategory.obesity);
    });

    test('missing or invalid inputs produce no BMI', () {
      expect(
        BmiCalculator.calculate(heightMm: null, weightGrams: 70000),
        isNull,
      );
      expect(
        BmiCalculator.calculate(heightMm: 1750, weightGrams: null),
        isNull,
      );
      expect(BmiCalculator.calculate(heightMm: 0, weightGrams: 70000), isNull);
    });
  });

  group('calorie estimate', () {
    test('uses MET formula with weight and actual durations', () {
      final e = CalorieEstimator.estimate(
        walking: const Duration(minutes: 10),
        running: const Duration(minutes: 10),
        rest: const Duration(minutes: 2),
        weightGrams: 80000,
      )!;
      // walking: 3.5*3.5*80/200*10 = 49; running: 7*3.5*80/200*10 = 98
      expect(e.exerciseKcal, closeTo(147, 1e-9));
      // rest: 1.3*3.5*80/200*2 = 3.64
      expect(e.restKcal, closeTo(3.64, 1e-9));
      expect(e.methodVersion, 'met-v1');
      expect(e.weightGrams, 80000);
    });

    test('missing weight produces no estimate', () {
      expect(
        CalorieEstimator.estimate(
          walking: const Duration(minutes: 10),
          running: Duration.zero,
          rest: Duration.zero,
          weightGrams: null,
        ),
        isNull,
      );
    });

    test('stored estimate round-trips with its assumptions', () {
      final e = CalorieEstimator.estimate(
        walking: const Duration(minutes: 4),
        running: const Duration(minutes: 4),
        rest: const Duration(minutes: 1),
        weightGrams: 70000,
      )!;
      final restored = CalorieEstimate.fromStored(
        exerciseKcal: e.exerciseKcal,
        methodVersion: e.methodVersion,
        weightGrams: e.weightGrams,
        assumptionsJson: e.assumptionsJson(),
      )!;
      expect(restored.restKcal, e.restKcal);
      expect(restored.assumptions.runningMet, 7.0);
    });
  });

  group('weight trend', () {
    WeightMeasurement w(String id, DateTime at, int g) =>
        WeightMeasurement(id: id, measuredAt: at.toUtc(), weightGrams: g);
    final now = DateTime(2026, 11, 20, 9);

    test('monthly change compares latest entries of each month', () {
      final entries = [
        w('a', DateTime(2026, 10, 3), 82000),
        w('b', DateTime(2026, 10, 28), 81000),
        w('c', DateTime(2026, 11, 2), 80800),
        w('d', DateTime(2026, 11, 18), 80200),
      ];
      expect(WeightTrend.monthlyChangeGrams(entries, now), -800);
      expect(WeightTrend.monthlyChangeGrams(entries.sublist(2), now), isNull);
    });

    test('period filter keeps history ordered oldest first', () {
      final entries = [
        w('new', DateTime(2026, 11, 18), 80200),
        w('old', DateTime(2025, 1, 1), 90000),
        w('mid', DateTime(2026, 10, 1), 81000),
      ];
      expect(
        WeightTrend.inPeriod(entries, TrendPeriod.days90, now).map((e) => e.id),
        ['mid', 'new'],
      );
      expect(WeightTrend.inPeriod(entries, TrendPeriod.all, now), hasLength(3));
    });
  });
}
