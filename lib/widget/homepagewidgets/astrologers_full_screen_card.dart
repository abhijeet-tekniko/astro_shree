import 'package:flutter/material.dart';
import '../../core/utils/image_constant.dart';
import '../../core/utils/themes/textStyle.dart';
import '../custom_image_view.dart';

class AstrologersListScreenCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String language;
  final String charge;
  final String status;
  final bool isPopular;
  final VoidCallback onPressed;

  const AstrologersListScreenCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.language,
    required this.charge,
    required this.status,
    required this.isPopular,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDC3C3)),
        color: const Color(0x000fffff),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 2,
            child: Image.asset(
              ImageConstant.popularAstro,
              width: screenWidth * 0.28,
              height: screenHeight * 0.05,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CustomImageView(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: screenHeight * 0.1,
                        radius: BorderRadius.circular(60),
                        imagePath: imageUrl,
                      ),

                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: Image.asset(
                          status == "online"
                              ? ImageConstant.onlineMark
                              : ImageConstant.offlineMark,
                          width: 15,
                          height: 15,
                        ),
                      ),

                      Positioned(
                        bottom: -2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "* 4.2",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  status == "online"
                      ? Text(status, style: TextStyle(color: Colors.green))
                      : Text(status, style: TextStyle(color: Colors.red)),
                  Text(charge, style: TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyles.bodyText2),
                        Text("Vedic Astrology", style: TextStyles.bodyText5),
                        Text("Hindi, English", style: TextStyles.bodyText5),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: screenWidth * 0.22,
                          height: screenHeight * 0.04,
                          child: ElevatedButton.icon(
                            onPressed: onPressed,
                            icon: const Icon(Icons.call, size: 16),
                            label: const Text(
                              "Call",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: screenWidth * 0.22,
                          height: screenHeight * 0.04,
                          child: ElevatedButton.icon(
                            onPressed: onPressed,
                            icon: const Icon(Icons.chat, size: 15),
                            label: const Text(
                              "Chat",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
