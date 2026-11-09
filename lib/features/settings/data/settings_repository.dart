import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';

import '../../workout/domain/entities/workout_plan.dart';
import '../domain/app_settings.dart';

/// Reads/writes [AppSettings] in SharedPreferences. Invalid stored values
/// fall back to defaults rather than crashing.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static const _walk = 'walking_duration_ms';
  static const _run = 'running_duration_ms';
  static const _break = 'default_break_duration_ms';
  static const _rounds = 'target_rounds';
  static const _voice = 'voice_enabled';
  static const _ten = 'announce_at_10_seconds';
  static const _countdown = 'announce_3_2_1';
  static const _haptics = 'haptics_enabled';
  static const _awake = 'keep_screen_awake';
  static const _theme = 'theme_mode';
  static const _language = 'voice_language';
  static const _calories = 'calorie_estimates_enabled';
  static const _onboarding = 'onboarding_completed';
  static const _notifPrompt = 'notification_prompt_shown';

  static const allKeys = {
    _walk,
    _run,
    _break,
    _rounds,
    _voice,
    _ten,
    _countdown,
    _haptics,
    _awake,
    _theme,
    _language,
    _calories,
    _onboarding,
    _notifPrompt,
  };

  Duration _duration(String key, Duration fallback) {
    final ms = _prefs.getInt(key);
    if (ms == null) return fallback;
    final d = Duration(milliseconds: ms);
    return WorkoutPlan.validatePhaseDuration(d) == null ? d : fallback;
  }

  AppSettings load() {
    const defaults = AppSettings();
    final rounds = _prefs.getInt(_rounds);
    return AppSettings(
      walkDuration: _duration(_walk, defaults.walkDuration),
      runDuration: _duration(_run, defaults.runDuration),
      breakDuration: _duration(_break, defaults.breakDuration),
      targetRounds: WorkoutPlan.validateRounds(rounds) == null ? rounds : null,
      voiceEnabled: _prefs.getBool(_voice) ?? defaults.voiceEnabled,
      announceTenSeconds: _prefs.getBool(_ten) ?? defaults.announceTenSeconds,
      announceCountdown:
          _prefs.getBool(_countdown) ?? defaults.announceCountdown,
      hapticsEnabled: _prefs.getBool(_haptics) ?? defaults.hapticsEnabled,
      keepScreenAwake: _prefs.getBool(_awake) ?? defaults.keepScreenAwake,
      themeMode:
          ThemeMode.values.asNameMap()[_prefs.getString(_theme)] ??
          defaults.themeMode,
      voiceLanguage: _prefs.getString(_language),
      calorieEstimatesEnabled:
          _prefs.getBool(_calories) ?? defaults.calorieEstimatesEnabled,
      onboardingCompleted:
          _prefs.getBool(_onboarding) ?? defaults.onboardingCompleted,
      notificationPromptShown:
          _prefs.getBool(_notifPrompt) ?? defaults.notificationPromptShown,
    );
  }

  Future<void> save(AppSettings s) async {
    await Future.wait([
      _prefs.setInt(_walk, s.walkDuration.inMilliseconds),
      _prefs.setInt(_run, s.runDuration.inMilliseconds),
      _prefs.setInt(_break, s.breakDuration.inMilliseconds),
      if (s.targetRounds == null)
        _prefs.remove(_rounds)
      else
        _prefs.setInt(_rounds, s.targetRounds!),
      _prefs.setBool(_voice, s.voiceEnabled),
      _prefs.setBool(_ten, s.announceTenSeconds),
      _prefs.setBool(_countdown, s.announceCountdown),
      _prefs.setBool(_haptics, s.hapticsEnabled),
      _prefs.setBool(_awake, s.keepScreenAwake),
      _prefs.setString(_theme, s.themeMode.name),
      if (s.voiceLanguage == null)
        _prefs.remove(_language)
      else
        _prefs.setString(_language, s.voiceLanguage!),
      _prefs.setBool(_calories, s.calorieEstimatesEnabled),
      _prefs.setBool(_onboarding, s.onboardingCompleted),
      _prefs.setBool(_notifPrompt, s.notificationPromptShown),
    ]);
  }
}
