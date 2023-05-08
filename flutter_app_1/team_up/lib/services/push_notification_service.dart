import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static final FirebaseMessaging firebase_messenger =
      FirebaseMessaging.instance;

  final CHANNEL_ID = "Notification";

  static Future initialize() async {
    if (Platform.isIOS) {
      NotificationSettings settings =
          await firebase_messenger.requestPermission();
      print("User granted permission: ${settings.authorizationStatus}");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        print("Received a message: ${message.notification}");
      }
      //NotificationChannel channel =
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (message != null) {
        print(
            "Received a message while running in the background: ${message.notification}");
      }
    });
  }
}
