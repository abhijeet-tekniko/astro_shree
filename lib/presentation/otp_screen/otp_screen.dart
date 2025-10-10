import 'dart:async';
import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/sharePrefs/prefsKeys.dart';
import 'package:astro_shree_user/core/utils/sharePrefs/prefsUtils.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../data/api_call/signup_api.dart';
import '../../services/firebase_service_file.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPScreen({super.key, required this.mobileNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final SignUpApi signUpApi = Get.put(SignUpApi());
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  var timeLeft = 30.obs;
  String timerText = "30 seconds remaining";

  Timer? _timer;

  void startTimer() {
    timeLeft.value = 30;
    timerText = "${timeLeft.value} seconds remaining";
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
        setState(() {
          timerText = "${timeLeft.value} seconds remaining";
        });
      } else {
        timer.cancel();
      }
    });
  }
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFB3B3B3)),
      borderRadius: BorderRadius.circular(10),
    ),
  );
  @override
  void initState() {
    super.initState();
    startTimer();
    otpFocusNode.addListener(() {
      if (otpFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(otpFocusNode);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.3,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We have sent OTP TO +91${widget.mobileNumber}',
                  style: TextStyles.headline4,
                ),
                RichText(
                  text: TextSpan(
                    text: "Not your number? ",
                    style: TextStyles.bodyText3,
                    children: [
                      TextSpan(
                        text: "Edit phone number",
                        style: TextStyles.linkText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.back();
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(child: Text('Enter OTP', style: TextStyles.subtitle1)),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: Pinput(
                    controller: otpController,
                    length: 4,
                    focusNode: otpFocusNode,
                    defaultPinTheme: PinTheme(
                      // width: screenWidth,
                      // height: screenHeight * 0.1,
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                        color: const Color(0xFFC62828),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFC62828)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  alignment: Alignment.center,
                  child:
                      (timerText == "30 seconds remaining" ||
                              timerText == "0 seconds remaining")
                          ? RichText(
                            text: TextSpan(
                              style: TextStyles.bodyText2,
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Didn\'t get OTP? Resend',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          startTimer();
                                          signUpApi.resendOtp(widget.mobileNumber);
                                        },
                                ),
                              ],
                            ),
                          )
                          : Text(timerText, style: TextStyles.caption),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          signUpApi.isLoading.value
                              ? null
                              : () async {
                                String otp = otpController.text;
                                if (otp.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter a valid OTP.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                final fcmToken = await PrefsUtils.getString(PrefsKeys.fcmToken);
                                signUpApi.callVerifyOTP(
                                  widget.mobileNumber,
                                  otpController.text,
                                    fcmToken.toString(),
                                );
                              },
                      child:
                          signUpApi.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                'VERIFY',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
