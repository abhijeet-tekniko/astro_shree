import 'package:astro_shree_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../socket_services.dart';

class ChatSummaryScreen extends StatefulWidget {
  final Duration chatDuration;
  final String astrologerName;
  final String astrologerId;
  final String astrologerImage;
  final double availableBalance;
  final double ratePerMinute; // Example rate, adjust as needed

  ChatSummaryScreen({
    required this.chatDuration,
    required this.astrologerName,
    required this.astrologerId,
    required this.astrologerImage,
    required this.availableBalance,
    required this.ratePerMinute,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatSummaryScreen> createState() => _ChatSummaryScreenState();
}

class _ChatSummaryScreenState extends State<ChatSummaryScreen> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  double _calculateUtilizedBalance() {
    // Calculate cost based on duration (in minutes) and rate
    final minutes = widget.chatDuration.inSeconds / 60.0;
    return minutes * widget.ratePerMinute;
  }

  void _chatAgain() {
    // Re-initiate chat request with the same astrologer
    SocketService.sendChatRequest(
      widget.astrologerId,
      'User Name', // Replace with actual user data
      'Male', // Replace with actual user data
      '1990-01-01', // Replace with actual DOB
      '12:00', // Replace with actual time of birth
      'Unknown', // Replace with actual place of birth
    );
  }

  void _exploreMore() {
    // Navigate to home or astrologer list screen
    Get.offAllNamed(AppRoutes.homeScreen); // Adjust route as per your app
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final utilizedBalance = _calculateUtilizedBalance();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC62828),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Chat Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF8E1E1),
              Color(0xFFFFF0F0),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.astrologerImage),
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Chat with ${widget.astrologerName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryItem(
                      'Chat Duration',
                      _formatDuration(widget.chatDuration),
                    ),
                    _buildSummaryItem(
                      'Available Balance',
                      currencyFormat.format(widget.availableBalance),
                    ),
                    _buildSummaryItem(
                      'Utilized Balance',
                      currencyFormat.format(utilizedBalance),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 140,
                          child: ElevatedButton(
                            onPressed: _chatAgain,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC62828),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Chat Again',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 140,
                          child: OutlinedButton(
                            onPressed: _exploreMore,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFC62828),
                              side: const BorderSide(color: Color(0xFFC62828)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Explore More',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}