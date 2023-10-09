import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_logs/flutter_logs.dart';
//import 'package:ringtone_manager/ringtone_manager.dart';

class PushNotificationService {
  // static final FirebaseMessaging firebase_messenger =
  //     FirebaseMessaging.instance;

  final CHANNEL_ID = "Notification";

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    //FlutterLogs.logInfo("Push Notification Service", "On Message Background",
    //"Received Message: ${message.notification?.body}");
    sendNotification(message);
  }

  static Future initialize() async {
    //FlutterLogs.logInfo(
    // "Push Notification Service", "Init", "In init function");

    // if (Platform.isIOS) {
    //   NotificationSettings settings =
    //       await firebase_messenger.requestPermission();
    //   print("User granted permission: ${settings.authorizationStatus}");
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //FlutterLogs.logInfo("Push Notification Service", "On Message Listening",
      // "Received Message: ${message.notification?.body}");
      sendNotification(message);
      //NotificationChannel channel =
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //FlutterLogs.logInfo("Push Notification Service", "Init", "Finished init");
  }

  static Future<void> sendNotification(RemoteMessage notification) async {
    if (!Platform.isAndroid) {
      print("Platform not Android! No notification service");
      return;
    }

    // const AndroidIntent intent = AndroidIntent(
    //     action: 'com.example.team_up.lib.services.push_notification_service',
    //     data: 'com.example.team_up.lib.main' // program file of the app main
    //     );

    // final PendingIntent pendingIntent = await PendingIntent.getActivity(
    //   context,
    //   0,
    //   intent,
    //   PendingIntent.FLAG_IMMUTABLE,
    // );

    //FlutterLogs.logInfo("Push Notification Service", "Send Notification",
    //"Sending Notification");

    final String channelId = "notif"; //notification.data["channelId"];
    // final Uri defaultSoundUri = RingtoneManager.getDefaultUri(
    //   RingtoneManager.TYPE_NOTIFICATION,
    // );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        "Notification Channel",
        //"Channel description",
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        //sound: const RawResourceAndroidNotificationSound("notification"),
        playSound: true,
      ),
    );

    //FlutterLogs.logInfo("Push Notification Service", "Send Notification",
    //"Created Notification Details");

    await FlutterLocalNotificationsPlugin().show(
      0,
      notification.notification?.title,
      notification.notification?.body,
      notificationDetails,
      //payload: notification.data["payload"],
    );

    //FlutterLogs.logInfo(
    // "Push Notification Service", "Send Notification", "Sent");
  }
}
