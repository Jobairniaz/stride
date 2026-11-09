import '../../workout/domain/entities/workout_session.dart';

/// Aggregates for one local calendar month.
///
/// Attribution rule: a session belongs to the local calendar day (and month)
/// on which it *started*, even if it crosses midnight.
class MonthlyStats {
  const MonthlyStats({
    required this.month,
    required this.sessionCount,
    required this.walking,
    required this.running,
    required this.rest,
    required this.sessionsPerDay,
    required this.weeklyActive,
    required this.exerciseKcal,
    required this.sessionsWithEstimate,
  });

  /// First day of the month, local time.
  final DateTime month;
  final int sessionCount;
  final Duration walking;
  final Duration running;
  final Duration rest;

  /// Day of month (1-based) → number of sessions.
  final Map<int, int> sessionsPerDay;

  /// Active time per calendar week row (Monday-start) of the month.
  final List<Duration> weeklyActive;

  /// Sum of stored exercise estimates; `null` if no session has one.
  final double? exerciseKcal;
  final int sessionsWithEstimate;

  Duration get active => walking + running;

  int get workoutDays => sessionsPerDay.length;

  /// Active duration / session count. Sessions with zero active time (e.g.
  /// rest only) are included in the denominator.
  Duration get averageActive =>
      sessionCount == 0 ? Duration.zero : active ~/ sessionCount;

  bool get isEmpty => sessionCount == 0;
}

class StreakStats {
  const StreakStats({required this.current, required this.best});

  static const zero = StreakStats(current: 0, best: 0);

  final int current;
  final int best;
}

abstract final class ProgressCalculator {
  static DateTime monthStart(DateTime anyLocal) =>
      DateTime(anyLocal.year, anyLocal.month);

  static DateTime nextMonthStart(DateTime monthLocal) =>
      DateTime(monthLocal.year, monthLocal.month + 1);

  static int daysInMonth(DateTime monthLocal) =>
      DateTime(monthLocal.year, monthLocal.month + 1, 0).day;

  /// Number of Monday-start week rows needed to show [monthLocal].
  static int weekRows(DateTime monthLocal) {
    final offset = DateTime(monthLocal.year, monthLocal.month).weekday - 1;
    return ((offset + daysInMonth(monthLocal)) / 7).ceil();
  }

  static int weekRowOf(DateTime monthLocal, int day) {
    final offset = DateTime(monthLocal.year, monthLocal.month).weekday - 1;
    return (offset + day - 1) ~/ 7;
  }

  /// [sessions] may contain sessions outside the month; they are ignored.
  static MonthlyStats monthly(
    DateTime monthLocal,
    List<WorkoutSession> sessions,
  ) {
    final month = monthStart(monthLocal);
    var walking = Duration.zero;
    var running = Duration.zero;
    var rest = Duration.zero;
    var count = 0;
    double? kcal;
    var withEstimate = 0;
    final perDay = <int, int>{};
    final weekly = List<Duration>.filled(weekRows(month), Duration.zero);

    for (final s in sessions) {
      final local = s.startedAt.toLocal();
      if (local.year != month.year || local.month != month.month) continue;
      count++;
      walking += s.walkingDuration;
      running += s.runningDuration;
      rest += s.restDuration;
      perDay.update(local.day, (n) => n + 1, ifAbsent: () => 1);
      final row = weekRowOf(month, local.day);
      weekly[row] += s.activeDuration;
      final estimate = s.calorieEstimate;
      if (estimate != null) {
        kcal = (kcal ?? 0) + estimate.exerciseKcal;
        withEstimate++;
      }
    }

    return MonthlyStats(
      month: month,
      sessionCount: count,
      walking: walking,
      running: running,
      rest: rest,
      sessionsPerDay: perDay,
      weeklyActive: weekly,
      exerciseKcal: kcal,
      sessionsWithEstimate: withEstimate,
    );
  }

  /// Streak = consecutive local calendar days with at least one completed
  /// session. The current streak stays alive through today: if today has no
  /// session yet but yesterday did, the streak counts up to yesterday.
  static StreakStats streaks(Iterable<DateTime> sessionStarts, DateTime now) {
    final days = <DateTime>{
      for (final s in sessionStarts) _day(s.toLocal()),
    }.toList()..sort();
    if (days.isEmpty) return StreakStats.zero;

    var best = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      if (_nextDay(days[i - 1]) == days[i]) {
        run++;
        if (run > best) best = run;
      } else {
        run = 1;
      }
    }

    final daySet = days.toSet();
    final today = _day(now.toLocal());
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    var cursor = daySet.contains(today)
        ? today
        : (daySet.contains(yesterday) ? yesterday : null);
    var current = 0;
    while (cursor != null && daySet.contains(cursor)) {
      current++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return StreakStats(current: current, best: best);
  }

  static DateTime _day(DateTime local) =>
      DateTime(local.year, local.month, local.day);

  static DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);
}
