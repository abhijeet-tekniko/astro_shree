import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/navigator_service.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/otp_screen/otp_screen.dart';
import '../../presentation/signUp_screen/signUp_form.dart';
import '../../routes/app_routes.dart';

class SignUpApi extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dio = dioClient.client;
  }

  void callSignUp(String mobile, String countryCode) async {
    isLoading(true);
    try {
      final response = await dio.post(
        EndPoints.signUp,
        data: {"mobile": mobile,"countryCode": countryCode},
      );
      var result = response.data;
      print(result);
      if (response.statusCode == 200) {
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "OTP Sent Successfully",
        );
        bool isNewUser  = result['newUser'];
        await PrefsUtils.remove(PrefsKeys.isNewUser);
        await PrefsUtils.saveBool(PrefsKeys.isNewUser , isNewUser );
        Get.to(() => OTPScreen(mobileNumber: mobile));
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );
      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
    }
  }

  void resendOtp(String mobile) async {
    isLoading(true);
    try {
      final response = await dio.post(
        EndPoints.signUp,
        data: {"mobile": mobile},
      );
      var result = response.data;
      print(result);
      if (response.statusCode == 200) {
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "OTP Sent Successfully",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );
      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
    }
  }

  void callVerifyOTP(String mobile, String otp,String fcmToken) async {
    isLoading(true);
    try {
      final response = await dio.post(
        EndPoints.verifyOTP,
        data: {"mobile": mobile, "otp": otp,"fcmToken":fcmToken},
      );
      var result = response.data;
      print(result);
      print(result['token']);
      if (response.statusCode == 200) {
        await PrefsUtils.saveBool(PrefsKeys.isLoggedIn, true);
        await PrefsUtils.saveString(PrefsKeys.userMobile, mobile);
        await PrefsUtils.saveString(PrefsKeys.userToken, result['token']);
        bool isNewUser  = await PrefsUtils.getBool(PrefsKeys.isNewUser ) ?? false;
        if (isNewUser ) {
          NavigatorService.popAndPushNamed(AppRoutes.newSignUpScreen);
        } else {
          Get.offAll(HomeScreen());
          // NavigatorService.popAndPushNamed(AppRoutes.homeScreen);
        }

        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "Sign Up Successful",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );
      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
    }
  }
}
