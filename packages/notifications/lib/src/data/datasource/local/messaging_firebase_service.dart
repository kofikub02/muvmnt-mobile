import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mvmnt_cli/core/di/injection_container.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/local/local_notification_service.dart';
import 'package:mvmnt_cli/features/notifications/data/datasource/local/notification_handler.dart';
import 'package:timezone/data/latest_all.dart';

/// Background message handler (must be top-level function or static)
/// Handles messages when the app is fully terminated
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.data}');
  final notificationData = message.notification;
  if (notificationData != null) {
    // Init local notifications service
    await serviceLocator<LocalNotificationsService>().init();
    await serviceLocator<LocalNotificationsService>().showNotification(
      notificationData.hashCode,
      notificationData.title,
      notificationData.body,
      message.data.toString(),
    );
  }
}

class MessagingFirebaseService {

  MessagingFirebaseService({
    required this.localNotificationsService,
    required this.dio,
    required this.firebaseMessaging,
  });
  final Dio dio;
  final FirebaseMessaging firebaseMessaging;
  final LocalNotificationsService localNotificationsService;

  /// Initialize Firebase Messaging and sets up all message listeners
  Future<void> init() async {
    initializeTimeZones();

    // Init local notifications service
    await localNotificationsService.init();

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
    final initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _onMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _registerDeviceToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    try {
      await dio.post(
        '/notifications/user-data',
        data: {'device_token': token, 'tenant': 'cli'},
      );
      print('FCM token registered: $token');
    } catch (e) {
      print(e);
    }
  }

  /// Requests notification permission from the user
  Future<void> _requestPermission() async {
    // Request permission for alerts, badges, and sounds
    final result = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    if (result.authorizationStatus != AuthorizationStatus.authorized ||
        result.authorizationStatus != AuthorizationStatus.provisional) {
      print('show screen to grant notifications');
      // openAppSettings();
    }

    // Log the user's permission decision
    print('User granted permission: ${result.authorizationStatus}');
  }

  /// Retrieves and manages the FCM token for push notifications
  Future<void> _handlePushNotificationsToken() async {
    // Get the FCM token for the device
    final token = await firebaseMessaging.getToken();
    await _registerDeviceToken(token);

    // Listen for token refresh events
    firebaseMessaging.onTokenRefresh
        .listen((fcmToken) async {
          await _registerDeviceToken(fcmToken);
        })
        .onError((error) {
          // Handle errors during token refresh
          print('Error refreshing FCM token: $error');
        });
  }

  /// Handles messages received while the app is in the foreground
  void _onForegroundMessage(RemoteMessage message) {
    var notificationData = message.notification;
    var android = message.notification?.android;
    if (notificationData != null && android != null) {
      // Display a local notification using the service
      localNotificationsService.showNotification(
        notificationData.hashCode,
        notificationData.title,
        notificationData.body,
        jsonEncode(message.data), // message.data.toString(),
      );
    }
  }

  /// Handles notification taps when app is opened from the background or terminated state
  void _onMessageOpenedApp(RemoteMessage message) {
    print('Notification caused the app to open: ${message.data}');
    // TODO: Add navigation or specific handling based on message data
    handleNotificationNavigation(message.data);
  }
}
