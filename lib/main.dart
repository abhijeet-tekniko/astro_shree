import 'dart:convert';

import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/presentation/chat_and_call_screen/call_screen.dart';
import 'package:astro_shree_user/presentation/newChatScreen.dart';
import 'package:astro_shree_user/presentation/signUp_screen/sign_up_screen.dart';
import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/services/firebase_service_file.dart';
import 'package:astro_shree_user/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

import 'core/network/endpoints.dart';
import 'data/api_call/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
  ]);
  final langController = Get.put(LanguageController());
  await langController.loadLanguage();
  Get.put(SocketService());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _listenCallEvents();
    NotificationService().init().then((_) {
      print('NotificationService initialized');
    }).catchError((error) {
      print('Error initializing NotificationService: $error');
    });
  }

  void _listenCallEvents() {
    FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
      switch (event?.event) {
        case Event.actionCallIncoming:
          print('Incoming call received');
          break;
        case Event.actionCallAccept:
          break;
        case Event.actionCallDecline:
        case Event.actionCallEnded:
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '',
      theme: AppTheme.lightTheme,
      navigatorKey: NavigatorService.navigatorKey,
      routes: AppRoutes.routes,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
