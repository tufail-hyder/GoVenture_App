import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Must be a TOP-LEVEL (or static) function — background message handling
/// runs in a separate isolate and cannot access instance state.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No UI work needed here: when a message includes a "notification" payload
  // (as ours does), the OS already shows it in the tray while the app is
  // backgrounded or terminated.
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  /// Every installed app instance subscribes to this topic — simplest way to
  /// broadcast "new trip / new blog" to everyone without storing per-user
  /// device tokens.
  static const String allUsersTopic = 'all_users';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      settings: const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _messaging.subscribeToTopic(allUsersTopic);

    // FCM does NOT show a system-tray notification while the app is in the
    // foreground, so we show one ourselves via flutter_local_notifications.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'goventure_general',
      'General Notifications',
      channelDescription: 'New trips, blogs and app updates',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails, iOS: DarwinNotificationDetails());

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }
}