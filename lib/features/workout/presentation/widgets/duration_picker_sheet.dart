import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/duration_format.dart';
import '../../domain/entities/workout_plan.dart';

/// Parses minutes/seconds text fields. Returns `(duration, error)`.
(Duration?, String?) parseMinutesSeconds(String minutes, String seconds) {
  final m = minutes.trim().isEmpty ? 0 : int.tryParse(minutes.trim());
  final s = seconds.trim().isEmpty ? 0 : int.tryParse(seconds.trim());
  if (m == null || s == null || m < 0 || s < 0) {
    return (null, 'Enter whole numbers');
  }
  if (s > 59) return (null, 'Seconds must be 0–59');
  final d = Duration(minutes: m, seconds: s);
  final error = WorkoutPlan.validatePhaseDuration(d);
  return error == null ? (d, null) : (null, error);
}

/// Bottom sheet with quick choices and custom entry. Returns the chosen
/// duration, or null if dismissed.
Future<Duration?> showDurationPicker(
  BuildContext context, {
  required String title,
  required Duration initial,
  String confirmLabel = 'Save',
  List<Duration> presets = const [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 2),
    Duration(minutes: 3),
    Duration(minutes: 5),
    Duration(minutes: 10),
  ],
}) => showModalBottomSheet<Duration>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => DurationPickerSheet(
    title: title,
    initial: initial,
    presets: presets,
    confirmLabel: confirmLabel,
  ),
);

class DurationPickerSheet extends StatefulWidget {
  const DurationPickerSheet({
    super.key,
    required this.title,
    required this.initial,
    required this.presets,
    required this.confirmLabel,
  });

  final String title;
  final Duration initial;
  final List<Duration> presets;
  final String confirmLabel;

  @override
  State<DurationPickerSheet> createState() => _DurationPickerSheetState();
}

class _DurationPickerSheetState extends State<DurationPickerSheet> {
  late final _minutes = TextEditingController(
    text: widget.initial.inMinutes.toString(),
  );
  late final _seconds = TextEditingController(
    text: (widget.initial.inSeconds % 60).toString(),
  );
  late Duration? _value = widget.initial;
  String? _error;

  @override
  void dispose() {
    _minutes.dispose();
    _seconds.dispose();
    super.dispose();
  }

  void _pickPreset(Duration d) {
    setState(() {
      _value = d;
      _error = null;
      _minutes.text = d.inMinutes.toString();
      _seconds.text = (d.inSeconds % 60).toString();
    });
  }

  void _onCustomChanged(String _) {
    final (d, error) = parseMinutesSeconds(_minutes.text, _seconds.text);
    setState(() {
      _value = d;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final digits = [FilteringTextInputFormatter.digitsOnly];
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
            Text(widget.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in widget.presets)
                  ChoiceChip(
                    label: Text(formatDurationLabel(p)),
                    selected: _value == p,
                    onSelected: (_) => _pickPreset(p),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Custom', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('duration-minutes'),
                    controller: _minutes,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                      suffixText: 'min',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onCustomChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const Key('duration-seconds'),
                    controller: _seconds,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      suffixText: 'sec',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onCustomChanged,
                  ),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 8),
            Text(
              'Between 5 seconds and 180 minutes.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _value == null || _error != null
                  ? null
                  : () => Navigator.pop(context, _value),
              child: Text(widget.confirmLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Returns `(true, rounds)` when confirmed; `rounds == null` = until stopped.
Future<(bool, int?)> showRoundsPicker(
  BuildContext context, {
  required int? initial,
}) async {
  final result = await showModalBottomSheet<(bool, int?)>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _RoundsSheet(initial: initial),
  );
  return result ?? (false, initial);
}

class _RoundsSheet extends StatefulWidget {
  const _RoundsSheet({required this.initial});

  final int? initial;

  @override
  State<_RoundsSheet> createState() => _RoundsSheetState();
}

class _RoundsSheetState extends State<_RoundsSheet> {
  late bool _unlimited = widget.initial == null;
  late int _rounds = widget.initial ?? 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Rounds', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'One round is one walk plus one run.',
            style: theme.textTheme.bodyMedium,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Continue until I stop'),
            value: _unlimited,
            onChanged: (v) => setState(() => _unlimited = v),
          ),
          if (!_unlimited)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Fewer rounds',
                  onPressed: _rounds > 1
                      ? () => setState(() => _rounds--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 96,
                  child: Text(
                    '$_rounds',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'More rounds',
                  onPressed: _rounds < WorkoutPlan.maxRounds
                      ? () => setState(() => _rounds++)
                      : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, (true, _unlimited ? null : _rounds)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
