import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/common.dart';
import '../../../../core/utils/duration_format.dart';
import '../../../profile/application/profile_providers.dart';
import '../../../profile/domain/calorie_estimator.dart';
import '../../../profile/domain/units.dart';
import '../../../progress/application/progress_providers.dart';
import '../../../settings/application/settings_controller.dart';
import '../../domain/entities/phase_segment.dart';
import '../../domain/entities/workout_enums.dart';
import '../../domain/entities/workout_session.dart';

/// Completion summary and history detail for one saved workout.
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({
    super.key,
    required this.sessionId,
    required this.justCompleted,
  });

  final String sessionId;
  final bool justCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionDetailProvider(sessionId));
    return Scaffold(
      appBar: AppBar(
        title: Text(justCompleted ? 'Workout complete' : 'Workout'),
        automaticallyImplyLeading: !justCompleted,
        actions: [
          if (session.value != null)
            IconButton(
              tooltip: 'Delete workout',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _delete(context, ref),
            ),
        ],
      ),
      body: session.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorMessage(
          message: describeError(e),
          onRetry: () => ref.invalidate(sessionDetailProvider(sessionId)),
        ),
        data: (s) => s == null
            ? const EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Workout not found',
                message: 'It may have been deleted.',
              )
            : _SessionBody(session: s),
      ),
      bottomNavigationBar: justCompleted
          ? SafeArea(
              minimum: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Done'),
              ),
            )
          : null,
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete this workout?',
      message: 'It will be removed from your history and monthly totals.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    final deleted = await runWithFeedback(
      context,
      () => ref.read(workoutRepositoryProvider).deleteSession(sessionId),
      successMessage: 'Workout deleted',
    );
    if (deleted && context.mounted) {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/');
      }
    }
  }
}

class _SessionBody extends ConsumerWidget {
  const _SessionBody({required this.session});

  final WorkoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final phases = context.phaseColors;
    final start = session.startedAt.toLocal();
    final end = session.endedAt.toLocal();
    final time = DateFormat.jm();
    final caloriesOn = ref.watch(
      settingsControllerProvider.select((s) => s.calorieEstimatesEnabled),
    );
    final weightUnit =
        ref.watch(profileProvider).value?.weightUnit ?? WeightUnit.kg;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          DateFormat.yMMMMEEEEd().format(start),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          '${time.format(start)} – ${time.format(end)} · '
          '${session.completionReason.label}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        StatGrid(
          children: [
            StatTile(
              label: 'Active time',
              value: formatElapsed(session.activeDuration),
              icon: Icons.timer_outlined,
            ),
            StatTile(
              label: 'Rounds',
              value: '${session.completedRounds}',
              icon: Icons.repeat_rounded,
            ),
            StatTile(
              label: 'Walking',
              value: formatElapsed(session.walkingDuration),
              icon: phaseIcon(PhaseType.walking),
              color: phases.walking,
            ),
            StatTile(
              label: 'Running',
              value: formatElapsed(session.runningDuration),
              icon: phaseIcon(PhaseType.running),
              color: phases.running,
            ),
            StatTile(
              label: 'Rest',
              value: formatElapsed(session.restDuration),
              icon: phaseIcon(PhaseType.rest),
              color: phases.rest,
            ),
            StatTile(
              label: 'Total incl. pauses',
              value: formatElapsed(session.totalElapsed),
              icon: Icons.schedule_rounded,
            ),
          ],
        ),
        if (caloriesOn) ...[
          const SizedBox(height: 12),
          _CalorieCard(estimate: session.calorieEstimate, unit: weightUnit),
        ],
        const SectionHeader('Phase timeline'),
        if (session.segments.isEmpty)
          const Text('No phases were recorded.')
        else
          Card(
            child: Column(
              children: [for (final seg in session.segments) _SegmentTile(seg)],
            ),
          ),
      ],
    );
  }
}

class _SegmentTile extends StatelessWidget {
  const _SegmentTile(this.segment);

  final PhaseSegment segment;

  @override
  Widget build(BuildContext context) {
    final color = context.phaseColors.of(segment.type);
    final status = switch (segment.completion) {
      SegmentCompletion.completed => null,
      SegmentCompletion.skipped => 'Skipped',
      SegmentCompletion.interrupted => 'Interrupted',
    };
    final label = segment.insertedByUser ? 'Break' : segment.type.label;
    return ListTile(
      leading: Icon(phaseIcon(segment.type), color: color),
      title: Text(label),
      subtitle: Text(
        [
          DateFormat.jms().format(segment.startedAt.toLocal()),
          ?status,
        ].join(' · '),
      ),
      trailing: Text(
        formatElapsed(segment.actualDuration),
        style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      ),
    );
  }
}

class _CalorieCard extends StatelessWidget {
  const _CalorieCard({required this.estimate, required this.unit});

  final CalorieEstimate? estimate;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final e = estimate;
    if (e == null) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.local_fire_department_outlined),
          title: Text('No calorie estimate'),
          subtitle: Text(
            'Estimates need a body weight. Add your weight in Profile to '
            'see estimates for future workouts.',
          ),
        ),
      );
    }
    final a = e.assumptions;
    return Card(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.local_fire_department_outlined),
          title: Text('Estimated ≈ ${e.exerciseKcal.round()} kcal'),
          subtitle: Text(
            'Walking + running. With rest ≈ ${e.totalKcal.round()} kcal.',
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How this is estimated', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              'MET × 3.5 × body weight (kg) ÷ 200 × minutes. '
              'Assumed METs: walking ${a.walkingMet}, running ${a.runningMet}, '
              'rest ${a.restMet}. Weight used: '
              '${BodyUnits.formatWeight(e.weightGrams, unit)}. '
              'Method ${e.methodVersion}.\n\n'
              'Stride does not measure speed, incline or heart rate, so this '
              'is a rough estimate, not a measurement. Paused time is not '
              'counted. This estimate is kept as recorded even if your weight '
              'changes later.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
