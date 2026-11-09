import '../entities/workout_session.dart';
import '../entities/workout_snapshot.dart';

abstract interface class WorkoutRepository {
  Future<void> saveActiveSnapshot(WorkoutSnapshot snapshot);
  Future<WorkoutSnapshot?> loadActiveSnapshot();
  Future<void> clearActiveSnapshot();

  /// Writes the session, its phase segments and clears the active snapshot in
  /// one transaction. Idempotent: saving the same session id twice is a no-op,
  /// so duplicate completion callbacks cannot double-count a workout.
  Future<void> saveCompletedSession(WorkoutSession session);

  /// Completed sessions whose start lies in `[startUtc, endUtc)`, oldest
  /// first. Returned sessions have empty `segments`; use [watchSession] for
  /// the phase timeline.
  Stream<List<WorkoutSession>> watchSessionsBetween(
    DateTime startUtc,
    DateTime endUtc,
  );

  /// One session including its phase segments.
  Stream<WorkoutSession?> watchSession(String id);

  /// Start instants of every completed session (for streaks).
  Stream<List<DateTime>> watchAllSessionStarts();

  Stream<WorkoutSession?> watchLatestSession();

  /// Deletes the session and its segments in one transaction.
  Future<void> deleteSession(String id);

  Future<void> clearHistory();
}
