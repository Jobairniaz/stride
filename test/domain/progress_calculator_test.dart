import 'package:flutter_test/flutter_test.dart';
import 'package:stride/features/profile/domain/calorie_estimator.dart';
import 'package:stride/features/progress/domain/progress_calculator.dart';
import 'package:stride/features/workout/domain/entities/workout_enums.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/entities/workout_session.dart';

WorkoutSession session(
  String id,
  DateTime localStart, {
  int walkMin = 10,
  int runMin = 8,
  int restMin = 1,
  double? kcal,
}) => WorkoutSession(
  id: id,
  startedAt: localStart.toUtc(),
  endedAt: localStart.add(const Duration(minutes: 30)).toUtc(),
  completionReason: CompletionReason.userStopped,
  walkingDuration: Duration(minutes: walkMin),
  runningDuration: Duration(minutes: runMin),
  restDuration: Duration(minutes: restMin),
  completedRounds: 4,
  plan: const WorkoutPlan(),
  segments: const [],
  calorieEstimate: kcal == null
      ? null
      : CalorieEstimate(
          exerciseKcal: kcal,
          restKcal: 0,
          methodVersion: 'met-v1',
          weightGrams: 70000,
          assumptions: CalorieEstimator.assumptions,
        ),
);

void main() {
  group('monthly totals', () {
    test('sums phase durations and counts days', () {
      final month = DateTime(2026, 11);
      final stats = ProgressCalculator.monthly(month, [
        session('a', DateTime(2026, 11, 2, 7), kcal: 100),
        session('b', DateTime(2026, 11, 2, 18)),
        session('c', DateTime(2026, 11, 9, 6), walkMin: 20, runMin: 0),
        session('outside', DateTime(2026, 10, 31, 7)),
      ]);
      expect(stats.sessionCount, 3);
      expect(stats.workoutDays, 2);
      expect(stats.walking, const Duration(minutes: 40));
      expect(stats.running, const Duration(minutes: 16));
      expect(stats.rest, const Duration(minutes: 3));
      expect(stats.active, const Duration(minutes: 56));
      expect(stats.averageActive, const Duration(minutes: 56) ~/ 3);
      expect(stats.sessionsPerDay, {2: 2, 9: 1});
      expect(stats.exerciseKcal, 100);
      expect(stats.sessionsWithEstimate, 1);
    });

    test('a session crossing midnight counts on its start day', () {
      final stats = ProgressCalculator.monthly(DateTime(2026, 11), [
        session('late', DateTime(2026, 11, 30, 23, 50)),
      ]);
      expect(stats.sessionsPerDay, {30: 1});
    });

    test('weekly rows follow a Monday-start grid', () {
      // November 2026 starts on a Sunday → 6 rows.
      final month = DateTime(2026, 11);
      expect(ProgressCalculator.weekRows(month), 6);
      expect(ProgressCalculator.weekRowOf(month, 1), 0);
      expect(ProgressCalculator.weekRowOf(month, 2), 1);
      final stats = ProgressCalculator.monthly(month, [
        session('a', DateTime(2026, 11, 2, 7)),
      ]);
      expect(stats.weeklyActive[1], const Duration(minutes: 18));
    });

    test('empty month', () {
      final stats = ProgressCalculator.monthly(DateTime(2026, 2), const []);
      expect(stats.isEmpty, isTrue);
      expect(stats.averageActive, Duration.zero);
      expect(stats.exerciseKcal, isNull);
    });
  });

  group('streaks', () {
    DateTime d(int y, int m, int day) => DateTime(y, m, day, 7);

    test('current streak survives an incomplete today', () {
      final s = ProgressCalculator.streaks([
        d(2026, 11, 7),
        d(2026, 11, 8),
        d(2026, 11, 8),
      ], DateTime(2026, 11, 9, 6));
      expect(s.current, 2);
      expect(s.best, 2);
    });

    test('streak breaks after a missed day', () {
      final s = ProgressCalculator.streaks([
        d(2026, 11, 1),
        d(2026, 11, 2),
        d(2026, 11, 3),
        d(2026, 11, 6),
      ], DateTime(2026, 11, 9, 6));
      expect(s.current, 0);
      expect(s.best, 3);
    });

    test('streak spans month and year boundaries', () {
      final s = ProgressCalculator.streaks([
        d(2025, 12, 30),
        d(2025, 12, 31),
        d(2026, 1, 1),
        d(2026, 1, 2),
      ], DateTime(2026, 1, 2, 20));
      expect(s.current, 4);
      expect(s.best, 4);
    });

    test('no sessions', () {
      final s = ProgressCalculator.streaks(const [], DateTime(2026, 1, 1));
      expect(s.current, 0);
      expect(s.best, 0);
    });
  });
}
