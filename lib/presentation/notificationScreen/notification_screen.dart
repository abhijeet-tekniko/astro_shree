import 'package:flutter/material.dart';

import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        title: AppbarTitle(
          text: 'Notification',
          margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      body: Center(
        child: Text('No data found'),
      ),
    );
  }
}
