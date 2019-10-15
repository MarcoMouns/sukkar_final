import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotifications {
  FlutterLocalNotificationsPlugin _appNotifications;

  AppNotifications() {
    _initNotifications();
  }

  void _initNotifications() {
    _appNotifications = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings("@mipmap/ic_logo");
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    _appNotifications.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    print(payload);
  }

  Future showWeeklyNotification(
      Time time, Day day, String title, description) {}

      
  void showNotification(String title, body) async {
    var andriod = new AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();

    var platform = new NotificationDetails(andriod, iOS);
    await _appNotifications.show(0, title, body, platform,
        payload: "wawwawawaw");
  }
}
