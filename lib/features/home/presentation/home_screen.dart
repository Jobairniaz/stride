import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/common.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/utils/duration_format.dart';
import '../../progress/application/progress_providers.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/app_settings.dart';
import '../../workout/application/workout_controller.dart';
import '../../workout/domain/entities/workout_enums.dart';
import '../../workout/domain/entities/workout_snapshot.dart';
import '../../workout/domain/services/workout_engine.dart';
import '../../workout/presentation/widgets/duration_picker_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workout = ref.watch(workoutControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider).now().toLocal();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Text(_greeting(now), style: theme.textTheme.headlineSmall),
            Text(
              DateFormat.MMMMEEEEd().format(now),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            const _ConsistencyLine(),
            const SizedBox(height: 16),
            if (workout.recovery != null) ...[
              _RecoveryCard(snapshot: workout.recovery!),
              const SizedBox(height: 16),
            ],
            if (workout.active != null) ...[
              _ActiveCard(snapshot: workout.active!, now: workout.now),
              const SizedBox(height: 16),
            ],
            _PlanCard(settings: settings),
            const SizedBox(height: 24),
            Center(
              child: _GoButton(
                enabled: workout.canStart,
                onPressed: () => _start(context, ref),
              ),
            ),
            const SizedBox(height: 24),
            const _TodayCard(),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text('Monthly progress'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.go('/progress'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _greeting(DateTime local) {
    if (local.hour < 12) return 'Good morning';
    if (local.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsControllerProvider);
    if (!settings.notificationPromptShown) {
      await _explainNotifications(context, ref);
      if (!context.mounted) return;
    }
    try {
      ref.read(workoutControllerProvider.notifier).start();
      unawaited(context.push('/workout'));
    } on InvalidWorkoutPlanFailure catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// One-time, contextual explanation before the OS permission prompt.
  Future<void> _explainNotifications(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final allow = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined),
        title: const Text('Alerts when your screen is locked'),
        content: const Text(
          'Your phone may pause Stride in the background. Notifications let '
          'the system alert you when a phase changes, even if voice cues '
          'cannot play. You can change this later in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow notifications'),
          ),
        ],
      ),
    );
    await ref
        .read(settingsControllerProvider.notifier)
        .update((s) => s.copyWith(notificationPromptShown: true));
    if (allow == true) {
      await ref.read(notificationServiceProvider).requestPermission();
    }
  }
}

class _ConsistencyLine extends ConsumerWidget {
  const _ConsistencyLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider).now().toLocal();
    final thisMonth = DateTime(now.year, now.month);
    final stats = ref.watch(monthlyStatsProvider(thisMonth)).value;
    final streak = ref.watch(streakProvider).value;
    if (stats == null || streak == null) return const SizedBox.shrink();
    final parts = [
      '${stats.sessionCount} ${stats.sessionCount == 1 ? 'workout' : 'workouts'} '
          'this month',
      if (streak.current > 0) '${streak.current}-day streak',
    ];
    return Text(
      parts.join(' · '),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class _GoButton extends StatelessWidget {
  const _GoButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Start workout',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 168,
        child: FilledButton(
          key: const Key('start-workout'),
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            padding: EdgeInsets.zero,
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 48),
                  Text(
                    'GO',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
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

class _PlanCard extends ConsumerWidget {
  const _PlanCard({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phases = context.phaseColors;
    final rounds = settings.targetRounds;
    final controller = ref.read(settingsControllerProvider.notifier);

    Future<void> editDuration(PhaseType type) async {
      final current = type == PhaseType.walking
          ? settings.walkDuration
          : settings.runDuration;
      final d = await showDurationPicker(
        context,
        title: '${type.label} duration',
        initial: current,
      );
      if (d == null || !context.mounted) return;
      await runWithFeedback(
        context,
        () => controller.update(
          (s) => type == PhaseType.walking
              ? s.copyWith(walkDuration: d)
              : s.copyWith(runDuration: d),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                phaseIcon(PhaseType.walking),
                color: phases.walking,
              ),
              title: const Text('Walk'),
              trailing: Text(formatDurationLabel(settings.walkDuration)),
              onTap: () => editDuration(PhaseType.walking),
            ),
            ListTile(
              leading: Icon(
                phaseIcon(PhaseType.running),
                color: phases.running,
              ),
              title: const Text('Run'),
              trailing: Text(formatDurationLabel(settings.runDuration)),
              onTap: () => editDuration(PhaseType.running),
            ),
            ListTile(
              leading: const Icon(Icons.repeat_rounded),
              title: const Text('Rounds'),
              trailing: Text(rounds == null ? 'Until I stop' : '$rounds'),
              onTap: () async {
                final (ok, value) = await showRoundsPicker(
                  context,
                  initial: rounds,
                );
                if (!ok || !context.mounted) return;
                await runWithFeedback(
                  context,
                  () => controller.update(
                    (s) => s.copyWith(targetRounds: () => value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecoveryCard extends ConsumerWidget {
  const _RecoveryCard({required this.snapshot});

  final WorkoutSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutControllerProvider);
    final controller = ref.read(workoutControllerProvider.notifier);
    final theme = Theme.of(context);
    final started = snapshot.workoutStartedAt.toLocal();
    final checkpoint = snapshot.lastReconciledAt.toLocal();
    final canResume = state.canResumeRecovery;

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.restore_rounded),
                const SizedBox(width: 8),
                Text('Unfinished workout', style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Started ${DateFormat.MMMd().add_jm().format(started)}. '
              'Last saved at ${DateFormat.jm().format(checkpoint)} '
              '(${snapshot.isPaused ? 'paused' : snapshot.current.type.label.toLowerCase()}). '
              '${canResume ? 'Resuming applies the time that passed; '
                        'cues during that time were not spoken.' : 'It is too long ago to resume '
                        '(more than ${WorkoutEngine.maxResumeGap.inHours} hours).'}',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (canResume)
                  FilledButton(
                    onPressed: state.saving
                        ? null
                        : () {
                            controller.resumeRecovered();
                            context.push('/workout');
                          },
                    child: const Text('Resume'),
                  ),
                OutlinedButton(
                  onPressed: state.saving ? null : controller.saveRecovered,
                  child: const Text('Save up to last checkpoint'),
                ),
                TextButton(
                  onPressed: state.saving
                      ? null
                      : () async {
                          final ok = await confirmDialog(
                            context,
                            title: 'Discard unfinished workout?',
                            message: 'It will not be saved to your history.',
                            confirmLabel: 'Discard',
                            destructive: true,
                          );
                          if (ok) await controller.discardRecovered();
                        },
                  child: const Text('Discard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard({required this.snapshot, required this.now});

  final WorkoutSnapshot snapshot;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final color = context.phaseColors.of(snapshot.current.type);
    return Card(
      child: ListTile(
        leading: Icon(phaseIcon(snapshot.current.type), color: color),
        title: Text(
          '${snapshot.current.type.label}'
          '${snapshot.isPaused ? ' · paused' : ''}',
        ),
        subtitle: Text(
          'Workout in progress · ${formatCountdown(snapshot.remainingAt(now))} left',
        ),
        trailing: FilledButton.tonal(
          onPressed: () => context.push('/workout'),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todaySessionsProvider);
    final latest = ref.watch(latestSessionProvider);
    return today.when(
      loading: () => const SizedBox(height: 72),
      error: (e, _) => Card(
        child: ListTile(
          leading: const Icon(Icons.error_outline),
          title: const Text('Could not load today’s workouts'),
          subtitle: Text(describeError(e)),
        ),
      ),
      data: (sessions) {
        if (sessions.isNotEmpty) {
          final active = sessions.fold(
            Duration.zero,
            (sum, s) => sum + s.activeDuration,
          );
          return Card(
            child: ListTile(
              leading: const Icon(Icons.today_rounded),
              title: Text(
                'Today: ${sessions.length} '
                '${sessions.length == 1 ? 'workout' : 'workouts'}',
              ),
              subtitle: Text('${formatTotalMinutes(active)} active'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/session/${sessions.last.id}'),
            ),
          );
        }
        final last = latest.value;
        if (last == null) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.flag_outlined),
              title: Text('No workouts yet'),
              subtitle: Text('Tap GO to start your first one.'),
            ),
          );
        }
        return Card(
          child: ListTile(
            leading: const Icon(Icons.history_rounded),
            title: const Text('Last workout'),
            subtitle: Text(
              '${DateFormat.MMMEd().format(last.startedAt.toLocal())} · '
              '${formatTotalMinutes(last.activeDuration)} active',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/session/${last.id}'),
          ),
        );
      },
    );
  }
}
