import '../../../core/errors/app_failure.dart';
import '../domain/entities/workout_snapshot.dart';
import '../domain/services/workout_engine.dart';

/// Immutable UI state for the workout feature.
class WorkoutState {
  const WorkoutState({
    required this.now,
    this.loading = true,
    this.active,
    this.recovery,
    this.failure,
    this.completedSessionId,
    this.saving = false,
    this.missedCues = false,
  });

  /// Time the state was last derived at (UTC).
  final DateTime now;

  /// Looking for an unfinished workout at launch.
  final bool loading;

  /// The running or paused workout, if any.
  final WorkoutSnapshot? active;

  /// An unfinished workout found after an app restart. Never resumed
  /// silently: the user chooses resume, save or discard.
  final WorkoutSnapshot? recovery;

  /// Most recent error to show the user.
  final AppFailure? failure;

  /// Set once a workout has been durably saved; the UI navigates to the
  /// summary and then acknowledges it.
  final String? completedSessionId;

  final bool saving;

  /// Phase boundaries passed while the app could not speak (suspended or
  /// killed); cues may have been missed.
  final bool missedCues;

  bool get canStart => !loading && active == null && recovery == null;

  /// Resuming after a very long gap would fabricate hours of phases.
  bool get canResumeRecovery =>
      recovery != null &&
      now.difference(recovery!.lastReconciledAt) <= WorkoutEngine.maxResumeGap;

  WorkoutState copyWith({
    DateTime? now,
    bool? loading,
    WorkoutSnapshot? Function()? active,
    WorkoutSnapshot? Function()? recovery,
    AppFailure? Function()? failure,
    String? Function()? completedSessionId,
    bool? saving,
    bool? missedCues,
  }) => WorkoutState(
    now: now ?? this.now,
    loading: loading ?? this.loading,
    active: active != null ? active() : this.active,
    recovery: recovery != null ? recovery() : this.recovery,
    failure: failure != null ? failure() : this.failure,
    completedSessionId: completedSessionId != null
        ? completedSessionId()
        : this.completedSessionId,
    saving: saving ?? this.saving,
    missedCues: missedCues ?? this.missedCues,
  );
}
