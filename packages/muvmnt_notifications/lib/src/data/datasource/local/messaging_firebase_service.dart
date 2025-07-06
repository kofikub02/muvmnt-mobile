import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:muvmnt_notifications/src/data/datasource/local/local_notification_service.dart';
import 'package:muvmnt_notifications/src/data/datasource/local/notification_handler.dart';
import 'package:timezone/data/latest_all.dart';

final _localNotificationsService = LocalNotificationsService();

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notificationData = message.notification;
  if (notificationData != null) {
    // Init local notifications service
    await _localNotificationsService.init();
    await _localNotificationsService.showNotification(
      notificationData.hashCode,
      notificationData.title,
      notificationData.body,
      jsonEncode(message.data),
    );
  }
}

class MessagingFirebaseService {
  final Dio _dio = Dio();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init() async {
    initializeTimeZones();

    // Init local notifications service
    await _localNotificationsService.init();

    // Handle FCM token
    _handlePushNotificationsToken();

    // Request user permission for notifications
    _requestPermission();

    // Register handler for background messages (app terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Listen for notification taps when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    // Check for initial message that opened the app from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _registerDeviceToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    try {
      await _dio.post(
        '/notifications/user-data',
        data: {'device_token': token, 'tenant': 'cli'},
      );
      log('FCM token registered: $token');
    } catch (e) {
      log(e.toString());
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (result.authorizationStatus != AuthorizationStatus.authorized ||
        result.authorizationStatus != AuthorizationStatus.provisional) {
      log('show screen to grant notifications');
      // openAppSettings();
    }

    // Log the user's permission decision
    log('User granted permission: ${result.authorizationStatus}');
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await _firebaseMessaging.getToken();
    await _registerDeviceToken(token);

    // Listen for token refresh events
    _firebaseMessaging.onTokenRefresh
        .listen((fcmToken) async {
          await _registerDeviceToken(fcmToken);
        })
        .onError((error) {
          // Handle errors during token refresh
          log('Error refreshing FCM token: $error');
        });
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    var notificationData = message.notification;
    var android = message.notification?.android;
    if (notificationData != null && android != null) {
      // Display a local notification using the service
      _localNotificationsService.showNotification(
        notificationData.hashCode,
        notificationData.title,
        notificationData.body,
        jsonEncode(message.data),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    handleNotificationNavigation(message.data);
  }
}
