import 'package:astro_shree_user/widget/homepagewidgets/astrologers_full_screen_card.dart';
import 'package:flutter/material.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

class OurAstrologers extends StatelessWidget {
  const OurAstrologers({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Our Astrologers'),
        centerTitle: true,
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: AstrologersListScreenCard(
                  imageUrl:  ImageConstant.astrologerImage1,
                  name: "Astro Neetu",
                  position: "Vedic Astrology",
                  language: "Hindi/English",
                  charge: "₹15/min",
                  status: index % 2 == 0 ? "online" : "online",
                  isPopular: index % 3 == 0 ? true : false,
                  onPressed: () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
