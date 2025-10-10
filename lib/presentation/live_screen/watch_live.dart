import 'dart:math';

import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:flutter/material.dart';

import '../../widget/custom_image_view.dart';

class WatchLiveScreen extends StatefulWidget {
  final int id;
  const WatchLiveScreen({super.key, required this.id});

  @override
  State<WatchLiveScreen> createState() => _WatchLiveScreenState();
}

class _WatchLiveScreenState extends State<WatchLiveScreen> {
  final TextEditingController _chatsController = TextEditingController();
  final List<Map<String, dynamic>> _chats = [];
  final Random _random = Random();

  Color getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(200),
      _random.nextInt(200),
      _random.nextInt(200),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final String username = message['username'] ?? 'Deepak';
    final String firstLetter =
        username.isNotEmpty ? username[0].toUpperCase() : '?';
    final String text = message['text'] ?? '';
    final Color dpColor = getRandomColor();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DP Circle
          CircleAvatar(
            backgroundColor: dpColor,
            child: Text(firstLetter, style: TextStyle(color: Colors.white)),
          ),
          SizedBox(width: 10),
          // Message content
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(
                  0.3,
                ), // Half-transparent background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(text, style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _chatsController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _chats.add({'text': text, 'username': 'Deepak'});
    });

    _chatsController.clear();
  }

  @override
  void initState() {
    super.initState();
    _chats.addAll([
      {'text': "hii"},
      {'text': "hii"},
      {'text': "hii"},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          /// Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.liveAstroFullScreen),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 5, top: 40, right: 20),
            height: screenHeight * 0.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with LIVE tag in center
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageView(
                        height: screenHeight * 0.09,
                        width: screenWidth * 0.20,
                        radius: BorderRadius.circular(50),
                        imagePath: ImageConstant.liveAstroProfile,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Astrologer Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.language, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'English, Hindi',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.person, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            '3681',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Time and close icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(height: 8),
                        Text(
                          'Call Time',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '02:30',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Icon(Icons.close, color: Colors.red, size: 30),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Arrow
          /// Arrows Positioned at Center of Screen Height
          Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.black26,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          /// Chat Builder
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: screenHeight * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: _chats.length,
                      itemBuilder: (context, index) {
                        return _buildMessage(_chats[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Message input
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatsController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: "Type a message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: IconButton(
                          icon: Transform.rotate(
                            angle: 0.7,
                            child: Icon(Icons.attach_file),
                          ),
                          onPressed: () {},
                        ),

                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _chatsController.text.trim().isEmpty
                      ? Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo[400],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.mic),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      )
                      : IconButton(
                        icon: Icon(Icons.send),
                        color: Colors.blue,
                        onPressed: _sendMessage,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
