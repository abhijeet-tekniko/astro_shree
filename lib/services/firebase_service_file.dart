import 'dart:convert';

import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/presentation/newChatScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/utils/navigator_service.dart';
import '../core/utils/sharePrefs/prefsKeys.dart';
import '../core/utils/sharePrefs/prefsUtils.dart';


class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    await Firebase.initializeApp();
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    await PrefsUtils.saveString(PrefsKeys.fcmToken, token.toString());

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      if (message.notification != null) {
        showNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: message.notification!.title ?? 'Notification',
          body: message.notification!.body ?? 'No body',
          payload: jsonEncode(message.data), // Encode data as JSON string
        );
        print('Foreground message data: ${message.data}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification opened the app: ${message.data}');
      _handleNotificationTap(message.data);
    });

    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print(
          'App launched from terminated state via notification: ${initialMessage.data}');
      _handleNotificationTap(initialMessage.data);
    }

    // Local notification initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // Initialize local notifications with tap handler
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          print('Notification payload: ${response.payload}');
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            _handleNotificationTap(data);
          } catch (e) {
            print('Error parsing notification payload: $e');
          }
        }
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) async {
    print('Handling notification tap with data: $data');

    if (data.containsKey('chatSessionId') &&
        data.containsKey('senderId') &&
        data.containsKey('senderProfileImage')) {
      final chatSessionId = data['chatSessionId'] as String;
      final astrologerId = data['senderId'] as String;
      final astrologerImage = data['senderProfileImage'] as String;

      String astrologerName = data['senderName'] as String;
      NavigatorService.navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ChatNewwScreen(
          chatSessionId: chatSessionId,
          astrologerName: astrologerName,
          astrologerId: astrologerId,
          astrologerImage: EndPoints.imageBaseUrl + astrologerImage,
          maxDuartion: '30',
        ),
      ));
    } else {
      print('Invalid notification data for chat navigation');
    }
  }
}
