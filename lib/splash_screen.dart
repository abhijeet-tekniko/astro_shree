import 'dart:async';
import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/data/api_call/profile_api.dart';
import 'package:astro_shree_user/presentation/home_screen/home_screen.dart';
import 'package:astro_shree_user/presentation/newChatScreen.dart';
import 'package:astro_shree_user/presentation/signUp_screen/sign_up_screen.dart';
import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/utils/sharePrefs/prefsKeys.dart';
import 'core/utils/sharePrefs/prefsUtils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final profileApi = Get.put(ProfileApi());
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    bool log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    Timer(Duration(milliseconds: 1500), () {
      if (log == true) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => SignUPScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.imgSplash),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 335.0),
            child: Text(
              'AstroShree',
              style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC62828)),
            ),
          )
        ],
      ),
    );
  }
}
