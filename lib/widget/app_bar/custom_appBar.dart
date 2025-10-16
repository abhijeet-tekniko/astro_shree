import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/data/model/user_wallet_model.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/api_call/language_controller.dart';
import '../../presentation/notificationScreen/notification_screen.dart';
import '../../presentation/search/search_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double height;
  final double width;
  final String logoImagePath;
  final String menuIconImagePath;
  final String languagePath;
  final String walletIconImagePath;
  final String profileImagePath;
  // final String walletAmount;
  final Rx<UserWalletModel?> walletAmountObs;
  final Function()? onMenuIconTap;

  const CustomAppBar({
    super.key,
    this.title,
    required this.height,
    required this.width,
    required this.logoImagePath,
    required this.menuIconImagePath,
    required this.walletIconImagePath,
    required this.profileImagePath,
    this.onMenuIconTap,
    /*required this.walletAmount, */ required this.languagePath,
    required this.walletAmountObs,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'AstroShree',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFFC62828)),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: onMenuIconTap,
          child: CustomImageView(
              imagePath: menuIconImagePath,
              height: 10,
              width: 25,
              color: Color(0xFFC62828)),
        ),
      ),
      leadingWidth: 45,
      actions: [
        GestureDetector(
          onTap: () {
            Get.to(() => SearchScreen());
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Icon(Icons.search),
          ),
        ),
        Obx(() {
          final balance = walletAmountObs.value?.data?.wallet?.balance ?? 0;
          return GestureDetector(
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.walletScreen);
            },
            child: Container(
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomImageView(
                      imagePath: walletIconImagePath,
                      height: height * 0.02,
                      width: width * 0.05,
                      color: Color(0xFFC62828),
                      fit: BoxFit.fill,
                    ),
                    if (balance > 0)
                      Text(
                        balance.toString().length > 5
                            ? ' ₹ ${balance.toString().substring(0, 5)}...'
                            : ' ₹ $balance',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFC62828),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            _showLanguagePopup();
          },
          child: Padding(
            padding: const EdgeInsets.only(/*left: 8.0,top:8.0,bottom: 8.0*/),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImageView(
                  imagePath: languagePath,
                  height: height * 0.03,
                  width: width * 0.08,
                  color: Color(0xFFC62828),
                  // fit: BoxFit.fill
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Get.to(NotificationScreen());
            // NavigatorService.pushNamed(AppRoutes.walletScreen);
          },
          child: Icon(
            Icons.notifications_none_outlined,
            color: Color(0xFFC62828),
            size: 20,
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  void _showLanguagePopup() {
    final langController = Get.find<LanguageController>();

    Get.defaultDialog(
      title: 'Select Language',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Reports will be generated using your selected language.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildLanguageOption(title: 'English', code: 'en'),
          const SizedBox(height: 10),
          _buildLanguageOption(title: 'हिन्दी', code: 'hi'),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({required String title, required String code}) {
    final langController = Get.find<LanguageController>();
    return GestureDetector(
      onTap: () {
        langController.setLanguage(code);
        Get.back(); // close dialog
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: langController.selectedLanguage.value == code
              ? Colors.grey[300]
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Center(child: Text(title)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
