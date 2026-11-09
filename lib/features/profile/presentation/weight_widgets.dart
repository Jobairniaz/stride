import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/fitness_profile.dart';
import '../domain/units.dart';
import 'measurement_inputs.dart';

/// Result of the add-weight sheet.
typedef NewWeightEntry = ({DateTime measuredAt, int grams, String? note});

Future<NewWeightEntry?> showAddWeightSheet(
  BuildContext context, {
  required WeightUnit unit,
  required DateTime now,
}) => showModalBottomSheet<NewWeightEntry>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _AddWeightSheet(unit: unit, now: now),
);

class _AddWeightSheet extends StatefulWidget {
  const _AddWeightSheet({required this.unit, required this.now});

  final WeightUnit unit;
  final DateTime now;

  @override
  State<_AddWeightSheet> createState() => _AddWeightSheetState();
}

class _AddWeightSheetState extends State<_AddWeightSheet> {
  final _weight = TextEditingController();
  final _note = TextEditingController();
  late DateTime _date = widget.now.toLocal();
  String? _error;

  @override
  void dispose() {
    _weight.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final local = widget.now.toLocal();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(local.year - 20),
      lastDate: local,
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final parsed = parseWeight(widget.unit, _weight.text);
    if (parsed.value == null) {
      setState(() => _error = parsed.error ?? 'Enter a weight');
      return;
    }
    final local = widget.now.toLocal();
    final isToday =
        _date.year == local.year &&
        _date.month == local.month &&
        _date.day == local.day;
    // Today: the actual time. Past days: midday, so the entry sorts sensibly.
    final measuredAt = isToday
        ? widget.now
        : DateTime(_date.year, _date.month, _date.day, 12).toUtc();
    Navigator.pop(context, (
      measuredAt: measuredAt,
      grams: parsed.value!,
      note: _note.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add weight', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'A new dated entry is added. Earlier entries are kept.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            WeightField(
              unit: widget.unit,
              controller: _weight,
              error: _error,
              onChanged: () => setState(() => _error = null),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event_rounded),
              label: Text(DateFormat.yMMMd().format(_date)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              maxLength: 120,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _save, child: const Text('Save entry')),
          ],
        ),
      ),
    );
  }
}

/// Weight over time. [entries] must be oldest first.
class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({
    super.key,
    required this.entries,
    required this.unit,
  });

  final List<WeightMeasurement> entries;
  final WeightUnit unit;

  double _value(int grams) => unit == WeightUnit.kg
      ? BodyUnits.gramsToKg(grams)
      : BodyUnits.gramsToLb(grams);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (entries.length < 2) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'Add at least two entries in this period to see a trend.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final t0 = entries.first.measuredAt.millisecondsSinceEpoch;
    double x(WeightMeasurement e) =>
        (e.measuredAt.millisecondsSinceEpoch - t0) /
        Duration.millisecondsPerDay;
    final values = [for (final e in entries) _value(e.weightGrams)];
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY).clamp(1, double.infinity) * 0.2;
    final first = entries.first;
    final last = entries.last;

    return Semantics(
      label:
          'Weight trend from ${BodyUnits.formatWeight(first.weightGrams, unit)} '
          'on ${DateFormat.yMMMd().format(first.measuredAt.toLocal())} to '
          '${BodyUnits.formatWeight(last.weightGrams, unit)} on '
          '${DateFormat.yMMMd().format(last.measuredAt.toLocal())}',
      excludeSemantics: true,
      child: SizedBox(
        height: 180,
        child: LineChart(
          LineChartData(
            minY: minY - pad,
            maxY: maxY + pad,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              bottomTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) =>
                      value == meta.min || value == meta.max
                      ? const SizedBox.shrink()
                      : Text(
                          value.toStringAsFixed(0),
                          style: theme.textTheme.labelSmall,
                        ),
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (final (i, e) in entries.indexed) FlSpot(x(e), values[i]),
                ],
                color: theme.colorScheme.primary,
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }
}
