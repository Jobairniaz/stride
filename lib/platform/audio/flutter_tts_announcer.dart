import 'dart:async';
import 'dart:io' show Platform;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/clock/clock.dart';
import '../../features/workout/domain/services/announcement_planner.dart';
import 'speech_announcer.dart';

/// TTS adapter.
///
/// Ducking: on Android each utterance requests transient may-duck audio
/// focus (`speak(focus: true)`) and releases it on completion; on iOS the
/// shared AVAudioSession uses `playback` + `duckOthers` and is deactivated
/// after each utterance so other audio un-ducks. Other apps decide whether
/// they duck, pause or ignore the request.
///
/// Interruptions (calls, alarms) suppress cues until they end; a headphone
/// disconnect stops the current utterance so it does not continue on the
/// phone speaker. iOS does not guarantee an "interruption ended" event, so
/// returning to the app also clears the flag; otherwise one missed event would
/// mute every later cue.
class FlutterTtsAnnouncer implements SpeechAnnouncer {
  FlutterTtsAnnouncer(this._clock, {FlutterTts? tts})
    : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  final Clock _clock;

  /// Cues older than this when their turn comes are dropped, so a slow engine
  /// never produces a late burst.
  static const maxQueueDelay = Duration(seconds: 2);
  static const _utteranceTimeout = Duration(seconds: 8);

  SpeechStatus _status = SpeechStatus.unknown;
  bool _interrupted = false;
  Future<void> _queue = Future.value();
  final _subscriptions = <StreamSubscription<Object?>>[];
  AppLifecycleListener? _lifecycle;

  @override
  SpeechStatus get status => _status;

  Future<void>? _ready;

  /// Safe to call repeatedly; the first call wins.
  @override
  Future<void> initialize({String? language}) =>
      _ready ??= _initialize(language);

  Future<void> _initialize(String? language) async {
    try {
      await _tts.awaitSpeakCompletion(true);
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.autoStopSharedSession(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.duckOthers,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      } else if (Platform.isAndroid) {
        await _tts.setAudioAttributesForNavigation();
      }
      await setLanguage(language);
      _status = SpeechStatus.available;
    } on PlatformException catch (e) {
      _status = SpeechStatus.unavailable;
      debugPrint('TTS init failed: ${e.code}');
    } on MissingPluginException {
      _status = SpeechStatus.unavailable;
    }

    _lifecycle = AppLifecycleListener(onResume: () => _interrupted = false);

    try {
      final session = await AudioSession.instance;
      _subscriptions
        ..add(
          session.interruptionEventStream.listen((event) {
            _interrupted = event.begin;
            if (event.begin) unawaited(stop());
          }),
        )
        ..add(session.becomingNoisyEventStream.listen((_) => stop()));
    } on PlatformException catch (e) {
      debugPrint('Audio session events unavailable: ${e.code}');
    } on MissingPluginException {
      // Unsupported platform (tests).
    }
  }

  @override
  Future<bool> announce(Announcement announcement) {
    final completer = Completer<bool>();
    _queue = _queue.then((_) async {
      final late = _clock.now().difference(announcement.dueAt);
      if (_interrupted || late > maxQueueDelay) {
        completer.complete(false);
        return;
      }
      completer.complete(await _speak(announcement.text));
    });
    return completer.future;
  }

  @override
  Future<bool> speakTest(String text) => _speak(text);

  Future<bool> _speak(String text) async {
    await initialize();
    if (_status == SpeechStatus.unavailable) return false;
    try {
      final result = await _tts
          .speak(text, focus: true)
          .timeout(_utteranceTimeout, onTimeout: () => 0);
      final ok = result == 1;
      if (ok) _status = SpeechStatus.available;
      return ok;
    } on PlatformException catch (e) {
      debugPrint('TTS speak failed: ${e.code}');
      return false;
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
    } on PlatformException catch (e) {
      debugPrint('TTS stop failed: ${e.code}');
    }
  }

  @override
  Future<List<String>> availableLanguages() async {
    try {
      final langs = await _tts.getLanguages;
      if (langs is List) {
        return langs.map((e) => e.toString()).toSet().toList()..sort();
      }
    } on PlatformException catch (e) {
      debugPrint('TTS languages unavailable: ${e.code}');
    }
    return const [];
  }

  @override
  Future<void> setLanguage(String? languageTag) async {
    if (languageTag == null) return;
    try {
      await _tts.setLanguage(languageTag);
    } on PlatformException catch (e) {
      debugPrint('TTS setLanguage failed: ${e.code}');
    }
  }

  void dispose() {
    _lifecycle?.dispose();
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
  }
}
