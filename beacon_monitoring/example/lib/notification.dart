import 'package:beacon_monitoring_example/notification_types.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static NotificationService? _instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late final NotificationDetails _notificationBatteryDetails;
  late final NotificationDetails _notificationLendingDetails;
  late final NotificationDetails _notificationStartDayDetails;
  final IOSNotificationDetails _iOSPlatformChannelSpecifics = IOSNotificationDetails();

  NotificationDetails getNotificationDetails(NotificationType type) {
    switch (type) {
      case NotificationType.BATTERY:
        return _notificationBatteryDetails;
      case NotificationType.LENDING:
        return _notificationLendingDetails;
      case NotificationType.DAYSTART:
        return _notificationStartDayDetails;
    }
  }

  NotificationService() {
    _notificationBatteryDetails =
        NotificationDetails(android: androidBatteryChannel, iOS: _iOSPlatformChannelSpecifics);
    _notificationLendingDetails =
        NotificationDetails(android: androidLendingChannel, iOS: _iOSPlatformChannelSpecifics);
    _notificationStartDayDetails =
        NotificationDetails(android: androidStartDayChannel, iOS: _iOSPlatformChannelSpecifics);
  }

  static NotificationService getInstance() {
    if (_instance == null) {
      _instance = NotificationService();
    }
    return _instance!;
  }

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) async => print(value));
  }

  Future<void> showNotification(int id, String title, String body, NotificationType type) async {
    await _flutterLocalNotificationsPlugin.show(id, title, body, getNotificationDetails(type));
  }

  Future<void> requestIosPermission() async {
    final bool? result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
