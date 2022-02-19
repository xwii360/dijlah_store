import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  static void initialize() {

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false);

    /// Note: permissions aren't requested here just to demonstrate that can be
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
        );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "dijlahstore", "dijlahstore channel",
              playSound: true,
              priority: Priority.high,
              importance: Importance.high),
      iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
      ));
      await flutterLocalNotificationsPlugin.show(id, message.notification.title,
          message.notification.body, notificationDetails);
    } on Exception catch (e) {
     print(e);
    }
  }
}
