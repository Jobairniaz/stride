import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../domain/progress_calculator.dart';

/// Monday-start month grid. Workout days get a filled marker *and* a dot so
/// the state is not conveyed by colour alone.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.sessionsPerDay,
    required this.selectedDay,
    required this.onSelect,
  });

  final DateTime month;
  final Map<int, int> sessionsPerDay;
  final int? selectedDay;
  final ValueChanged<int?> onSelect;

  static const _weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final offset = DateTime(month.year, month.month).weekday - 1;
    final days = ProgressCalculator.daysInMonth(month);
    final rows = ProgressCalculator.weekRows(month);

    return Column(
      children: [
        Row(
          children: [
            for (final d in _weekdays)
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var r = 0; r < rows; r++)
          Row(
            children: [
              for (var c = 0; c < 7; c++)
                Expanded(child: _cell(context, r * 7 + c - offset + 1, days)),
            ],
          ),
      ],
    );
  }

  Widget _cell(BuildContext context, int day, int days) {
    if (day < 1 || day > days) return const SizedBox(height: 48);
    final scheme = Theme.of(context).colorScheme;
    final count = sessionsPerDay[day] ?? 0;
    final selected = day == selectedDay;
    final date = DateTime(month.year, month.month, day);
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${DateFormat.MMMMd().format(date)}, '
          '${count == 0 ? 'no workouts' : '$count ${count == 1 ? 'workout' : 'workouts'}'}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onSelect(selected ? null : day),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: count > 0 ? scheme.primaryContainer : null,
                border: selected
                    ? Border.all(color: scheme.primary, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: count > 0 ? FontWeight.w700 : null,
                      color: count > 0 ? scheme.onPrimaryContainer : null,
                    ),
                  ),
                  if (count > 0)
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
