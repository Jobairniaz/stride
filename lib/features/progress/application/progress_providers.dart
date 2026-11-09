import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../workout/domain/entities/workout_session.dart';
import '../domain/progress_calculator.dart';

/// First day of the month shown on the Progress tab (local time).
final selectedMonthProvider = NotifierProvider<SelectedMonth, DateTime>(
  SelectedMonth.new,
);

class SelectedMonth extends Notifier<DateTime> {
  @override
  DateTime build() =>
      ProgressCalculator.monthStart(ref.read(clockProvider).now().toLocal());

  void previous() => state = DateTime(state.year, state.month - 1);

  void next() => state = DateTime(state.year, state.month + 1);
}

/// Selected day-of-month on the calendar, or null for none.
final selectedDayProvider = NotifierProvider<SelectedDay, int?>(
  SelectedDay.new,
);

class SelectedDay extends Notifier<int?> {
  @override
  int? build() {
    final month = ref.watch(selectedMonthProvider);
    final today = ref.read(clockProvider).now().toLocal();
    return today.year == month.year && today.month == month.month
        ? today.day
        : null;
  }

  void select(int? day) => state = day;
}

/// Sessions that started in the given local month.
final monthSessionsProvider = StreamProvider.autoDispose
    .family<List<WorkoutSession>, DateTime>((ref, month) {
      final start = ProgressCalculator.monthStart(month);
      final end = ProgressCalculator.nextMonthStart(start);
      return ref
          .watch(workoutRepositoryProvider)
          .watchSessionsBetween(start.toUtc(), end.toUtc());
    });

final monthlyStatsProvider = Provider.autoDispose
    .family<AsyncValue<MonthlyStats>, DateTime>(
      (ref, month) => ref
          .watch(monthSessionsProvider(month))
          .whenData((s) => ProgressCalculator.monthly(month, s)),
    );

final streakProvider = StreamProvider.autoDispose<StreakStats>((ref) {
  final clock = ref.watch(clockProvider);
  return ref
      .watch(workoutRepositoryProvider)
      .watchAllSessionStarts()
      .map((starts) => ProgressCalculator.streaks(starts, clock.now()));
});

final todaySessionsProvider = StreamProvider.autoDispose<List<WorkoutSession>>((
  ref,
) {
  final now = ref.watch(clockProvider).now().toLocal();
  final start = DateTime(now.year, now.month, now.day);
  final end = DateTime(now.year, now.month, now.day + 1);
  return ref
      .watch(workoutRepositoryProvider)
      .watchSessionsBetween(start.toUtc(), end.toUtc());
});

final latestSessionProvider = StreamProvider.autoDispose<WorkoutSession?>(
  (ref) => ref.watch(workoutRepositoryProvider).watchLatestSession(),
);

final sessionDetailProvider = StreamProvider.autoDispose
    .family<WorkoutSession?, String>(
      (ref, id) => ref.watch(workoutRepositoryProvider).watchSession(id),
    );
