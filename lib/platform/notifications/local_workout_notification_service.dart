import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'workout_notification_service.dart';

/// flutter_local_notifications adapter.
///
/// Scheduled cues are absolute UTC instants. On Android, exact delivery is
/// used only if the user has allowed "Alarms & reminders"; otherwise the OS
/// may deliver late (inexact). Nothing here keeps the app process alive.
class LocalWorkoutNotificationService implements WorkoutNotificationService {
  LocalWorkoutNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  static const ongoingId = 1;
  static const _cueChannel = AndroidNotificationChannel(
    'workout_cues',
    'Phase changes',
    description: 'Alerts when a walking, running or rest phase begins.',
    importance: Importance.high,
  );
  static const _ongoingChannel = AndroidNotificationChannel(
    'workout_ongoing',
    'Active workout',
    description: 'Shows the current phase while a workout is running.',
    importance: Importance.low,
    playSound: false,
    enableVibration: false,
    showBadge: false,
  );

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      await _android?.createNotificationChannel(_cueChannel);
      await _android?.createNotificationChannel(_ongoingChannel);
      _initialized = true;
    } on PlatformException catch (e) {
      debugPrint('Notifications init failed: ${e.code}');
    }
  }

  @override
  Future<NotificationPermission> permission() async {
    try {
      if (Platform.isAndroid) {
        final enabled = await _android?.areNotificationsEnabled();
        return enabled == true
            ? NotificationPermission.granted
            : NotificationPermission.denied;
      }
      if (Platform.isIOS) {
        final options = await _ios?.checkPermissions();
        if (options == null) return NotificationPermission.unknown;
        return options.isEnabled
            ? NotificationPermission.granted
            : NotificationPermission.denied;
      }
    } on PlatformException catch (e) {
      debugPrint('Notification permission check failed: ${e.code}');
    }
    return NotificationPermission.unknown;
  }

  @override
  Future<NotificationPermission> requestPermission() async {
    await initialize();
    try {
      bool? granted;
      if (Platform.isAndroid) {
        granted = await _android?.requestNotificationsPermission();
      } else if (Platform.isIOS) {
        granted = await _ios?.requestPermissions(alert: true, sound: true);
      }
      return granted == true
          ? NotificationPermission.granted
          : NotificationPermission.denied;
    } on PlatformException catch (e) {
      debugPrint('Notification permission request failed: ${e.code}');
      return NotificationPermission.unknown;
    }
  }

  @override
  Future<bool> canScheduleExact() async {
    if (!Platform.isAndroid) return true;
    try {
      return await _android?.canScheduleExactNotifications() ?? false;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> requestExactPermission() async {
    if (!Platform.isAndroid) return;
    try {
      await _android?.requestExactAlarmsPermission();
    } on PlatformException catch (e) {
      debugPrint('Exact alarm request failed: ${e.code}');
    }
  }

  @override
  Future<void> showOngoing(OngoingWorkoutInfo info) async {
    if (!Platform.isAndroid) return;
    await initialize();
    final countdownTo = info.countdownTo;
    try {
      await _plugin.show(
        id: ongoingId,
        title: info.title,
        body: info.body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _ongoingChannel.id,
            _ongoingChannel.name,
            channelDescription: _ongoingChannel.description,
            importance: Importance.low,
            priority: Priority.low,
            category: AndroidNotificationCategory.workout,
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            playSound: false,
            showWhen: countdownTo != null,
            when: countdownTo?.millisecondsSinceEpoch,
            usesChronometer: countdownTo != null,
            chronometerCountDown: countdownTo != null,
          ),
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Ongoing notification failed: ${e.code}');
    }
  }

  @override
  Future<void> scheduleCues(List<ScheduledCue> cues) async {
    await initialize();
    await _cancelScheduled();
    final exact = await canScheduleExact();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'workout_cues',
        'Phase changes',
        channelDescription:
            'Alerts when a walking, running or rest phase begins.',
        importance: Importance.high,
        priority: Priority.high,
        category: AndroidNotificationCategory.workout,
        timeoutAfter: 60000,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentSound: true,
        presentList: true,
        interruptionLevel: InterruptionLevel.active,
      ),
    );
    for (final cue in cues) {
      try {
        await _plugin.zonedSchedule(
          id: cue.id,
          scheduledDate: tz.TZDateTime.from(cue.at.toUtc(), tz.UTC),
          notificationDetails: details,
          androidScheduleMode: exact
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.inexactAllowWhileIdle,
          title: cue.title,
          body: cue.body,
        );
      } on PlatformException catch (e) {
        debugPrint('Scheduling cue ${cue.id} failed: ${e.code}');
        return;
      }
    }
  }

  Future<void> _cancelScheduled() async {
    try {
      await _plugin.cancelAllPendingNotifications();
    } on PlatformException catch (e) {
      debugPrint('Cancel pending failed: ${e.code}');
    }
  }

  @override
  Future<void> cancelWorkoutNotifications() async {
    if (!_initialized) return;
    try {
      await _plugin.cancelAll();
    } on PlatformException catch (e) {
      debugPrint('Cancel notifications failed: ${e.code}');
    }
  }
}
