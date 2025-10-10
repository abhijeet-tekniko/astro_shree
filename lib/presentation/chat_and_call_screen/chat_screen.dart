import 'package:astro_shree_user/data/model/astrologers_model.dart';
import 'package:flutter/material.dart';

import '../../core/utils/themes/appThemes.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';

class ChatScreen extends StatefulWidget {
  final Astrologer astro;
  const ChatScreen({super.key, required this.astro});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isMe': true});
    });

    _messageController.clear();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({'text': 'Reply to: $text', 'isMe': false});
      });
    });
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    bool isMe = message['isMe'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message['text'],
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _messages.addAll([
      {'text': "What do you mean?", 'isMe': false},
      {
        'text': "I think the idea that things are changing isn't good",
        'isMe': true,
      },
      {'text': "What do you mean?", 'isMe': false},
      {
        'text': "I think the idea that things are changing isn't good",
        'isMe': true,
      },
      {'text': "What do you mean?", 'isMe': false},
      {
        'text': "I think the idea that things are changing isn't good",
        'isMe': true,
      },
      {'text': "What do you mean?", 'isMe': false},
    ]);
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
          text: widget.astro.name,
          margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),

          // Message Input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                /// 📎TODO: Attach Button

                // 📝 Text Input Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
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

                _messageController.text.trim().isEmpty
                    ? Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
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
        ],
      ),
    );
  }
}
