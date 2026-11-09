import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors/app_failure.dart';
import '../domain/app_settings.dart';

final settingsControllerProvider =
    NotifierProvider<SettingsController, AppSettings>(SettingsController.new);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  /// Applies [change] immediately and persists it. Throws
  /// [PersistenceFailure] if the preference could not be written; the
  /// in-memory value is reverted in that case.
  Future<void> update(AppSettings Function(AppSettings current) change) async {
    final previous = state;
    final next = change(previous);
    state = next;
    try {
      await ref.read(settingsRepositoryProvider).save(next);
    } on PlatformException catch (e) {
      if (ref.mounted) state = previous;
      throw PersistenceFailure('Could not save the setting', cause: e);
    }
    if (previous.voiceLanguage != next.voiceLanguage) {
      await ref.read(speechAnnouncerProvider).setLanguage(next.voiceLanguage);
    }
  }
}
