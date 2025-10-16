import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/data/api_call/signup_api.dart';
import 'package:astro_shree_user/presentation/otp_screen/otp_screen.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_Text_button.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final TextEditingController mobileController = TextEditingController();
  final SignUpApi signUpApi = Get.put(SignUpApi());
  final FocusNode mobileFocusNode = FocusNode();
  String selectedMobileNumber = "";
  String selectedCountryCode = "+91";

  @override
  void initState() {
    super.initState();
    mobileFocusNode.addListener(() {
      if (mobileFocusNode.hasFocus) {
        FocusScope.of(context).requestFocus(mobileFocusNode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgLoginBg),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.2),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgLogo,
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    counterText: '',
                    // suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                    // prefix: Icon(Icons.arrow_drop_down_sharp),
                  ),
                  showDropdownIcon: false,
                  initialCountryCode: 'IN',
                  controller: mobileController,
                  focusNode: mobileFocusNode,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  onChanged: (phone) {
                    selectedMobileNumber = phone.number;
                    selectedCountryCode = phone.countryCode;
                  },
                  onCountryChanged: (country) {
                    selectedCountryCode = '+${country.dialCode}';
                  },
                ),
                const SizedBox(height: 16),
                Obx(
                  () => ElevatedButton(
                    onPressed: signUpApi.isLoading.value
                        ? null
                        : () {
                            if (selectedMobileNumber.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please enter a valid mobile number.',
                                  ),
                                ),
                              );
                              return;
                            }
                            String fullNumber =
                                "$selectedCountryCode$selectedMobileNumber";
                            print(fullNumber);
                            signUpApi.callSignUp(
                                selectedMobileNumber, selectedCountryCode);
                          },
                    child: signUpApi.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Get OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(text: 'By signing up, you agree to our '),
                      TextSpan(
                        text: 'Terms of Use',
                        style: TextStyles.caption1,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigatorService.pushNamed(
                              AppRoutes.termScreen,
                            );
                          },
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyles.caption1,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigatorService.pushNamed(
                              AppRoutes.privacyScreen,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
