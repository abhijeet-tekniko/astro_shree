import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../widget/custom_image_view.dart';
import '../core/network/endpoints.dart';
import '../data/model/banner_model.dart';

class BannerCarouselSlider extends StatelessWidget {
  final List<BannerData> banners;
  final bool autoPlay;
  final double height;
  final BoxFit imageFit;
  final double horizontalPadding;
  final double? verticalPadding;

  const BannerCarouselSlider({
    super.key,
    required this.banners,
    this.autoPlay = true,
    this.height = 105,
    this.imageFit = BoxFit.contain,
    this.horizontalPadding = 5,
    this.verticalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding ?? 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: height,
          autoPlay: autoPlay,
          enlargeCenterPage: true,
          viewportFraction: 1,
        ),
        items: banners.map((banner) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageView(
              imagePath: (EndPoints.imageBaseUrl + banner.image!),
              fit: imageFit,
              width: double.infinity,
              onTap: () {
                // handleRedirect(banner.redirectPage ?? "none",
                //     id: banner.redirectId);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
