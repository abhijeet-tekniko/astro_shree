import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../core/utils/url_launcher/url_launcher.dart';
import '../../data/api_call/cms_controller.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen ({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  final controller=Get.put(CmsController());

  @override
  void initState() {
    controller.fetchPolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        centerTitle: true,
        title:  AppbarTitle(
          text: 'Privacy Policy',
          margin: EdgeInsets.only(left:screenWidth * 0.08),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx((){
          return   controller.isLoading.value?Center(child: CircularProgressIndicator(),): Html(
            data: controller.privacyData.first.privacyPolicy,
            onLinkTap: (url, attributes, element) async {
              if (url != null) {
                UrlLauncherHelper.launchInBrowser(url);
              }
            },
            onAnchorTap: (url, attributes, element) async {
              if (url != null) {
                UrlLauncherHelper.launchInBrowser(url);
              }
            },
          );
        }),
      ),
    );
  }
}




