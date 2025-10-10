import '../../core/utils/themes/appThemes.dart';
import '../../core/utils/themes/textStyle.dart';
import '../../core/utils/url_launcher/url_launcher.dart';
import '../../data/model/blog_model.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import 'package:flutter/cupertino.dart' as dom;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/custom_image_view.dart';

class BlogDetailedScreen extends StatefulWidget {
  final Blog blog;
  const BlogDetailedScreen({super.key, required this.blog});

  @override
  State<BlogDetailedScreen> createState() => _BlogDetailedScreenState();
}

class _BlogDetailedScreenState extends State<BlogDetailedScreen> {
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
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CustomImageView(
                  imagePath: widget.blog.thumbImage,
                  width: screenWidth,
                  height: screenHeight*0.2,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.blog.title,
                              style: TextStyles.bodyText2,
                            ),
                          ),
                          Html(
                            data: widget.blog.description,
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
    );
  }
}
