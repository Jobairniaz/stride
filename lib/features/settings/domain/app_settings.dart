import 'package:flutter/material.dart' show ThemeMode;

import '../../workout/domain/entities/workout_plan.dart';
import '../../workout/domain/services/announcement_planner.dart';

/// Small, non-relational preferences (stored in SharedPreferences).
class AppSettings {
  const AppSettings({
    this.walkDuration = WorkoutPlan.defaultWalkDuration,
    this.runDuration = WorkoutPlan.defaultRunDuration,
    this.breakDuration = WorkoutPlan.defaultBreakDuration,
    this.targetRounds,
    this.voiceEnabled = true,
    this.announceTenSeconds = true,
    this.announceCountdown = true,
    this.hapticsEnabled = true,
    this.keepScreenAwake = true,
    this.themeMode = ThemeMode.system,
    this.voiceLanguage,
    this.calorieEstimatesEnabled = true,
    this.onboardingCompleted = false,
    this.notificationPromptShown = false,
  });

  final Duration walkDuration;
  final Duration runDuration;
  final Duration breakDuration;
  final int? targetRounds;
  final bool voiceEnabled;
  final bool announceTenSeconds;
  final bool announceCountdown;
  final bool hapticsEnabled;
  final bool keepScreenAwake;
  final ThemeMode themeMode;

  /// BCP-47 tag understood by the device TTS engine; `null` = device default.
  final String? voiceLanguage;
  final bool calorieEstimatesEnabled;
  final bool onboardingCompleted;
  final bool notificationPromptShown;

  WorkoutPlan get plan => WorkoutPlan(
    walkDuration: walkDuration,
    runDuration: runDuration,
    targetRounds: targetRounds,
  );

  CuePreferences get cuePreferences => CuePreferences(
    tenSecondWarning: announceTenSeconds,
    countdown321: announceCountdown,
  );

  AppSettings copyWith({
    Duration? walkDuration,
    Duration? runDuration,
    Duration? breakDuration,
    int? Function()? targetRounds,
    bool? voiceEnabled,
    bool? announceTenSeconds,
    bool? announceCountdown,
    bool? hapticsEnabled,
    bool? keepScreenAwake,
    ThemeMode? themeMode,
    String? Function()? voiceLanguage,
    bool? calorieEstimatesEnabled,
    bool? onboardingCompleted,
    bool? notificationPromptShown,
  }) => AppSettings(
    walkDuration: walkDuration ?? this.walkDuration,
    runDuration: runDuration ?? this.runDuration,
    breakDuration: breakDuration ?? this.breakDuration,
    targetRounds: targetRounds != null ? targetRounds() : this.targetRounds,
    voiceEnabled: voiceEnabled ?? this.voiceEnabled,
    announceTenSeconds: announceTenSeconds ?? this.announceTenSeconds,
    announceCountdown: announceCountdown ?? this.announceCountdown,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    keepScreenAwake: keepScreenAwake ?? this.keepScreenAwake,
    themeMode: themeMode ?? this.themeMode,
    voiceLanguage: voiceLanguage != null ? voiceLanguage() : this.voiceLanguage,
    calorieEstimatesEnabled:
        calorieEstimatesEnabled ?? this.calorieEstimatesEnabled,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    notificationPromptShown:
        notificationPromptShown ?? this.notificationPromptShown,
  );
}
