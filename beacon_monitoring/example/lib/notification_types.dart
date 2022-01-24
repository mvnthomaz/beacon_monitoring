import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum NotificationType { BATTERY, LENDING, DAYSTART }

NotificationType getNotificationType(String? type) {
  switch (type) {
    case "lending":
      return NotificationType.LENDING;
    case "day_start":
      return NotificationType.DAYSTART;
    case 'battery':
    default:
      return NotificationType.BATTERY;
  }
}

final AndroidNotificationDetails androidBatteryChannel = AndroidNotificationDetails(
  "battery_channel",
  "Battery",
  channelDescription: "Battery notifications",
  importance: Importance.high,
  priority: Priority.high,
);

final AndroidNotificationDetails androidLendingChannel = AndroidNotificationDetails(
  "lending_channel",
  "Lending",
  channelDescription: "Lending notifications",
  importance: Importance.high,
  priority: Priority.high,
);

final AndroidNotificationDetails androidStartDayChannel = AndroidNotificationDetails(
  "day_start_channel",
  "Start Day",
  channelDescription: "Start Day notifications",
  importance: Importance.high,
  priority: Priority.high,
);
