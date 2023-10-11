import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification{
  LocalNotification._();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false
        );
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  static Future<void> notify({required int id, required String title, required String body}) async {
    const AndroidNotificationDetails detailsAndroid =
        AndroidNotificationDetails('notification', 'notification',
        channelDescription: 'Alarm notification',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails detail = NotificationDetails(android:detailsAndroid);
    await flutterLocalNotificationsPlugin.show(id, title, body, detail, payload: id.toString());
  }
}