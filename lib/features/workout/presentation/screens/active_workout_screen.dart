import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/utils/duration_format.dart';
import '../../../settings/application/settings_controller.dart';
import '../../application/workout_controller.dart';
import '../../domain/entities/workout_snapshot.dart';
import '../widgets/duration_picker_sheet.dart';
import '../widgets/phase_ring.dart';

/// Focused full-screen workout view. All values are derived from the
/// controller's snapshot; this widget holds no timer.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  late final _screenWake = ref.read(screenWakeProvider);

  @override
  void initState() {
    super.initState();
    if (ref.read(settingsControllerProvider).keepScreenAwake) {
      _screenWake.setEnabled(true);
    }
  }

  @override
  void dispose() {
    _screenWake.setEnabled(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(workoutControllerProvider);
    final snapshot = state.active;

    if (snapshot == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: state.saving
              ? const CircularProgressIndicator()
              : TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('No active workout · Go home'),
                ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: _WorkoutBody(
            snapshot: snapshot,
            now: state.now,
            saving: state.saving,
            missedCues: state.missedCues,
            failure: state.failure?.message,
          ),
        ),
      ),
    );
  }
}

class _WorkoutBody extends ConsumerWidget {
  const _WorkoutBody({
    required this.snapshot,
    required this.now,
    required this.saving,
    required this.missedCues,
    required this.failure,
  });

  final WorkoutSnapshot snapshot;
  final DateTime now;
  final bool saving;
  final bool missedCues;
  final String? failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(workoutControllerProvider.notifier);
    final theme = Theme.of(context);
    final phase = snapshot.current;
    final color = context.phaseColors.of(phase.type);
    final remaining = snapshot.remainingAt(now);
    final progress = phase.plannedDuration.inMilliseconds == 0
        ? 1.0
        : 1 - remaining.inMilliseconds / phase.plannedDuration.inMilliseconds;
    final rounds = snapshot.plan.targetRounds;
    final next = snapshot.nextPhase;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back to home (workout keeps running)',
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              Expanded(
                child: Text(
                  rounds == null
                      ? 'Round ${snapshot.currentRound}'
                      : 'Round ${snapshot.currentRound} of $rounds',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton.icon(
                key: const Key('end-workout'),
                onPressed: saving ? null : () => _confirmEnd(context, ref),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  minimumSize: const Size(48, 48),
                ),
                icon: const Icon(Icons.stop_rounded),
                label: const Text('End'),
              ),
            ],
          ),
        ),
        if (failure != null)
          _Banner(
            icon: Icons.error_outline,
            text: failure!,
            actionLabel: 'Dismiss',
            onAction: controller.clearFailure,
          )
        else if (missedCues)
          _Banner(
            icon: Icons.info_outline,
            text:
                'Phases changed while Stride was in the background. '
                'Some voice cues may have been missed.',
            actionLabel: 'OK',
            onAction: controller.dismissMissedCues,
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: PhaseRing(
                  progress: progress,
                  color: color,
                  child: _RingContent(
                    snapshot: snapshot,
                    remaining: remaining,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
        Semantics(
          label: next.isFinish
              ? 'Next: finish'
              : 'Next phase: ${next.type!.label}',
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Next: ', style: theme.textTheme.titleMedium),
              if (next.isFinish) ...[
                const Icon(Icons.flag_rounded, size: 20),
                const SizedBox(width: 4),
                Text('Finish', style: theme.textTheme.titleMedium),
              ] else ...[
                Icon(
                  phaseIcon(next.type!),
                  size: 22,
                  color: context.phaseColors.of(next.type!),
                ),
                const SizedBox(width: 4),
                Text(next.type!.label, style: theme.textTheme.titleMedium),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Total ${formatElapsed(snapshot.movingElapsedAt(now))}',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: _SideButton(
                  key: const Key('skip-phase'),
                  onPressed: snapshot.canSkip && !saving
                      ? controller.skip
                      : null,
                  icon: Icons.skip_next_rounded,
                  label: 'Skip',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 72,
                  child: FilledButton.icon(
                    key: const Key('pause-resume'),
                    onPressed: saving
                        ? null
                        : (snapshot.isPaused
                              ? controller.resume
                              : controller.pause),
                    icon: Icon(
                      snapshot.isPaused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: 32,
                    ),
                    label: Text(snapshot.isPaused ? 'Resume' : 'Pause'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SideButton(
                  key: const Key('add-break'),
                  onPressed: snapshot.canInsertBreak && !saving
                      ? () => _addBreak(context, ref)
                      : null,
                  icon: Icons.coffee_rounded,
                  label: 'Break',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addBreak(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsControllerProvider);
    final isRest = !snapshot.current.type.isWork;
    final duration = await showDurationPicker(
      context,
      title: isRest ? 'Extend rest' : 'Take a break',
      initial: settings.breakDuration,
      confirmLabel: isRest ? 'Add time' : 'Start break',
      presets: const [
        Duration(seconds: 30),
        Duration(minutes: 1),
        Duration(minutes: 2),
        Duration(minutes: 3),
        Duration(minutes: 5),
      ],
    );
    if (duration == null) return;
    ref.read(workoutControllerProvider.notifier).insertBreak(duration);
  }

  Future<void> _confirmEnd(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(workoutControllerProvider.notifier);
    final meaningful =
        snapshot.movingElapsedAt(ref.read(clockProvider).now()) >=
        const Duration(seconds: 10);
    final choice = await showDialog<_EndChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End workout?'),
        content: Text(
          meaningful
              ? 'Save this workout to your history, or discard it.'
              : 'This workout is too short to save. Discard it?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _EndChoice.keepGoing),
            child: const Text('Keep going'),
          ),
          TextButton(
            key: const Key('discard-workout'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, _EndChoice.discard),
            child: const Text('Discard'),
          ),
          if (meaningful)
            FilledButton(
              key: const Key('save-workout'),
              onPressed: () => Navigator.pop(context, _EndChoice.save),
              child: const Text('Save & finish'),
            ),
        ],
      ),
    );
    switch (choice) {
      case _EndChoice.save:
        await controller.finish(save: true);
      case _EndChoice.discard:
        await controller.finish(save: false);
        // Saving navigates to the summary via the app-level listener;
        // discarding returns home explicitly.
        if (context.mounted &&
            ref.read(workoutControllerProvider).active == null) {
          context.go('/');
        }
      case _EndChoice.keepGoing || null:
        break;
    }
  }
}

enum _EndChoice { save, discard, keepGoing }

/// Secondary control with the icon above a single-line label, so labels
/// never wrap mid-word on narrow screens or at large text sizes.
class _SideButton extends StatelessWidget {
  const _SideButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon), Text(label, maxLines: 1)],
        ),
      ),
    ),
  );
}

class _RingContent extends StatelessWidget {
  const _RingContent({
    required this.snapshot,
    required this.remaining,
    required this.color,
  });

  final WorkoutSnapshot snapshot;
  final Duration remaining;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phase = snapshot.current;
    final label = phase.insertedByUser ? 'Break' : phase.type.label;
    return Padding(
      padding: const EdgeInsets.all(36),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              liveRegion: true,
              label: snapshot.isPaused ? '$label, paused' : label,
              excludeSemantics: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(phaseIcon(phase.type), color: color, size: 36),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              label: '${spokenDuration(remaining)} remaining',
              excludeSemantics: true,
              child: Text(
                formatCountdown(remaining),
                key: const Key('countdown'),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 88,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            if (snapshot.isPaused)
              Chip(
                avatar: const Icon(Icons.pause_rounded, size: 18),
                label: const Text('Paused'),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(child: Text(text)),
            TextButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    ),
  );
}
