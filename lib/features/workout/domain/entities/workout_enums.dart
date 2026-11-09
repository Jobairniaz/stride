enum PhaseType {
  walking,
  running,
  rest;

  bool get isWork => this != PhaseType.rest;

  String get label => switch (this) {
    PhaseType.walking => 'Walking',
    PhaseType.running => 'Running',
    PhaseType.rest => 'Rest',
  };
}

/// Persisted lifecycle status of a workout session.
enum WorkoutStatus { running, paused, completed, discarded }

/// How a single phase segment ended.
enum SegmentCompletion {
  /// Ran until its deadline.
  completed,

  /// The user skipped ahead.
  skipped,

  /// Ended early by an inserted break or by stopping the workout.
  interrupted,
}

enum CompletionReason {
  userStopped('user_stopped'),
  targetReached('target_reached'),
  recovered('recovered');

  const CompletionReason(this.storageKey);

  final String storageKey;

  static CompletionReason fromStorage(String key) =>
      values.firstWhere((r) => r.storageKey == key);

  String get label => switch (this) {
    CompletionReason.userStopped => 'Stopped by you',
    CompletionReason.targetReached => 'All rounds completed',
    CompletionReason.recovered => 'Ended after app recovery',
  };
}
