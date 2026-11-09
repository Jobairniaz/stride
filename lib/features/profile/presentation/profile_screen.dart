import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../app/widgets/common.dart';
import '../application/profile_providers.dart';
import '../domain/bmi_calculator.dart';
import '../domain/fitness_profile.dart';
import '../domain/units.dart';
import '../domain/weight_trend.dart';
import 'measurement_inputs.dart';
import 'weight_widgets.dart';

/// Height, units, BMI and dated weight history. Everything is optional.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TrendPeriod _period = TrendPeriod.days90;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final weights = ref.watch(weightsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Body & weight')),
      body: switch ((profile, weights)) {
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => ErrorMessage(
          message: describeError(error),
          onRetry: () => ref
            ..invalidate(profileProvider)
            ..invalidate(weightsProvider),
        ),
        (AsyncData(value: final p), AsyncData(value: final w)) => _content(
          p,
          w,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _content(FitnessProfile profile, List<WeightMeasurement> weights) {
    final repo = ref.read(profileRepositoryProvider);
    final now = ref.read(clockProvider).now();
    final theme = Theme.of(context);
    final current = weights.isEmpty ? null : weights.first;
    final bmi = BmiCalculator.calculate(
      heightMm: profile.heightMm,
      weightGrams: current?.weightGrams,
    );
    final change = WeightTrend.monthlyChangeGrams(weights, now);
    final trend = WeightTrend.inPeriod(weights, _period, now);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        Text(
          'Optional. Height is used for BMI; weight for trends and '
          'estimated calories. Stored only on this device.',
          style: theme.textTheme.bodyMedium,
        ),
        const SectionHeader('Units'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SegmentedButton<HeightUnit>(
              segments: const [
                ButtonSegment(value: HeightUnit.cm, label: Text('cm')),
                ButtonSegment(value: HeightUnit.ftIn, label: Text('ft / in')),
              ],
              selected: {profile.heightUnit},
              onSelectionChanged: (s) => runWithFeedback(
                context,
                () => repo.saveUnits(heightUnit: s.single),
              ),
            ),
            SegmentedButton<WeightUnit>(
              segments: const [
                ButtonSegment(value: WeightUnit.kg, label: Text('kg')),
                ButtonSegment(value: WeightUnit.lb, label: Text('lb')),
              ],
              selected: {profile.weightUnit},
              onSelectionChanged: (s) => runWithFeedback(
                context,
                () => repo.saveUnits(weightUnit: s.single),
              ),
            ),
          ],
        ),
        const SectionHeader('Height'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.height_rounded),
            title: Text(
              profile.heightMm == null
                  ? 'Not set'
                  : BodyUnits.formatHeight(
                      profile.heightMm!,
                      profile.heightUnit,
                    ),
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _editHeight(profile),
          ),
        ),
        const SectionHeader('BMI'),
        _BmiCard(bmi: bmi, hasHeight: profile.heightMm != null),
        const SectionHeader('Weight'),
        Card(
          child: ListTile(
            leading: const Icon(Icons.monitor_weight_outlined),
            title: Text(
              current == null
                  ? 'No entries yet'
                  : BodyUnits.formatWeight(
                      current.weightGrams,
                      profile.weightUnit,
                    ),
            ),
            subtitle: Text(
              [
                if (current != null)
                  'Latest: ${DateFormat.yMMMd().format(current.measuredAt.toLocal())}',
                if (change != null)
                  'This month: ${BodyUnits.formatWeightDelta(change, profile.weightUnit)}',
              ].join(' · '),
            ),
            trailing: FilledButton.tonalIcon(
              onPressed: () => _addWeight(profile.weightUnit),
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final p in TrendPeriod.values)
                      ChoiceChip(
                        label: Text(p.label),
                        selected: p == _period,
                        onSelected: (_) => setState(() => _period = p),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                WeightTrendChart(entries: trend, unit: profile.weightUnit),
                const SizedBox(height: 8),
                Text(
                  'Weight changes can come from water, food, muscle or fat; '
                  'a change is not necessarily fat loss or muscle gain.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        if (weights.isNotEmpty) ...[
          const SectionHeader('History'),
          Card(
            child: Column(
              children: [
                for (final w in weights)
                  ListTile(
                    title: Text(
                      BodyUnits.formatWeight(w.weightGrams, profile.weightUnit),
                    ),
                    subtitle: Text(
                      [
                        DateFormat.yMMMd().format(w.measuredAt.toLocal()),
                        ?w.note,
                      ].join(' · '),
                    ),
                    trailing: IconButton(
                      tooltip: 'Delete entry',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteWeight(w),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editHeight(FitnessProfile profile) async {
    final primary = TextEditingController();
    final secondary = TextEditingController();
    fillHeight(profile.heightMm, profile.heightUnit, primary, secondary);
    final result = await showDialog<(bool, int?)>(
      context: context,
      builder: (context) {
        String? error;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Height'),
            content: HeightFields(
              unit: profile.heightUnit,
              primary: primary,
              secondary: secondary,
              error: error,
              onChanged: () => setState(() => error = null),
            ),
            actions: [
              if (profile.heightMm != null)
                TextButton(
                  onPressed: () => Navigator.pop(context, (true, null)),
                  child: const Text('Remove'),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final parsed = parseHeight(
                    profile.heightUnit,
                    primary.text,
                    secondary.text,
                  );
                  if (parsed.value == null) {
                    setState(() => error = parsed.error ?? 'Enter a height');
                    return;
                  }
                  Navigator.pop(context, (true, parsed.value));
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
    primary.dispose();
    secondary.dispose();
    if (result == null || !result.$1 || !mounted) return;
    await runWithFeedback(
      context,
      () => ref.read(profileRepositoryProvider).saveHeight(result.$2),
    );
  }

  Future<void> _addWeight(WeightUnit unit) async {
    final entry = await showAddWeightSheet(
      context,
      unit: unit,
      now: ref.read(clockProvider).now(),
    );
    if (entry == null || !mounted) return;
    await runWithFeedback(
      context,
      () => ref
          .read(profileRepositoryProvider)
          .addWeight(
            measuredAt: entry.measuredAt,
            weightGrams: entry.grams,
            note: entry.note,
          ),
      successMessage: 'Weight saved',
    );
  }

  Future<void> _deleteWeight(WeightMeasurement w) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete this entry?',
      message:
          'Workouts already saved keep the weight they were recorded with.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await runWithFeedback(
      context,
      () => ref.read(profileRepositoryProvider).deleteWeight(w.id),
    );
  }
}

class _BmiCard extends StatelessWidget {
  const _BmiCard({required this.bmi, required this.hasHeight});

  final BmiResult? bmi;
  final bool hasHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = bmi;
    if (b == null) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('BMI not available'),
          subtitle: Text(
            hasHeight
                ? 'Add a weight entry to calculate BMI.'
                : 'Add your height and a weight entry to calculate BMI.',
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              b.value.toStringAsFixed(1),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (b.adultCategory != null)
              Text('Adult range: ${b.adultCategory!.range}'),
            const SizedBox(height: 8),
            Text(
              'BMI is weight ÷ height² — a screening number, not a diagnosis. '
              'It does not measure body fat or muscle. Adult BMI categories '
              'do not apply to children or teens, and Stride does not ask your '
              'age, so no category is shown.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
