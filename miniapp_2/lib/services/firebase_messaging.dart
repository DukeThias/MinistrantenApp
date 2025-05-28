import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> setupPushNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Token holen
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  // Optional: Permissions anfragen
  if (Platform.isIOS) {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('iOS Permission: ${settings.authorizationStatus}');
  }

  // Background handler für Android einrichten, wenn nötig
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  return token ?? '';
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Hintergrundnachricht erhalten: ${message.messageId}");
}
