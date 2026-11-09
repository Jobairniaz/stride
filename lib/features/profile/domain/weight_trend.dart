import 'fitness_profile.dart';

enum TrendPeriod {
  days30('30 days', Duration(days: 30)),
  days90('90 days', Duration(days: 90)),
  year('1 year', Duration(days: 365)),
  all('All', null);

  const TrendPeriod(this.label, this.span);
  final String label;
  final Duration? span;
}

abstract final class WeightTrend {
  /// Entries within [period] ending at [now], oldest first.
  static List<WeightMeasurement> inPeriod(
    List<WeightMeasurement> entries,
    TrendPeriod period,
    DateTime now,
  ) {
    final span = period.span;
    final from = span == null ? null : now.subtract(span);
    return entries
        .where((e) => from == null || !e.measuredAt.isBefore(from))
        .toList()
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
  }

  /// Change from the latest entry of the previous local calendar month to
  /// the latest entry of the current local month, in grams. `null` if either
  /// month has no entry.
  static int? monthlyChangeGrams(
    List<WeightMeasurement> entries,
    DateTime now,
  ) {
    final local = now.toLocal();
    final thisMonth = DateTime(local.year, local.month);
    final lastMonth = DateTime(local.year, local.month - 1);
    WeightMeasurement? latestIn(DateTime month) {
      WeightMeasurement? best;
      for (final e in entries) {
        final d = e.measuredAt.toLocal();
        if (d.year != month.year || d.month != month.month) continue;
        if (best == null || e.measuredAt.isAfter(best.measuredAt)) best = e;
      }
      return best;
    }

    final current = latestIn(thisMonth);
    final previous = latestIn(lastMonth);
    if (current == null || previous == null) return null;
    return current.weightGrams - previous.weightGrams;
  }
}
