import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:stride/app/providers.dart';
import 'package:stride/features/settings/data/settings_repository.dart';
import 'package:stride/features/workout/domain/services/announcement_planner.dart';
import 'package:stride/platform/audio/speech_announcer.dart';
import 'package:stride/platform/device/device_feedback.dart';
import 'package:stride/platform/notifications/workout_notification_service.dart';
import 'package:stride/platform/storage/app_database.dart';

import 'fake_clock.dart';

class RecordingAnnouncer extends SilentSpeechAnnouncer {
  RecordingAnnouncer({this.fail = false});

  final bool fail;

  List<String> get texts => [for (final a in spoken) a.text];

  @override
  Future<bool> announce(Announcement announcement) async {
    spoken.add(announcement);
    if (fail) throw StateError('TTS engine crashed');
    return true;
  }

  @override
  SpeechStatus get status =>
      fail ? SpeechStatus.unavailable : SpeechStatus.available;
}

class FakeNotifications extends NoopNotificationService {
  FakeNotifications({this.granted = true});

  final bool granted;

  @override
  Future<NotificationPermission> permission() async =>
      granted ? NotificationPermission.granted : NotificationPermission.denied;
}

class RecordingHaptics implements Haptics {
  int count = 0;

  @override
  Future<void> phaseChanged() async => count++;
}

/// Shared test dependencies. A fresh in-memory database per harness unless
/// one is passed in (to simulate an app restart over the same storage).
class Harness {
  Harness({
    AppDatabase? db,
    FakeClock? clock,
    RecordingAnnouncer? announcer,
    FakeNotifications? notifications,
  }) : db = db ?? _memoryDb(),
       clock = clock ?? FakeClock(),
       announcer = announcer ?? RecordingAnnouncer(),
       notifications = notifications ?? FakeNotifications();

  static AppDatabase _memoryDb() {
    // Each test intentionally creates its own in-memory database.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    return AppDatabase(NativeDatabase.memory());
  }

  final AppDatabase db;
  final FakeClock clock;
  final RecordingAnnouncer announcer;
  final FakeNotifications notifications;
  final haptics = RecordingHaptics();
  late SharedPreferencesWithCache prefs;

  static Future<SharedPreferencesWithCache> freshPrefs({
    Map<String, Object> initial = const {},
  }) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(initial);
    return SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: SettingsRepository.allKeys,
      ),
    );
  }

  Future<void> init({bool onboarded = true}) async {
    prefs = await freshPrefs(
      initial: {
        'onboarding_completed': onboarded,
        'notification_prompt_shown': true,
      },
    );
  }

  List<Override> get overrides => [
    clockProvider.overrideWithValue(clock),
    databaseProvider.overrideWithValue(db),
    sharedPreferencesProvider.overrideWithValue(prefs),
    speechAnnouncerProvider.overrideWithValue(announcer),
    notificationServiceProvider.overrideWithValue(notifications),
    hapticsProvider.overrideWithValue(haptics),
    screenWakeProvider.overrideWithValue(const NoopScreenWake()),
  ];

  ProviderContainer container() =>
      ProviderContainer(overrides: overrides, retry: (_, _) => null);
}
