import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// Global navigator key to use for navigation from background or notification tap.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('💤 Background message: ${message.notification?.title}');
}

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// 🔑 Get access token from your Firebase service account
  Future<AccessCredentials> getAccessToken() async {
    try {
      const serviceAccountPath = 'firebase/notification_key.json';
      final jsonString = await rootBundle.loadString(serviceAccountPath);
      final credentials = ServiceAccountCredentials.fromJson(jsonString);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final client = await clientViaServiceAccount(credentials, scopes);
      return client.credentials;
    } catch (e) {
      debugPrint('❌ Failed to get access token: $e');
      rethrow;
    }
  }

  /// ✅ Initialize FCM + Local Notifications + Tap Handling
  Future<void> initializeFirebaseMessaging() async {
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setAutoInitEnabled(true);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 🧭 Handle notification tap (foreground)
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationNavigation(details.payload);
      },
    );

    // 📨 Foreground notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.data), // 👈 add data for navigation
        );
      }
    });

    // 📲 App opened from background (notification tap)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(jsonEncode(message.data));
    });

    // 🚀 App launched from terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationNavigation(jsonEncode(initialMessage.data));
    }
  }

  /// ✅ Send push notification using your Firebase service account
  Future<void> sendNotification({
    required String title,
    required String body,
    required String token,
    Map<String, dynamic>? data, // optional for navigation
  }) async {
    final credentials = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${credentials.accessToken.data}',
    };

    final payload = {
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'data': data ?? {}, // 👈 attach screen navigation info if needed
      },
    };

    final response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/smooth-reason-440420-e9/messages:send',
      ),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      debugPrint('✅ Notification sent successfully');
    } else {
      debugPrint('❌ Failed to send notification: ${response.body}');
    }
  }

  /// 🧭 Handle navigation when user taps notification
  void _handleNotificationNavigation(String? payload) {
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload);

      // Example navigation — adjust to your app’s routes
      final screen = data['screen'];
      if (screen == 'chat') {
        final chatId = data['chatId'];
        navigatorKey.currentState?.pushNamed('/chat', arguments: chatId);
      } else if (screen == 'profile') {
        navigatorKey.currentState?.pushNamed('/profile');
      } else {
        debugPrint('⚠️ Unknown notification target: $data');
      }
    } catch (e) {
      debugPrint('❌ Navigation failed: $e');
    }
  }
}
