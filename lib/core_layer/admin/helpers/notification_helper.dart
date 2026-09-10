import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'cache_helper.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          saveToFirestore: true,
        );
      }
    });
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    bool saveToFirestore = false,
    String? type,
    String? targetId,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      platformChannelSpecifics,
    );

    if (saveToFirestore) {
      await _saveNotificationToFirestore(title, body, type, targetId);
    }
  }

  static Future<void> _saveNotificationToFirestore(
    String title,
    String body,
    String? type,
    String? targetId,
  ) async {
    try {
      String? uId = CacheHelper.getData(key: 'uId');
      if (uId == null) return;

      await FirebaseFirestore.instance
          .collection('admin')
          .doc(uId)
          .collection('notifications')
          .add({
            'title': title,
            'body': body,
            'date': DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now()),
            'isRead': false,
            'type': type,
            'targetId': targetId,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print('Error saving notification: $e');
    }
  }
}
