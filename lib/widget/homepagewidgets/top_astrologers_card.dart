import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class TopAstrologersCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String language;
  final String charge;
  final bool isCall;
  final bool isVerify;
  final VoidCallback onPressed;

  const TopAstrologersCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.language,
    required this.charge,
    required this.isCall,
    required this.isVerify,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.30,
      height: screenHeight*0.23,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDC3C3)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight * 0.1,
                width: screenHeight * 0.1,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: const Color(0xFFFFD9DB),
                  border: Border.all(color: Color(0xFFC62828),width: 1)
                ),
                child: CustomImageView(
                  // margin: const EdgeInsets.symmetric(horizontal: 5),
                  // height: screenHeight * 0.1,
                  width: screenWidth,
                  radius: BorderRadius.circular(60),
                  imagePath: imageUrl,
                  fit: BoxFit.fill,
                ),
              ),

            ],
          ),
          // const SizedBox(width: 10),
          // Text section
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Text("$charge/min", style: TextStyle(fontSize: 12,color: Colors.grey.shade800)),
          const SizedBox(width: 8),
          Container(
            height: screenHeight*0.03,
           width: screenWidth*0.2,
           alignment: Alignment.center,
           decoration: BoxDecoration(
             // border: Border.all(color: Color(0xFFC62828),),
             border: Border.all(color: Colors.green.shade800),
             borderRadius: BorderRadius.circular(20)

           ),
            child: Text('Chat',style: TextStyle(color: Colors.green.shade800,),),
          )
          // SizedBox(
          //   height: screenHeight * 0.02,
          //   child: ElevatedButton.icon(
          //     onPressed: onPressed,
          //     icon: Icon(isCall ? Icons.call : Icons.chat, size: 16),
          //     label: Text(
          //       isCall ? "Call" : "Chat",
          //       style: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: isCall ? Colors.green : Colors.blue,
          //       padding: const EdgeInsets.symmetric(horizontal: 8),
          //       textStyle: const TextStyle(fontSize: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}


/*
class TopAstrologersCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String language;
  final String charge;
  final bool isCall;
  final bool isVerify;
  final VoidCallback onPressed;

  const TopAstrologersCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.language,
    required this.charge,
    required this.isCall,
    required this.isVerify,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: screenHeight * 0.05,
      width: screenWidth * 0.8,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFDC3C3)),
        color: const Color(0x000fffff),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Stack(
            children: [
              CustomImageView(
                margin: EdgeInsets.symmetric(horizontal: 5),
                height: screenHeight * 0.1,
                radius: BorderRadius.circular(60),
                imagePath: imageUrl,
              ),

              // Verified tick at top right
              isVerify
                  ? Positioned(
                    bottom: 10,
                    right: 5,
                    child: Image.asset(
                      ImageConstant.verifiedTick,
                      width: 20,
                      height: 20,
                    ),
                  )
                  : Positioned(child: Container()),

              // Rating container at bottom center, half over the image
              Positioned(
                bottom: -2,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      !isCall ? "* 4.2" : "* 3.4",
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
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyles.bodyText2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: screenWidth * 0.4,
                child: Text(
                  position,
                  style: TextStyles.bodyText5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                language,
                style: TextStyles.bodyText5,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("$charge/min", style: TextStyles.bodyText5),
                  const SizedBox(width: 12),
                  isCall == true
                      ? Container(
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(fontSize: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                      : Container(
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
        ],
      ),
    );
  }
}
*/


class TopAstrologersListCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String position;
  final String language;
  final String charge;
  String? status;
  final String maxDuration;
  final String comesFrom;
  final bool isCall;
  final bool isChat;
  final bool isBusy;
  final bool isPopular;
  final String experience;
  final VoidCallback onPressed;
  final VoidCallback onTap;

   TopAstrologersListCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.position,
    required this.language,
    required this.charge,
    required this.status,
    required this.maxDuration,
    required this.isCall,
    required this.isBusy,
    required this.isPopular,
    required this.experience,
    required this.onPressed,
    required this.onTap, required this.isChat, required this.comesFrom,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC62828); // Custom red color for busy state
    const secondaryColor = Color(0xFF4A4A4A); // Dark gray for text
    const accentColor = Color(0xFFFFF3E0); // Light orange for accents

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth > 600; // Adjust for larger screens

        // Determine button color and status text based on status
        Color buttonColor;
        String statusText;

        if(comesFrom=='chat'&& isChat==false){
          status="isBusy";

        }
        switch (status!.toLowerCase()) {
          case 'online':
            buttonColor = Colors.green;
            statusText = 'Online';
            break;
          case 'isBusy':
            buttonColor = primaryColor;
            statusText = 'Busy';
            break;
          case 'offline':
          default:
            buttonColor = Colors.grey;
            statusText = 'Offline';
            break;
        }

        return Container(
          // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.all(12),
          width: double.infinity, // Full width for responsiveness
          height: isTablet ? 140 : 124, // Adjust height for tablet vs phone
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    // child: Stack(
                    child: Column(
                      // alignment: Alignment.center,
                      children: [
                        CustomImageView(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: isTablet ? 80 : 60,
                          width: isTablet ? 80 : 60,
                          radius: BorderRadius.circular(30),
                          imagePath: imageUrl,
                          fit: BoxFit.cover,
                          border: Border.all(color: Colors.red),
                        ),
                        // Positioned(
                        //   bottom: 8,
                        //   right: 8,
                        //   child: Container(
                        //     width: 16,
                        //     height: 16,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: buttonColor,
                        //       border: Border.all(color: Colors.red, width: 2),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(
                          height: 17,
                          width: 80,
                          child:  RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 14.0,
                            itemPadding: EdgeInsets.only(top: 6.0),
                            itemBuilder: (context, index) => Icon(
                             /* index.isEven ?*/ Icons.star ,/*: Icons.star_border,*/
                              color: Colors.amber,
                              size: 6,
                            ),
                            onRatingUpdate: (newRating) {
                              // setState(() {
                              //   rating = newRating;
                              // });
                            },
                          ),

                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        //   decoration: BoxDecoration(
                        //     color: Colors.yellow.shade600,
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Text(
                        //     isCall ? "★ 4.2" : "★ 3.4",
                        //     style: const TextStyle(
                        //       fontSize: 10,
                        //       color: Colors.black,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   bottom: 0,
                        //   child:
                        // ),
                      ],
                    ),
                  ),
                  // Text(
                  //   statusText,
                  //   style: TextStyle(
                  //     fontSize: isTablet ? 12 : 10,
                  //     color: buttonColor,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // capitalize(),
                      name.capitalizeFirst.toString().trim(),
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      position,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: secondaryColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: secondaryColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),   Text(
                      "Exp- $experience Years" ,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: secondaryColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "₹$charge/min",
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isPopular && !isBusy)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Popular",
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (isBusy)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$maxDuration min",
                        style: TextStyle(
                          fontSize: isTablet ? 12 : 10,
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                 comesFrom=="selectAstro"?SizedBox.shrink(): SizedBox(
                    width: isTablet ? 140 : 100,
                    height: isTablet ? 40 : 34,
                    child: ElevatedButton/*.icon*/(
                      onPressed: status == "online" ? onPressed : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              status == "isBusy"
                                  ? "Astrologer is currently busy"
                                  : "Please wait for the astrologer to come online",
                            ),
                            backgroundColor: buttonColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // backgroundColor:isBusy?primaryColor: buttonColor,
                        foregroundColor: Colors.white,
                        // side: BorderSide(
                        //   color: isBusy ? primaryColor : buttonColor,  // Set border color
                        //   width: 2.0, // Border width (adjust as needed)
                        // ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: isBusy ? primaryColor : buttonColor,  // Set border color
                            width: 1.0, // Border width (adjust as needed)
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      // icon: Icon(
                      //   isCall ? Icons.call : isBusy?Icons.do_disturb_off:Icons.chat,
                      //   size: isTablet ? 18 : 16,
                      //   color: Colors.white,
                      // ),
                      child: Text(
                        isBusy?"Notify":   isCall ? "Call" : "Chat",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 14,
                          fontWeight: FontWeight.bold,
                          color: isBusy?primaryColor: buttonColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

///shi h
//
// class TopAstrologersListCard extends StatelessWidget {
//   final String imageUrl;
//   final String name;
//   final String position;
//   final String language;
//   final String charge;
//   final String status;
//   final bool isCall;
//   final bool isPopular;
//   final VoidCallback onPressed;
//   final VoidCallback onTap;
//
//   const TopAstrologersListCard({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//     required this.position,
//     required this.language,
//     required this.charge,
//     required this.status,
//     required this.isCall,
//     required this.isPopular,
//     required this.onPressed,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       width: screenWidth * 0.8,
//       height: screenHeight * 0.15,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color(0xFFFDC3C3)),
//         color: const Color(0x000fffff),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(width: 12),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: onTap,
//                 child: Stack(
//                   children: [
//                     CustomImageView(
//                       margin: EdgeInsets.symmetric(horizontal: 5),
//                       height: screenHeight * 0.1,
//                       radius: BorderRadius.circular(60),
//                       imagePath: imageUrl,
//                     ),
//
//                     // Verified tick at top right
//                     Positioned(
//                       bottom: 10,
//                       right: 5,
//                       child: Image.asset(
//                         status == "online"
//                             ? ImageConstant.onlineMark
//                             : ImageConstant.offlineMark,
//                         width: 15,
//                         height: 15,
//                       ),
//                     ),
//
//                     // Rating container at bottom center, half over the image
//                     Positioned(
//                       bottom: -2,
//                       left: 0,
//                       right: 0,
//                       child: Center(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.yellow,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             isCall ? "* 4.2" : "* 3.4",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               status != "online"
//                   ? Text("Wait-5min", style: TextStyle(color: Colors.red))
//                   : Text("Online", style: TextStyle(color: Colors.green)),
//             ],
//           ),
//           const SizedBox(width: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(name, style: TextStyles.bodyText2),
//               SizedBox(
//                 width: screenWidth * 0.3,
//                 child: Text(
//                   position,
//                   style: TextStyles.bodyText5,
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//               ),
//               SizedBox(
//                 width: screenWidth * 0.28,
//                 child: Text(language, style: TextStyles.bodyText5),
//               ),
//               Text("₹$charge/min", style: TextStyles.bodyText5),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               isPopular
//                   ? Image.asset(
//                     ImageConstant.popularAstro,
//                     width: screenWidth * 0.28,
//                     height: screenHeight * 0.05,
//                   )
//                   : Container(),
//               isCall == true
//                   ? status != "online"
//                       ? Container(
//                         margin: EdgeInsets.symmetric(horizontal: 8),
//                         width: screenWidth * 0.22,
//                         height: screenHeight * 0.04,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.red),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: ElevatedButton.icon(
//                           onPressed: () {},
//                           icon: const Icon(Icons.call, size: 16),
//                           label: const Text(
//                             "Call",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.red,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.red,
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             textStyle: const TextStyle(fontSize: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                         ),
//                       )
//                       : Container(
//                         margin: EdgeInsets.symmetric(horizontal: 8),
//                         width: screenWidth * 0.22,
//                         height: screenHeight * 0.04,
//                         child: ElevatedButton.icon(
//                           onPressed: onPressed,
//                           icon: const Icon(Icons.call, size: 16),
//                           label: const Text(
//                             "Call",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             textStyle: const TextStyle(fontSize: 12),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                         ),
//                       )
//                   : status != "online"
//                   ? Container(
//                     margin: EdgeInsets.symmetric(horizontal: 8),
//                     width: screenWidth * 0.22,
//                     height: screenHeight * 0.04,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.red),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         // Get.snackbar(
//                         //   "Wait",
//                         //   "Please Wait For Astrologer To Come Online",
//                         //   backgroundColor: CupertinoColors.systemYellow,
//                         //   colorText: Colors.white,
//                         // );
//                       },
//                       icon: const Icon(Icons.chat, size: 15),
//                       label: const Text(
//                         "Chat",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.red,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         textStyle: const TextStyle(fontSize: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   )
//                   : Container(
//                     margin: EdgeInsets.symmetric(horizontal: 8),
//                     width: screenWidth * 0.22,
//                     height: screenHeight * 0.04,
//                     child: ElevatedButton.icon(
//                       onPressed: onPressed,
//                       icon: const Icon(Icons.chat, size: 15),
//                       label: const Text(
//                         "Chat",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         textStyle: const TextStyle(fontSize: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
