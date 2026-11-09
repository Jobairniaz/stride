import 'package:flutter_test/flutter_test.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/entities/workout_snapshot.dart';
import 'package:stride/features/workout/domain/services/announcement_planner.dart';
import 'package:stride/features/workout/domain/services/workout_engine.dart';

const engine = WorkoutEngine();
const planner = AnnouncementPlanner();
const allCues = CuePreferences(tenSecondWarning: true, countdown321: true);
final t0 = DateTime.utc(2026, 11, 9, 6);
Duration s(int n) => Duration(seconds: n);
Duration ms(int n) => Duration(milliseconds: n);

/// Simulates a foreground ticker: reconcile every [step] and collect cues.
List<Announcement> runTicker(
  WorkoutSnapshot start,
  Duration until, {
  Duration step = const Duration(milliseconds: 200),
  CuePreferences prefs = allCues,
}) {
  final spoken = <Announcement>[];
  final ids = <String>{};
  var snap = start;
  var last = t0;
  for (var t = t0.add(step); !t.isAfter(t0.add(until)); t = t.add(step)) {
    final r = engine.reconcile(snap, t);
    final cues = planner.dueCues(
      windowStart: last,
      now: t,
      transitions: r.transitions,
      snapshot: r.snapshot,
      preferences: prefs,
    );
    for (final c in cues) {
      if (ids.add(c.id)) spoken.add(c);
    }
    last = t;
    if (r.isFinished) break;
    snap = r.snapshot!;
  }
  return spoken;
}

void main() {
  final plan = const WorkoutPlan(
    walkDuration: Duration(seconds: 30),
    runDuration: Duration(seconds: 20),
    targetRounds: 1,
  );

  test('foreground cues fire once each, in order', () {
    final snap = engine.start(plan: plan, sessionId: 'S', now: t0);
    final texts = runTicker(snap, s(60)).map((a) => a.text).toList();
    expect(texts, [
      '10 seconds. Running next',
      '3',
      '2',
      '1',
      'Start running',
      '10 seconds left',
      '3',
      '2',
      '1',
      'Workout completed',
    ]);
  });

  test('countdown cues can be disabled', () {
    final snap = engine.start(plan: plan, sessionId: 'S', now: t0);
    final texts = runTicker(
      snap,
      s(60),
      prefs: const CuePreferences(tenSecondWarning: false, countdown321: false),
    ).map((a) => a.text);
    expect(texts, ['Start running', 'Workout completed']);
  });

  test('no stale burst after a long suspension: one catch-up cue', () {
    final snap = engine.start(
      plan: const WorkoutPlan(),
      sessionId: 'S',
      now: t0,
    );
    // App suspended from t0 to t0+7m05s (3 boundaries missed).
    final now = t0.add(const Duration(minutes: 7, seconds: 5));
    final r = engine.reconcile(snap, now);
    final cues = planner.dueCues(
      windowStart: t0,
      now: now,
      transitions: r.transitions,
      snapshot: r.snapshot,
      preferences: allCues,
    );
    expect(cues, hasLength(1));
    expect(cues.single.kind, CueKind.catchUp);
    expect(cues.single.text, 'Running. 55 seconds left');
  });

  test('cue ids are deterministic per phase so duplicates can be dropped', () {
    final snap = engine.start(plan: plan, sessionId: 'S', now: t0);
    List<Announcement> at(DateTime windowStart, DateTime now) {
      final r = engine.reconcile(snap, now);
      return planner.dueCues(
        windowStart: windowStart,
        now: now,
        transitions: r.transitions,
        snapshot: r.snapshot,
        preferences: allCues,
      );
    }

    // Duplicate lifecycle callbacks evaluating the same window.
    final a = at(t0.add(s(19)), t0.add(s(20)));
    final b = at(t0.add(s(19)), t0.add(s(20)));
    expect(a.map((c) => c.id), b.map((c) => c.id));
    expect(a.single.kind, CueKind.tenSeconds);
  });

  test('resume after a break is announced as resume', () {
    var snap = engine.start(plan: plan, sessionId: 'S', now: t0);
    snap = engine.insertBreak(snap, s(10), t0.add(s(5))).snapshot!;
    final r = engine.reconcile(snap, t0.add(s(15)));
    final cues = planner.dueCues(
      windowStart: t0.add(s(15) - ms(200)),
      now: t0.add(s(15)),
      transitions: r.transitions,
      snapshot: r.snapshot,
      preferences: allCues,
    );
    expect(cues.first.text, 'Resume walking');
  });
}
