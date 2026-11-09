import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/application/settings_controller.dart';
import '../features/workout/application/workout_controller.dart';
import 'providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

final _messengerKey = GlobalKey<ScaffoldMessengerState>();

class StrideApp extends ConsumerStatefulWidget {
  const StrideApp({super.key});

  @override
  ConsumerState<StrideApp> createState() => _StrideAppState();
}

class _StrideAppState extends ConsumerState<StrideApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    final workout = ref.read(workoutControllerProvider.notifier);
    _lifecycle = AppLifecycleListener(
      onHide: workout.onBackgrounded,
      onShow: workout.onForegrounded,
    );
    final language = ref.read(settingsControllerProvider).voiceLanguage;
    unawaited(ref.read(speechAnnouncerProvider).initialize(language: language));
    unawaited(ref.read(notificationServiceProvider).initialize());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(
      settingsControllerProvider.select((s) => s.themeMode),
    );
    final router = ref.watch(routerProvider);

    // Navigate to the summary once a workout is durably saved.
    ref.listen(workoutControllerProvider.select((s) => s.completedSessionId), (
      _,
      id,
    ) {
      if (id == null) return;
      router.go('/session/$id?completed=1');
      ref.read(workoutControllerProvider.notifier).acknowledgeCompletion();
    });

    // Surface errors that happen outside the workout screen.
    ref.listen(workoutControllerProvider.select((s) => s.failure), (_, f) {
      if (f == null || ref.read(workoutControllerProvider).active != null) {
        return;
      }
      _messengerKey.currentState?.showSnackBar(
        SnackBar(content: Text(f.message)),
      );
      ref.read(workoutControllerProvider.notifier).clearFailure();
    });

    return MaterialApp.router(
      title: 'Stride',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
