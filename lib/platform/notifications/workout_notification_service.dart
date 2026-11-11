/// Spoken clip a phase-change notification plays as its sound, standing in
/// for live TTS while the app is suspended. [resource] names the bundled file
/// (Android `res/raw/<resource>.wav`, iOS `<resource>.caf`); keep in sync with
/// tool/generate_cue_sounds.py.
enum CueSound {
  walk('cue_walk'),
  run('cue_run'),
  rest('cue_rest'),
  finish('cue_finish');

  const CueSound(this.resource);

  final String resource;
}

/// A fallback alert for a future phase boundary, delivered by the OS even if
/// the app is suspended. It is a reminder, not proof that app code ran.
class ScheduledCue {
  const ScheduledCue({
    required this.id,
    required this.at,
    required this.title,
    required this.body,
    this.sound,
  });

  /// Deterministic id so rescheduling replaces rather than duplicates.
  final int id;
  final DateTime at;
  final String title;
  final String body;

  /// `null`: the platform's default notification sound (voice cues off).
  final CueSound? sound;
}

class OngoingWorkoutInfo {
  const OngoingWorkoutInfo({
    required this.title,
    required this.body,
    this.countdownTo,
  });

  final String title;
  final String body;

  /// Phase deadline for a system-rendered countdown (Android chronometer).
  final DateTime? countdownTo;
}

enum NotificationPermission { granted, denied, unknown }

abstract interface class WorkoutNotificationService {
  Future<void> initialize();
  Future<NotificationPermission> permission();

  /// Shows the OS permission prompt. Call only after explaining why.
  Future<NotificationPermission> requestPermission();

  /// Android: whether exact alarms are allowed. Other platforms: true.
  Future<bool> canScheduleExact();

  /// Android: opens the system "Alarms & reminders" setting.
  Future<void> requestExactPermission();

  /// Android only; no-op elsewhere.
  Future<void> showOngoing(OngoingWorkoutInfo info);

  /// Replaces all previously scheduled cues.
  Future<void> scheduleCues(List<ScheduledCue> cues);

  /// Removes scheduled cues and the ongoing notification.
  Future<void> cancelWorkoutNotifications();
}

class NoopNotificationService implements WorkoutNotificationService {
  final List<List<ScheduledCue>> scheduled = [];
  int cancelCount = 0;

  @override
  Future<void> initialize() async {}

  @override
  Future<NotificationPermission> permission() async =>
      NotificationPermission.unknown;

  @override
  Future<NotificationPermission> requestPermission() async =>
      NotificationPermission.denied;

  @override
  Future<bool> canScheduleExact() async => true;

  @override
  Future<void> requestExactPermission() async {}

  @override
  Future<void> showOngoing(OngoingWorkoutInfo info) async {}

  @override
  Future<void> scheduleCues(List<ScheduledCue> cues) async =>
      scheduled.add(cues);

  @override
  Future<void> cancelWorkoutNotifications() async => cancelCount++;
}
