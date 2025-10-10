import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../core/network/endpoints.dart';
import '../core/utils/image_constant.dart';
import '../data/model/banner_model.dart';

class BannerWidget extends StatelessWidget {
  final List<BannerData> imagePaths;
  final bool? autoPlay;

  const BannerWidget({
    super.key,
    required this.imagePaths,
    this.autoPlay = false,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade300,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CarouselSlider.builder(
          itemCount: imagePaths.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Image.network(
              EndPoints.imageBaseUrl + imagePaths[index].image.toString(),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  ImageConstant.Temp1banner,
                  fit: BoxFit.cover,
                );
              },
            );
          },
          options: CarouselOptions(
            height: 120,
            viewportFraction: 1.0,
            autoPlay: autoPlay!,
            autoPlayInterval: Duration(seconds: 3),
          ),
        ),
      ),
    );
  }
}

///15.8
// class BannerWidget extends StatefulWidget {
//   final List<BannerData> imagePaths;
//   final bool? autoPlay;
//
//   const BannerWidget(
//       {super.key, required this.imagePaths, this.autoPlay = false});
//
//   @override
//   _BannerWidgetState createState() => _BannerWidgetState();
// }
//
// class _BannerWidgetState extends State<BannerWidget> {
//   int activeIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: 15, right: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.red.shade300,
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: Offset(0, 3),
//           ),
//           BoxShadow(
//             color: Colors.white,
//             spreadRadius: 0,
//             blurRadius: 0,
//             offset: Offset(0, 0),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: CarouselSlider.builder(
//           itemCount: widget.imagePaths.length,
//           itemBuilder: (BuildContext context, int index, int realIndex) {
//             return Image.network(
//               EndPoints.imageBaseUrl +
//                   widget.imagePaths[index].image.toString(),
//               fit: BoxFit.cover,
//               width: MediaQuery.of(context).size.width,
//               // fills the entire area properly
//               errorBuilder: (context, error, stackTrace) {
//                 return Image.asset(
//                   ImageConstant.Temp1banner,
//                   fit: BoxFit.cover,
//                 );
//               },
//             );
//           },
//           options: CarouselOptions(
//             height: 120,
//             viewportFraction: 1.0,
//             autoPlay: widget.autoPlay!,
//             autoPlayInterval: Duration(seconds: 3),
//             onPageChanged: (index, reason) {
//               setState(() {
//                 activeIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
