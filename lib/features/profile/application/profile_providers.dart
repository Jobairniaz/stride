import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/bmi_calculator.dart';
import '../domain/fitness_profile.dart';

final profileProvider = StreamProvider<FitnessProfile>(
  (ref) => ref.watch(profileRepositoryProvider).watchProfile(),
);

/// Newest first.
final weightsProvider = StreamProvider<List<WeightMeasurement>>(
  (ref) => ref.watch(profileRepositoryProvider).watchWeights(),
);

/// Latest weight entry (by measurement date), if any.
final currentWeightProvider = Provider<AsyncValue<WeightMeasurement?>>(
  (ref) => ref
      .watch(weightsProvider)
      .whenData((list) => list.isEmpty ? null : list.first),
);

/// Numeric BMI only (adult status is not collected in v1).
final bmiProvider = Provider<AsyncValue<BmiResult?>>((ref) {
  final profile = ref.watch(profileProvider);
  final weight = ref.watch(currentWeightProvider);
  if (profile.isLoading || weight.isLoading) return const AsyncLoading();
  if (profile.hasError) {
    return AsyncError(profile.error!, profile.stackTrace ?? StackTrace.empty);
  }
  if (weight.hasError) {
    return AsyncError(weight.error!, weight.stackTrace ?? StackTrace.empty);
  }
  return AsyncData(
    BmiCalculator.calculate(
      heightMm: profile.value?.heightMm,
      weightGrams: weight.value?.weightGrams,
    ),
  );
});
