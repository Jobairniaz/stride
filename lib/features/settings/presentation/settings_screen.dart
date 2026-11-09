import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/widgets/common.dart';
import '../../../core/utils/duration_format.dart';
import '../../../platform/audio/speech_announcer.dart';
import '../../../platform/notifications/workout_notification_service.dart';
import '../../workout/presentation/widgets/duration_picker_sheet.dart';
import '../application/alert_status_provider.dart';
import '../application/settings_controller.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    Future<void> set(AppSettings Function(AppSettings) change) =>
        runWithFeedback(context, () => controller.update(change));

    Future<void> pickDuration(
      String title,
      Duration initial,
      AppSettings Function(AppSettings, Duration) apply,
    ) async {
      final d = await showDurationPicker(
        context,
        title: title,
        initial: initial,
      );
      if (d != null) await set((s) => apply(s, d));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SectionHeader('Workout'),
          ListTile(
            leading: const Icon(Icons.directions_walk_rounded),
            title: const Text('Walking'),
            trailing: Text(formatDurationLabel(s.walkDuration)),
            onTap: () => pickDuration(
              'Walking duration',
              s.walkDuration,
              (s, d) => s.copyWith(walkDuration: d),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_run_rounded),
            title: const Text('Running'),
            trailing: Text(formatDurationLabel(s.runDuration)),
            onTap: () => pickDuration(
              'Running duration',
              s.runDuration,
              (s, d) => s.copyWith(runDuration: d),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.coffee_rounded),
            title: const Text('Default break'),
            trailing: Text(formatDurationLabel(s.breakDuration)),
            onTap: () => pickDuration(
              'Default break',
              s.breakDuration,
              (s, d) => s.copyWith(breakDuration: d),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.repeat_rounded),
            title: const Text('Rounds'),
            trailing: Text(
              s.targetRounds == null ? 'Until I stop' : '${s.targetRounds}',
            ),
            onTap: () async {
              final (ok, value) = await showRoundsPicker(
                context,
                initial: s.targetRounds,
              );
              if (ok) await set((s) => s.copyWith(targetRounds: () => value));
            },
          ),
          const SectionHeader('Coaching'),
          SwitchListTile(
            secondary: const Icon(Icons.record_voice_over_outlined),
            title: const Text('Voice cues'),
            subtitle: const Text('Phase changes are spoken'),
            value: s.voiceEnabled,
            onChanged: (v) => set((s) => s.copyWith(voiceEnabled: v)),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.looks_one_outlined),
            title: const Text('10-second warning'),
            value: s.announceTenSeconds,
            onChanged: s.voiceEnabled
                ? (v) => set((s) => s.copyWith(announceTenSeconds: v))
                : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.timer_3_outlined),
            title: const Text('3-2-1 countdown'),
            value: s.announceCountdown,
            onChanged: s.voiceEnabled
                ? (v) => set((s) => s.copyWith(announceCountdown: v))
                : null,
          ),
          _VoiceLanguageTile(settings: s),
          const _VoiceTestTile(),
          SwitchListTile(
            secondary: const Icon(Icons.vibration_rounded),
            title: const Text('Vibrate on phase change'),
            subtitle: const Text('While Stride is on screen'),
            value: s.hapticsEnabled,
            onChanged: (v) => set((s) => s.copyWith(hapticsEnabled: v)),
          ),
          const SectionHeader('Background alerts'),
          const _AlertsSection(),
          const SectionHeader('Display'),
          ListTile(
            leading: const Icon(Icons.brightness_6_outlined),
            title: const Text('Theme'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {s.themeMode},
                onSelectionChanged: (v) =>
                    set((s) => s.copyWith(themeMode: v.single)),
              ),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.light_mode_outlined),
            title: const Text('Keep screen on during workout'),
            subtitle: const Text(
              'Only while the workout screen is visible. Uses more battery.',
            ),
            value: s.keepScreenAwake,
            onChanged: (v) => set((s) => s.copyWith(keepScreenAwake: v)),
          ),
          const SectionHeader('Profile'),
          ListTile(
            leading: const Icon(Icons.monitor_weight_outlined),
            title: const Text('Height, weight & BMI'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/profile'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.local_fire_department_outlined),
            title: const Text('Show estimated calories'),
            subtitle: const Text(
              'Rough MET-based estimate using your latest weight. '
              'Not a measurement.',
            ),
            value: s.calorieEstimatesEnabled,
            onChanged: (v) =>
                set((s) => s.copyWith(calorieEstimatesEnabled: v)),
          ),
          const SectionHeader('Data'),
          const _DataSection(),
          const SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy & limitations'),
            subtitle: const Text('All data stays on this device'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/about'),
          ),
        ],
      ),
    );
  }
}

class _VoiceLanguageTile extends ConsumerWidget {
  const _VoiceLanguageTile({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
    leading: const Icon(Icons.language_rounded),
    title: const Text('Voice language'),
    trailing: Text(settings.voiceLanguage ?? 'Device default'),
    enabled: settings.voiceEnabled,
    onTap: () async {
      final languages = await ref
          .read(speechAnnouncerProvider)
          .availableLanguages();
      if (!context.mounted) return;
      if (languages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No text-to-speech voices found. Install a voice in your '
              'device settings.',
            ),
          ),
        );
        return;
      }
      final picked = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('Voice language'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, ''),
              child: const Text('Device default'),
            ),
            for (final l in languages)
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context, l),
                child: Text(l),
              ),
          ],
        ),
      );
      if (picked == null || !context.mounted) return;
      await runWithFeedback(
        context,
        () => ref
            .read(settingsControllerProvider.notifier)
            .update(
              (s) => s.copyWith(
                voiceLanguage: () => picked.isEmpty ? null : picked,
              ),
            ),
      );
    },
  );
}

class _VoiceTestTile extends ConsumerStatefulWidget {
  const _VoiceTestTile();

  @override
  ConsumerState<_VoiceTestTile> createState() => _VoiceTestTileState();
}

class _VoiceTestTileState extends ConsumerState<_VoiceTestTile> {
  bool _busy = false;

  Future<void> _test() async {
    setState(() => _busy = true);
    final announcer = ref.read(speechAnnouncerProvider);
    final ok = await announcer.speakTest('Start running');
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            announcer.status == SpeechStatus.unavailable
                ? 'Text-to-speech is unavailable. Check that a voice is '
                      'installed in your device settings. Workouts still run '
                      'and vibrate on phase changes.'
                : 'Could not play the test announcement.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Icons.volume_up_outlined),
    title: const Text('Test voice'),
    subtitle: const Text('Plays “Start running” now'),
    trailing: _busy
        ? const SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : null,
    onTap: _busy ? null : _test,
  );
}

class _AlertsSection extends ConsumerWidget {
  const _AlertsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(alertStatusProvider);
    final service = ref.read(notificationServiceProvider);
    return status.when(
      loading: () => const ListTile(title: Text('Checking…')),
      error: (e, _) => ListTile(
        leading: const Icon(Icons.error_outline),
        title: const Text('Could not check notification status'),
        subtitle: Text(describeError(e)),
      ),
      data: (a) => Column(
        children: [
          ListTile(
            leading: Icon(
              a.permission == NotificationPermission.granted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
            ),
            title: const Text('Phase-change notifications'),
            subtitle: Text(
              a.permission == NotificationPermission.granted
                  ? 'On. Used as a fallback when the app is in the background.'
                  : 'Off. Workouts still run in the foreground, but you may '
                        'miss phase changes while the screen is locked.',
            ),
            trailing: a.permission == NotificationPermission.granted
                ? null
                : TextButton(
                    onPressed: () async {
                      final result = await service.requestPermission();
                      if (result != NotificationPermission.granted &&
                          context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Notifications are off. You can enable them '
                              'for Stride in your system settings.',
                            ),
                          ),
                        );
                      }
                      ref.invalidate(alertStatusProvider);
                    },
                    child: const Text('Enable'),
                  ),
          ),
          if (Platform.isAndroid && !a.exactAllowed)
            ListTile(
              leading: const Icon(Icons.alarm_outlined),
              title: const Text('Precise alert timing'),
              subtitle: const Text(
                'Without “Alarms & reminders” access, Android may deliver '
                'background phase alerts late.',
              ),
              trailing: TextButton(
                onPressed: () async {
                  await service.requestExactPermission();
                  ref.invalidate(alertStatusProvider);
                },
                child: const Text('Allow'),
              ),
            ),
        ],
      ),
    );
  }
}

class _DataSection extends ConsumerWidget {
  const _DataSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.delete_sweep_outlined),
        title: const Text('Clear workout history'),
        subtitle: const Text('Delete every saved workout'),
        onTap: () async {
          final ok = await confirmDialog(
            context,
            title: 'Clear all workout history?',
            message: 'Every saved workout will be permanently deleted.',
            confirmLabel: 'Delete all',
            destructive: true,
          );
          if (!ok || !context.mounted) return;
          await runWithFeedback(
            context,
            () => ref.read(workoutRepositoryProvider).clearHistory(),
            successMessage: 'Workout history cleared',
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.person_remove_outlined),
        title: const Text('Delete profile & weight history'),
        subtitle: const Text('Height, units and every weight entry'),
        onTap: () async {
          final ok = await confirmDialog(
            context,
            title: 'Delete profile data?',
            message:
                'Your height and all weight entries will be deleted. Saved '
                'workouts keep their recorded calorie estimates.',
            confirmLabel: 'Delete',
            destructive: true,
          );
          if (!ok || !context.mounted) return;
          await runWithFeedback(
            context,
            () => ref.read(profileRepositoryProvider).deleteAllProfileData(),
            successMessage: 'Profile data deleted',
          );
        },
      ),
    ],
  );
}
