import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../platform/notifications/workout_notification_service.dart';

class AlertStatus {
  const AlertStatus({required this.permission, required this.exactAllowed});

  final NotificationPermission permission;

  /// Android exact alarms ("Alarms & reminders"); always true elsewhere.
  final bool exactAllowed;
}

/// Re-read on demand (e.g. after returning from system settings).
final alertStatusProvider = FutureProvider.autoDispose<AlertStatus>((
  ref,
) async {
  final service = ref.watch(notificationServiceProvider);
  await service.initialize();
  return AlertStatus(
    permission: await service.permission(),
    exactAllowed: await service.canScheduleExact(),
  );
});
