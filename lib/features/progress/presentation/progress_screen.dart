import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../core/utils/duration_format.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/units.dart';
import '../../settings/application/settings_controller.dart';
import '../../workout/domain/entities/workout_enums.dart';
import '../../workout/domain/entities/workout_session.dart';
import '../application/progress_providers.dart';
import '../domain/progress_calculator.dart';
import 'month_calendar.dart';
import 'weekly_chart.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final stats = ref.watch(monthlyStatsProvider(month));
    final now = ref.watch(clockProvider).now().toLocal();
    final isCurrentMonth = now.year == month.year && now.month == month.month;
    final atLatestMonth = !DateTime(now.year, now.month).isAfter(month);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _MonthSelector(month: month, canGoForward: !atLatestMonth),
          const SizedBox(height: 8),
          stats.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => ErrorMessage(
              message: describeError(e),
              onRetry: () => ref.invalidate(monthSessionsProvider(month)),
            ),
            data: (s) => s.isEmpty
                ? EmptyState(
                    icon: Icons.directions_walk_rounded,
                    title: 'No workouts in ${DateFormat.MMMM().format(month)}',
                    message: isCurrentMonth
                        ? 'Your saved workouts will appear here.'
                        : 'Nothing was recorded this month.',
                    action: isCurrentMonth
                        ? FilledButton.icon(
                            onPressed: () => context.go('/'),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start a workout'),
                          )
                        : null,
                  )
                : _MonthContent(stats: s),
          ),
          const SizedBox(height: 16),
          const _BodySummaryCard(),
        ],
      ),
    );
  }
}

class _MonthSelector extends ConsumerWidget {
  const _MonthSelector({required this.month, required this.canGoForward});

  final DateTime month;
  final bool canGoForward;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(selectedMonthProvider.notifier);
    return Row(
      children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: notifier.previous,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Text(
            DateFormat.yMMMM().format(month),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: canGoForward ? notifier.next : null,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

class _MonthContent extends ConsumerWidget {
  const _MonthContent({required this.stats});

  final MonthlyStats stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phases = context.phaseColors;
    final streak = ref.watch(streakProvider).value ?? StreakStats.zero;
    final caloriesOn = ref.watch(
      settingsControllerProvider.select((s) => s.calorieEstimatesEnabled),
    );
    final selectedDay = ref.watch(selectedDayProvider);
    final sessions = ref.watch(monthSessionsProvider(stats.month)).value ?? [];
    final daySessions = selectedDay == null
        ? const <WorkoutSession>[]
        : sessions
              .where((s) => s.startedAt.toLocal().day == selectedDay)
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatGrid(
          children: [
            StatTile(
              label: 'Sessions',
              value: '${stats.sessionCount}',
              icon: Icons.check_circle_outline_rounded,
            ),
            StatTile(
              label: 'Active time',
              value: formatTotalMinutes(stats.active),
              icon: Icons.timer_outlined,
            ),
            StatTile(
              label: 'Walking',
              value: formatTotalMinutes(stats.walking),
              icon: phaseIcon(PhaseType.walking),
              color: phases.walking,
            ),
            StatTile(
              label: 'Running',
              value: formatTotalMinutes(stats.running),
              icon: phaseIcon(PhaseType.running),
              color: phases.running,
            ),
            StatTile(
              label: 'Rest',
              value: formatTotalMinutes(stats.rest),
              icon: phaseIcon(PhaseType.rest),
              color: phases.rest,
            ),
            StatTile(
              label: 'Avg active / session',
              value: formatTotalMinutes(stats.averageActive),
              icon: Icons.av_timer_rounded,
            ),
            StatTile(
              label: 'Workout days',
              value: '${stats.workoutDays}',
              icon: Icons.event_available_rounded,
            ),
            StatTile(
              label: 'Streak (best)',
              value: '${streak.current} (${streak.best}) days',
              icon: Icons.local_fire_department_outlined,
            ),
            if (caloriesOn && stats.exerciseKcal != null)
              StatTile(
                label: 'Estimated kcal',
                value: '≈ ${stats.exerciseKcal!.round()}',
                icon: Icons.bolt_rounded,
              ),
          ],
        ),
        if (caloriesOn && stats.exerciseKcal != null) ...[
          const SizedBox(height: 6),
          Text(
            'Estimated walking + running energy from '
            '${stats.sessionsWithEstimate} of ${stats.sessionCount} sessions '
            '(those recorded with a body weight). Not a measurement.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SectionHeader('Calendar'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: MonthCalendar(
              month: stats.month,
              sessionsPerDay: stats.sessionsPerDay,
              selectedDay: selectedDay,
              onSelect: ref.read(selectedDayProvider.notifier).select,
            ),
          ),
        ),
        const SectionHeader('Active minutes by week'),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
            child: WeeklyChart(weeklyActive: stats.weeklyActive),
          ),
        ),
        if (selectedDay != null) ...[
          SectionHeader(
            DateFormat.MMMMEEEEd().format(
              DateTime(stats.month.year, stats.month.month, selectedDay),
            ),
          ),
          if (daySessions.isEmpty)
            const Card(child: ListTile(title: Text('No workouts on this day')))
          else
            Card(
              child: Column(
                children: [
                  for (final s in daySessions)
                    ListTile(
                      leading: const Icon(Icons.directions_run_rounded),
                      title: Text(
                        DateFormat.jm().format(s.startedAt.toLocal()),
                      ),
                      subtitle: Text(
                        '${formatTotalMinutes(s.activeDuration)} active · '
                        '${s.completedRounds} rounds',
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/session/${s.id}'),
                    ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _BodySummaryCard extends ConsumerWidget {
  const _BodySummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bmi = ref.watch(bmiProvider).value;
    final weight = ref.watch(currentWeightProvider).value;
    final unit = ref.watch(profileProvider).value?.weightUnit ?? WeightUnit.kg;
    final subtitle = [
      if (weight != null)
        'Weight ${BodyUnits.formatWeight(weight.weightGrams, unit)}',
      if (bmi != null) 'BMI ${bmi.value.toStringAsFixed(1)}',
    ];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monitor_weight_outlined),
        title: const Text('Body & weight trend'),
        subtitle: Text(
          subtitle.isEmpty
              ? 'Optional: add height and weight'
              : subtitle.join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/profile'),
      ),
    );
  }
}
