import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stride/app/app.dart';
import 'package:stride/features/workout/data/drift_workout_repository.dart';
import 'package:stride/features/workout/domain/entities/workout_plan.dart';
import 'package:stride/features/workout/domain/services/workout_engine.dart';
import 'package:stride/features/workout/presentation/widgets/duration_picker_sheet.dart';

import '../helpers/test_harness.dart';

/// Pumps the real app with in-memory storage and fake platform services.
Future<Harness> pumpApp(
  WidgetTester tester, {
  Harness? harness,
  bool onboarded = true,
  double textScale = 1,
}) async {
  final h = harness ?? Harness();
  await tester.runAsync(() => h.init(onboarded: onboarded));
  await tester.pumpWidget(
    ProviderScope(
      overrides: h.overrides,
      retry: (_, _) => null,
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: const StrideApp(),
      ),
    ),
  );
  await settle(tester);
  return h;
}

/// Lets database work (real async) and frames complete.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
  // Let route transitions finish so covered screens go offstage.
  await tester.pump(const Duration(milliseconds: 600));
}

Future<void> tearDownApp(WidgetTester tester, Harness h) async {
  await tester.pumpWidget(const SizedBox());
  // Drift releases stream queries on a zero-duration timer in the fake
  // zone; let it fire, then close the database inside the fake zone too.
  await tester.pump(const Duration(seconds: 1));
  final closing = h.db.close();
  await tester.pump(const Duration(seconds: 1));
  await tester.runAsync(() => closing);
}

void main() {
  testWidgets('home shows plan defaults and starts a workout', (tester) async {
    final h = await pumpApp(tester);
    expect(find.text('2 min'), findsNWidgets(2));
    expect(find.text('Until I stop'), findsOneWidget);

    await tester.tap(find.byKey(const Key('start-workout')));
    await settle(tester);

    expect(find.text('Walking'), findsOneWidget);
    expect(find.text('2:00'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget); // next-phase preview
    expect(h.announcer.texts, ['Start walking']);
    await tearDownApp(tester, h);
  });

  testWidgets('pause, resume, break and end-discard flow', (tester) async {
    final h = await pumpApp(tester);
    await tester.tap(find.byKey(const Key('start-workout')));
    await settle(tester);

    h.clock.advance(const Duration(seconds: 15));
    await tester.tap(find.byKey(const Key('pause-resume')));
    await settle(tester);
    expect(find.text('Paused'), findsOneWidget);
    expect(find.text('1:45'), findsOneWidget);
    expect(
      tester
          .widget<ButtonStyleButton>(
            find.descendant(
              of: find.byKey(const Key('skip-phase')),
              matching: find.byType(OutlinedButton),
            ),
          )
          .onPressed,
      isNull,
      reason: 'skip is disabled while paused',
    );

    await tester.tap(find.byKey(const Key('pause-resume')));
    await settle(tester);
    expect(find.text('Pause'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add-break')));
    await settle(tester);
    expect(find.text('Take a break'), findsOneWidget);
    await tester.tap(find.text('Start break'));
    await settle(tester);
    expect(find.text('Break'), findsWidgets);
    expect(find.text('1:00'), findsOneWidget);

    await tester.tap(find.byKey(const Key('end-workout')));
    await settle(tester);
    expect(find.text('End workout?'), findsOneWidget);
    await tester.tap(find.byKey(const Key('discard-workout')));
    await settle(tester);
    expect(find.byKey(const Key('start-workout')), findsOneWidget);
    await tearDownApp(tester, h);
  });

  testWidgets('end-and-save shows the completion summary', (tester) async {
    final h = await pumpApp(tester);
    await tester.tap(find.byKey(const Key('start-workout')));
    await settle(tester);
    h.clock.advance(const Duration(seconds: 150));
    await settle(tester);

    await tester.tap(find.byKey(const Key('end-workout')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('save-workout')));
    await settle(tester);

    expect(find.text('Workout complete'), findsOneWidget);
    // Active time and total-incl.-pauses are both 2:30 (no pauses).
    expect(find.text('2:30'), findsNWidgets(2));
    expect(find.text('Phase timeline'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('Today: 1 workout'), findsOneWidget);
    await tearDownApp(tester, h);
  });

  testWidgets('recovery prompt after restart', (tester) async {
    final h = Harness();
    // An unfinished workout left behind by a previous process.
    final snapshot = const WorkoutEngine().start(
      plan: const WorkoutPlan(),
      sessionId: 'old',
      now: h.clock.now().subtract(const Duration(minutes: 3)),
    );
    await tester.runAsync(
      () => DriftWorkoutRepository(h.db, h.clock).saveActiveSnapshot(snapshot),
    );

    await pumpApp(tester, harness: h);
    expect(find.text('Unfinished workout'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('start-workout')),
      200,
    );
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Discard'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('start-workout')))
          .onPressed,
      isNull,
      reason: 'cannot start while an unfinished workout awaits a choice',
    );
    await tearDownApp(tester, h);
  });

  testWidgets('progress shows an empty state', (tester) async {
    final h = await pumpApp(tester);
    await tester.tap(find.text('Progress'));
    await settle(tester);
    expect(find.text('No workouts in November'), findsOneWidget);
    expect(find.text('Start a workout'), findsOneWidget);
    await tearDownApp(tester, h);
  });

  testWidgets('onboarding can be skipped', (tester) async {
    final h = await pumpApp(tester, onboarded: false);
    expect(find.text('Welcome to Stride'), findsOneWidget);
    await tester.tap(find.byKey(const Key('skip-onboarding')));
    await settle(tester);
    expect(find.byKey(const Key('start-workout')), findsOneWidget);
    await tearDownApp(tester, h);
  });

  testWidgets('home and workout screens survive 2x text scaling', (
    tester,
  ) async {
    final h = await pumpApp(tester, textScale: 2);
    expect(tester.takeException(), isNull);
    final semantics = tester.ensureSemantics();
    expect(find.bySemanticsLabel('Start workout'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('start-workout')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('start-workout')));
    await settle(tester);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    await tearDownApp(tester, h);
  });

  testWidgets('duration editor validates custom input', (tester) async {
    Duration? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showDurationPicker(
              context,
              title: 'Walking duration',
              initial: const Duration(minutes: 2),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('duration-minutes')), '0');
    await tester.enterText(find.byKey(const Key('duration-seconds')), '3');
    await tester.pump();
    expect(find.text('Minimum is 5 seconds'), findsOneWidget);
    final save = find.widgetWithText(FilledButton, 'Save');
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(find.byKey(const Key('duration-seconds')), '75');
    await tester.pump();
    expect(find.text('Seconds must be 0–59'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('duration-minutes')), '3');
    await tester.enterText(find.byKey(const Key('duration-seconds')), '30');
    await tester.pump();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(result, const Duration(minutes: 3, seconds: 30));
  });

  test('parseMinutesSeconds enforces 5 s – 180 min', () {
    expect(parseMinutesSeconds('0', '4').$2, isNotNull);
    expect(parseMinutesSeconds('181', '0').$2, isNotNull);
    expect(parseMinutesSeconds('180', '0').$1, const Duration(minutes: 180));
    expect(parseMinutesSeconds('', '30').$1, const Duration(seconds: 30));
  });
}
