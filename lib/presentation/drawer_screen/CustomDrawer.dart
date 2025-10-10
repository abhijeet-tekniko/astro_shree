import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/sharePrefs/prefsKeys.dart';
import 'package:astro_shree_user/core/utils/sharePrefs/prefsUtils.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/data/api_call/profile_api.dart';
import 'package:astro_shree_user/presentation/profile_screen/profile_screen.dart';
import 'package:astro_shree_user/presentation/review_screen/review_screen.dart';
import 'package:astro_shree_user/presentation/signUp_screen/sign_up_screen.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../products/product_transaction_screen.dart';
import '../remedy/user_remedy_screen.dart';

class CustomDrawer extends StatelessWidget {
  final ProfileApi profileApi;
  final Function(int) onItemSelected;
  final double screenHeight;
  final double screenWidth;

  const CustomDrawer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.onItemSelected,
    required this.profileApi,
  });

  @override
  Widget build(BuildContext context) {
    final sideMenuTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    return Drawer(
        //todo add that icon after list tile text
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            // Profile Header (unchanged)
            SizedBox(
              height: 010,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.05,
                bottom: screenHeight * 0.01,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => ProfileScreen(isHome: true));
                },
                child: Obx(() {
                  final user = profileApi.userProfile.value;
                  final profileImage = (user?.profileImage != null &&
                          user!.profileImage.isNotEmpty)
                      ? user.profileImage
                      : ImageConstant.tempProfileImg;

                  return Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: screenHeight * 0.03,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            // borderRadius:
                            //     BorderRadius.circular(screenHeight * 0.045),
                            child: Image.network(
                              profileImage,
                              fit: BoxFit.fill,
                              height: screenHeight * 0.3,
                              width: screenWidth,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  ImageConstant.tempProfileImg,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Text(
                            user?.name != '' ? user!.name : 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            // Menu Items
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/product_transaction.png',
              label: 'Product Transaction',
              onTap: () async {
              Get.to(ProductTransactionListScreen());
              },
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/wallet_2169864.png',
              label: 'Wallet',
              onTap: () => NavigatorService.pushNamed(AppRoutes.walletScreen),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/interactive-session_17939726.png',
              label: 'Chat Sessions',
              onTap: () => NavigatorService.pushNamed(AppRoutes.chatSession),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/interactive-session_17939726.png',
              label: 'Remedy',
              onTap: () => Get.to(UserRemedyListScreen()),
              style: sideMenuTextStyle,
            ),
            // _buildMenuItem(
            //   iconPath: 'assets/sideBarIcons/transactionImage.png',
            //   label: 'Transaction',
            //   onTap: () =>
            //       NavigatorService.pushNamed(AppRoutes.transactionScreen),
            //   style: sideMenuTextStyle,
            // ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/product_transaction.png',
              label: 'Pooja Transaction',
              onTap: () =>
                  NavigatorService.pushNamed(AppRoutes.poojaTransactionScreen),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/support_13653915.png',
              label: 'Support',
              onTap: () => NavigatorService.pushNamed(AppRoutes.supportScreen),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/rating_1477680.png',
              label: 'Rate Us',
              onTap: () => Get.to(() => ReviewScreen()),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/privacy_icon.png',
              label: 'Privacy & Policy',
              onTap: () => NavigatorService.pushNamed(AppRoutes.privacyScreen),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/about.png',
              label: 'About Us',
              onTap: () => NavigatorService.pushNamed(AppRoutes.aboutUsScreen),
              style: sideMenuTextStyle,
            ),
            _buildMenuItem(
              iconPath: 'assets/sideBarIcons/terms.png',
              label: 'Terms & Condition',
              onTap: () => NavigatorService.pushNamed(AppRoutes.termScreen),
              style: sideMenuTextStyle,
            ),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC62828))),
              leading: Icon(Icons.power_settings_new_outlined,
                  color: const Color(0xFFC62828)),
              onTap: () async {
                PrefsUtils.remove(PrefsKeys.isLoggedIn);
                Get.offAll(() => SignUPScreen());
              },
              visualDensity: VisualDensity(vertical: -4),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            ),
            SizedBox(
              height: screenHeight * 0.12,
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  "Also available on",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomImageView(
                    height: screenHeight * 0.045,
                    width: screenHeight * 0.045,
                    imagePath: "assets/sideBarIcons/Instagram.png",
                  ),
                  CustomImageView(
                    height: screenHeight * 0.045,
                    width: screenHeight * 0.045,
                    imagePath: "assets/sideBarIcons/facebook.png",
                  ),
                  CustomImageView(
                    height: screenHeight * 0.045,
                    width: screenHeight * 0.045,
                    imagePath: "assets/sideBarIcons/youtube.png",
                  ),
                  CustomImageView(
                    height: screenHeight * 0.045,
                    width: screenHeight * 0.045,
                    imagePath: "assets/sideBarIcons/Linkedin.png",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Center(
              child: Text(
                "v1.0.1",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }


  Widget _buildMenuItem({
    String? iconPath,
    required String label,
    required VoidCallback onTap,
    required TextStyle style,
  }) {
    return ListTile(
      leading: iconPath != null ? Image.asset(iconPath, height: 20) : null,
      title: Text(label, style: style),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
      visualDensity: VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
    );
  }
}
