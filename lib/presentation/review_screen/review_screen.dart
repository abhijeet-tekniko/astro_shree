import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  String _reviewText = '';
  int _rating = 0;

  void _submitReview() {
    print("Review: $_reviewText");
    print("Rating: $_rating stars");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Review submitted!')));
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        Icons.star,size: 40,
        color: index < _rating ? Colors.amber : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

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
          text: 'write your review',
          margin: EdgeInsets.only(left: screenWidth * 0.1),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Write your review here...',
              ),
              onChanged: (value) {
                _reviewText = value;
              },
            ),
            SizedBox(height: 20),
            Row(children: List.generate(5, (index) => _buildStar(index))),
            Spacer(),
            ElevatedButton(
              onPressed: _reviewText.isNotEmpty && _rating > 0
                  ? _submitReview
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text('Submit', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
