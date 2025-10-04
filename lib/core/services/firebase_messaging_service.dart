import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('💤 Background message: ${message.notification?.title}');
}

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin _localNotifications =
      // FlutterLocalNotificationsPlugin();
  // final _onMessageController = StreamController<RemoteMessage>.broadcast();

  final _onMessageOpenedController =
      StreamController<RemoteMessage>.broadcast();
  // Stream<RemoteMessage> get onMessage => _onMessageController.stream;

  Stream<RemoteMessage> get onMessageOpenedApp =>
      _onMessageOpenedController.stream;

  /// ✅ Securely get access token from service account JSON
  Future<AccessCredentials> getAccessToken() async {
    try {
      const serviceAccountPath = 'firebase/notification_key.json';
      final jsonString = await rootBundle.loadString(serviceAccountPath);

      final credentials = ServiceAccountCredentials.fromJson(jsonString);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await clientViaServiceAccount(credentials, scopes);
      debugPrint('🔑 Access token retrieved successfully');
      return client.credentials;
    } catch (e) {
      debugPrint('❌ Failed to get access token: $e');
      rethrow;
    }
  }

  void intializeFirebaseMessaging() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _messaging.getToken().then((token) {
      debugPrint('🔑 FCM token: $token');
    });
  }

  Future<void> sendNotification({
    required String title,
    required String body,
  }) async {
    final token = await _messaging.getToken();
    final credentials = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${credentials.accessToken}',
    };
    final response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/smooth-reason-440420-e9/messages:send',
      ),
      headers: headers,
      body: jsonEncode({
        'message': {
          'token': token,
          'notification': {'body': body, 'title': title},
        },
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('✅ Notification sent successfully');
    } else {
      debugPrint('❌ Failed to send notification: ${response.body}');
    }
  }
}
