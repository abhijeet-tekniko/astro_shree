import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/core/utils/navigator_service.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:astro_shree_user/widget/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_call/blog_api.dart';
import 'blog_detailed_screen.dart';

class BlogListScreen extends StatelessWidget {
  BlogListScreen({super.key});
  final BlogApi blogApi = Get.put(BlogApi());
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
        title: AppbarTitle(
          text: 'Blog',
          margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await blogApi.fetchBlogs();
        },
        child: Obx(() {
          return blogApi.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  height: screenHeight,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: blogApi.blogs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final blog = blogApi.blogs[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  NavigatorService.pushNamed(
                                    AppRoutes.blogDetailedScreen,
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: CustomImageView(
                                          imagePath: blog.thumbImage,
                                          height: screenHeight * 0.15,
                                          width: screenWidth * 1,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        // Responsive padding
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    blog.title,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.05,
                                                        width:
                                                            screenWidth * 0.55,
                                                        child: Text(
                                                          blog.description,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.grey),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                            () =>
                                                                BlogDetailedScreen(
                                                              blog: blog,
                                                            ),
                                                          );
                                                        },
                                                        child: RichText(
                                                          text: TextSpan(
                                                            text: 'Read ',
                                                            style: TextStyles
                                                                .bodyText2
                                                                .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                text:
                                                                    'full blog',
                                                                style: TextStyles
                                                                    .bodyText2
                                                                    .copyWith(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        }),
      ),
    );
  }
}
