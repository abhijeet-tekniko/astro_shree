import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {


  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        "question": "How do I contact customer support?",
        "answer":
        "You can contact customer support through the chat feature in our app.",
      },
      {
        "question": "Where can I submit feedback about the app?",
        "answer":
        "You can submit feedback through the app settings or by emailing support.",
      },
      {
        "question": "How do I rate the app on the App Store or Google Play?",
        "answer":
        "You can rate the app by visiting the App Store or Google Play and leaving a review.",
      },
      {
        "question": "Is there a community forum for users?",
        "answer":
        "Yes, we have a community forum available in the app where users can discuss issues.",
      },
      {
        "question": "Why am I not receiving notifications?",
        "answer":
        "Make sure notifications are enabled in your phone's settings and in the app.",
      },
    ];
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
        title:  AppbarTitle(
          text: 'Support',
          margin: EdgeInsets.only(left:screenWidth * 0.2),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child:Container(
                padding: EdgeInsets.only(left:20,right:20,bottom: 20),
                child: Column(
                  children: [
                    Text('Tell us how we can help',style: TextStyles.bodyText2,),
                    SizedBox(height: screenHeight * 0.01,),
                    Text('Our experts of superheroes are standing by for services & support!',style:TextStyles.bodyText3),
                  ],
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black87),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(//todo fix indecator color
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildFAQTile(
                      index + 1,
                      faqList[index]["question"]!,
                      faqList[index]["answer"]!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFAQTile(int index, String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          "$index. $question",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
