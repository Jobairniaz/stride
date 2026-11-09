import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/clock/clock.dart';
import '../features/profile/data/drift_profile_repository.dart';
import '../features/profile/domain/fitness_profile.dart';
import '../features/settings/data/settings_repository.dart';
import '../features/workout/data/drift_workout_repository.dart';
import '../features/workout/domain/repositories/workout_repository.dart';
import '../platform/audio/flutter_tts_announcer.dart';
import '../platform/audio/speech_announcer.dart';
import '../platform/device/device_feedback.dart';
import '../platform/notifications/local_workout_notification_service.dart';
import '../platform/notifications/workout_notification_service.dart';
import '../platform/storage/app_database.dart';

/// Infrastructure providers. Tests override these with fakes.

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Overridden in `main()` with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferencesWithCache>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => DriftWorkoutRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => DriftProfileRepository(
    ref.watch(databaseProvider),
    ref.watch(clockProvider),
  ),
);

final speechAnnouncerProvider = Provider<SpeechAnnouncer>((ref) {
  final announcer = FlutterTtsAnnouncer(ref.watch(clockProvider));
  ref.onDispose(announcer.dispose);
  return announcer;
});

final notificationServiceProvider = Provider<WorkoutNotificationService>(
  (ref) => LocalWorkoutNotificationService(),
);

final hapticsProvider = Provider<Haptics>((ref) => const SystemHaptics());

final screenWakeProvider = Provider<ScreenWake>(
  (ref) => const WakelockScreenWake(),
);
