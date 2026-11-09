import '../../features/workout/domain/services/announcement_planner.dart';

enum SpeechStatus { unknown, available, unavailable }

/// Speaks workout cues. Implementations must never throw from [announce] and
/// must never be awaited by timer logic: workout timing does not depend on
/// speech completing.
abstract interface class SpeechAnnouncer {
  Future<void> initialize({String? language});

  /// Queues [announcement]. Returns `false` if it was dropped or failed.
  Future<bool> announce(Announcement announcement);

  /// Speaks arbitrary text immediately (used by the settings voice test).
  Future<bool> speakTest(String text);

  Future<void> stop();

  Future<List<String>> availableLanguages();

  Future<void> setLanguage(String? languageTag);

  SpeechStatus get status;
}

/// Used in tests and when voice is unavailable.
class SilentSpeechAnnouncer implements SpeechAnnouncer {
  final List<Announcement> spoken = [];

  @override
  Future<void> initialize({String? language}) async {}

  @override
  Future<bool> announce(Announcement announcement) async {
    spoken.add(announcement);
    return true;
  }

  @override
  Future<bool> speakTest(String text) async => true;

  @override
  Future<void> stop() async {}

  @override
  Future<List<String>> availableLanguages() async => const [];

  @override
  Future<void> setLanguage(String? languageTag) async {}

  @override
  SpeechStatus get status => SpeechStatus.available;
}
