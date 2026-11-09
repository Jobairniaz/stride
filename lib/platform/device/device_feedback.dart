import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Phase-transition haptics (foreground only).
abstract interface class Haptics {
  Future<void> phaseChanged();
}

class SystemHaptics implements Haptics {
  const SystemHaptics();

  @override
  Future<void> phaseChanged() => HapticFeedback.heavyImpact();
}

/// Keeps the display on while the active-workout screen is visible. This is
/// a display preference only, not background execution.
abstract interface class ScreenWake {
  Future<void> setEnabled(bool enabled);
}

class WakelockScreenWake implements ScreenWake {
  const WakelockScreenWake();

  @override
  Future<void> setEnabled(bool enabled) async {
    try {
      await WakelockPlus.toggle(enable: enabled);
    } on PlatformException catch (e) {
      debugPrint('Wakelock failed: ${e.code}');
    } on MissingPluginException {
      // Unsupported platform (tests).
    }
  }
}

class NoopHaptics implements Haptics {
  const NoopHaptics();
  @override
  Future<void> phaseChanged() async {}
}

class NoopScreenWake implements ScreenWake {
  const NoopScreenWake();
  @override
  Future<void> setEnabled(bool enabled) async {}
}
