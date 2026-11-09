import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Active minutes per calendar week row of the month.
class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key, required this.weeklyActive});

  final List<Duration> weeklyActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = [for (final d in weeklyActive) d.inSeconds / 60];
    final maxY = minutes.fold<double>(0, (m, v) => v > m ? v : m);
    final description = [
      for (final (i, m) in minutes.indexed) 'week ${i + 1}: ${m.round()} min',
    ].join(', ');

    return Semantics(
      label: 'Active minutes by week. $description',
      excludeSemantics: true,
      child: SizedBox(
        height: 160,
        child: BarChart(
          BarChartData(
            maxY: maxY <= 0 ? 10 : maxY * 1.2,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      'W${value.toInt() + 1}',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
            barGroups: [
              for (final (i, m) in minutes.indexed)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: m,
                      width: 22,
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                  showingTooltipIndicators: const [],
                ),
            ],
          ),
          duration: Duration.zero,
        ),
      ),
    );
  }
}
