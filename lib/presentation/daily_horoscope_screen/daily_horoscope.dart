import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/presentation/daily_horoscope_screen/daily_horoscope_details.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/string_resource.dart';

class DailyHoroscopeScreen extends StatelessWidget {
  const DailyHoroscopeScreen({super.key});

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
        centerTitle: true,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: AppbarTitle(
          text: 'Daily Horoscope',
          // margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        // child: GridView.count(
        //   crossAxisCount: 3,
        //   childAspectRatio: screenHeight * 0.0007,
        //   mainAxisSpacing: screenHeight * 0.01,
        //   crossAxisSpacing: screenWidth * 0.1,
        //   children: [
        //     _buildZodiacIcon(
        //       ImageConstant.ariesIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Aries",
        //       "Mar 21-Apr 19",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.taurusIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Taurus",
        //       "Apr 20-May 20",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.geminiIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Gemini",
        //       "May 21- Jun 21",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.cancerIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Cancer",
        //       "Jun 22 - Jul 22",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.leoIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Leo",
        //       "Jul 23-Aug 22",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.virgoIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Virgo",
        //       "Aug 23-Sep 22",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.libraIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Libra",
        //       "Sep 23-Oct 23",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.scorpioIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Scorpio",
        //       "Oct 24-Nov 21",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.sagittariusIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Sagittarius",
        //       "Nov 22-Dec 21",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.capricornIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Capricorn",
        //       "Dec 22-Jan 19",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.aquariusIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Aquarius",
        //       "jan 20-Feb 18",
        //     ),
        //     _buildZodiacIcon(
        //       ImageConstant.piscesIcon,
        //       screenWidth,
        //       screenHeight,
        //       "Pisces",
        //       "Feb 19-Mar 20",
        //     ),
        //   ],
        // ),
        child: GridView.builder(
          itemCount: 12,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: screenHeight * 0.0007,
            mainAxisSpacing: screenHeight * 0.01,
            crossAxisSpacing: screenWidth * 0.1,
          ),
          itemBuilder: (context, index) {
            var horoscope = StringResource.horoscopeList[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => HoroscopeDetailedScreen(
                    data: horoscope["Name"], index: index));
              },
              child: _buildZodiacIcon(
                horoscope['Image'],
                screenWidth,
                screenHeight,
                horoscope['Name'],
                horoscope['Date'],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildZodiacIcon(
    String imagePath,
    double screenWidth,
    double screenHeight,
    String title,
    String date,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CustomImageView(
            imagePath: imagePath,
            margin: EdgeInsets.all(screenWidth * 0.03),
            fit: BoxFit.fill,
            // onTap: (){
            //   NavigatorService.pushNamed(AppRoutes.walletScreen);
            // },
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyles.bodyText2),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
