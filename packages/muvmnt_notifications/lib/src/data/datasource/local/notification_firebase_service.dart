import 'dart:io';

import 'package:timezone/data/latest_all.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await serviceLocator<NotificationFirebaseService>()
      .setupFlutterNotifications();
  await serviceLocator<NotificationFirebaseService>().showNotification(message);
}

class NotificationFirebaseService {
  final Dio _dio = Dio();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isFlutterLocalNotificationsInitialized = false;

  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      announcement: true,
      badge: true,
      providesAppNotificationSettings: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user permission granted');
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user provisional granted permission');
    } else {
      print('open app settings to grant permissions');
      // openAppSettings();
    }

    return false;
  }

  Future<void> _registerDeviceToken(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }
    try {
      await _dio.post(
        '/notifications/user-data',
        data: {"device_token", token},
      );

      print('FCM token registered: $token');
    } catch (e) {
      print(e);
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Should be pushed up
  Future<void> initialize() async {
    initializeTimeZones();

    // Get APNS token
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken == null) {
        return;
      }
    }

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    await _registerDeviceToken(token);

    _firebaseMessaging.onTokenRefresh
        .listen((onToken) async {
          print('firebasemessaging token refreshed');
          await _registerDeviceToken(token);
        })
        .onError((err) {});

    // Background setup
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup message handlers
    await _setupMessageHandlers();
    await setupFlutterNotifications();

    // subscribe to all devices topic so you can broadcast to all
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // Android notification setup
    const androidNotificationChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);

    const initializeSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Ios setup
    final initializeSettingsDarwin = DarwinInitializationSettings();

    // Mobile setup
    final initializationSettings = InitializationSettings(
      android: initializeSettingsAndroid,
      iOS: initializeSettingsDarwin,
    );

    // Flutter notifications setup
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // _handleBackgroundMessage(details.payload);
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await _localNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground Message
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
      _showDialogWithNotification(message);
    });

    // Background message
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Opened app
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      //open chat screen
    }
  }

  void _showDialogWithNotification(RemoteMessage message) {
    // final context = navigatorKey.currentContext;
    // if (context != null) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('close'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               _handleBackgroundMessage(message.data['type'] ?? '');
    //             },
    //             child: const Text('view'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}
