import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets/common.dart';
import '../../settings/application/settings_controller.dart';
import '../domain/units.dart';
import 'measurement_inputs.dart';

/// Optional first-run profile. Both fields can be skipped.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _heightPrimary = TextEditingController();
  final _heightSecondary = TextEditingController();
  final _weight = TextEditingController();
  HeightUnit _heightUnit = HeightUnit.cm;
  WeightUnit _weightUnit = WeightUnit.kg;
  String? _heightError;
  String? _weightError;
  bool _saving = false;

  @override
  void dispose() {
    _heightPrimary.dispose();
    _heightSecondary.dispose();
    _weight.dispose();
    super.dispose();
  }

  Future<void> _finish({required bool save}) async {
    if (save) {
      final height = parseHeight(
        _heightUnit,
        _heightPrimary.text,
        _heightSecondary.text,
      );
      final weight = parseWeight(_weightUnit, _weight.text);
      setState(() {
        _heightError = height.error;
        _weightError = weight.error;
      });
      if (height.error != null || weight.error != null) return;

      setState(() => _saving = true);
      final repo = ref.read(profileRepositoryProvider);
      final ok = await runWithFeedback(context, () async {
        await repo.saveUnits(heightUnit: _heightUnit, weightUnit: _weightUnit);
        if (height.value != null) await repo.saveHeight(height.value);
        if (weight.value != null) {
          await repo.addWeight(
            measuredAt: ref.read(clockProvider).now(),
            weightGrams: weight.value!,
          );
        }
      });
      if (!mounted) return;
      setState(() => _saving = false);
      if (!ok) return;
    }
    if (!mounted) return;
    final ok = await runWithFeedback(
      context,
      () => ref
          .read(settingsControllerProvider.notifier)
          .update((s) => s.copyWith(onboardingCompleted: true)),
    );
    if (ok && mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            key: const Key('skip-onboarding'),
            onPressed: _saving ? null : () => _finish(save: false),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            Icon(
              Icons.directions_run_rounded,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text('Welcome to Stride', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Walk–run intervals with voice cues. Everything stays on this '
              'phone — no account needed.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text('About you (optional)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Height lets Stride show BMI. Weight enables weight trends and '
              'estimated calories. You can skip this and add it later.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<HeightUnit>(
              segments: const [
                ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
                ButtonSegment(value: HeightUnit.ftIn, label: Text('ft / in')),
              ],
              selected: {_heightUnit},
              onSelectionChanged: (s) => setState(() {
                _heightUnit = s.single;
                _heightPrimary.clear();
                _heightSecondary.clear();
                _heightError = null;
              }),
            ),
            const SizedBox(height: 12),
            HeightFields(
              unit: _heightUnit,
              primary: _heightPrimary,
              secondary: _heightSecondary,
              error: _heightError,
              onChanged: () => setState(() => _heightError = null),
            ),
            const SizedBox(height: 20),
            SegmentedButton<WeightUnit>(
              segments: const [
                ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
                ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
              ],
              selected: {_weightUnit},
              onSelectionChanged: (s) => setState(() {
                _weightUnit = s.single;
                _weightError = null;
              }),
            ),
            const SizedBox(height: 12),
            WeightField(
              unit: _weightUnit,
              controller: _weight,
              error: _weightError,
              label: 'Current weight',
              onChanged: () => setState(() => _weightError = null),
            ),
            const SizedBox(height: 28),
            FilledButton(
              key: const Key('finish-onboarding'),
              onPressed: _saving ? null : () => _finish(save: true),
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
