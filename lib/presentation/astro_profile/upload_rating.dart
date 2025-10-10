import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showInAppReviewBottomSheet(
    BuildContext context, astrologerId, transactionId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => InAppReviewBottomSheet(
      astrologerId: astrologerId,
      transactionId: transactionId,
    ),
  );
}

class InAppReviewBottomSheet extends StatefulWidget {
  final String astrologerId;
  final String transactionId;
  const InAppReviewBottomSheet(
      {super.key, required this.astrologerId, required this.transactionId});

  @override
  InAppReviewBottomSheetState createState() => InAppReviewBottomSheetState();
}

class InAppReviewBottomSheetState extends State<InAppReviewBottomSheet> {
  final astrologersApi = Get.put(AstrologersApi());
  int _selectedRating = 0;
  final TextEditingController _messageController = TextEditingController();
  bool _isSubmitting = false;

  void _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a star rating.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final reviewData = {
      'rating': _selectedRating,
      'comment': _messageController.text.trim(),
    };
    astrologersApi.sendRatingReview(
        astrologerId: widget.astrologerId,
        comment: _messageController.text.trim(),
        rating: _selectedRating,
        transactionId: widget.transactionId);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thank you for your feedback!')),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            starIndex <= _selectedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () => setState(() {
            _selectedRating = starIndex;
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomPadding + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Rate Your Experience",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildStarRating(),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Leave a message (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
