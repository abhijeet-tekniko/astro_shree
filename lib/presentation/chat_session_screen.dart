import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../core/network/endpoints.dart';
import '../core/utils/themes/appThemes.dart';
import '../data/model/chat_session_model.dart';
import '../widget/app_bar/appbar_title.dart';
import '../widget/app_bar/custom_navigate_back_button.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ChatSessionsScreen extends StatefulWidget {
  const ChatSessionsScreen({super.key});

  @override
  State<ChatSessionsScreen> createState() => _ChatSessionsScreenState();
}

class _ChatSessionsScreenState extends State<ChatSessionsScreen> {
  final AstrologersApi controller = Get.put(AstrologersApi());

  @override
  void initState() {
    super.initState();
    controller.fetchChatSession();
  }

  String formatDuration(int? totalSeconds) {
    if (totalSeconds == null) return "--:--:--";
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}";
  }

  String formatISTTime(String? istTime) {
    if (istTime == null) return "--";
    try {
      final date = DateTime.parse(istTime);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (_) {
      return "--";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
        title: AppbarTitle(text: 'Chat Sessions'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomLoadingScreen());
        }

        final sessions = controller.chatSessionList.value;
        if (sessions == null || sessions.isEmpty) {
          return const Center(child: Text('No chat sessions found'));
        }

        return SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
          
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: session.astrologer?.profileImage != null
                        ? NetworkImage(EndPoints.imageBaseUrl+session.astrologer!.profileImage!)
                        : null,
                    child: session.astrologer?.profileImage == null
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                  title: Text(
                    session.astrologer?.name ?? "Unknown Astrologer",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        formatISTTime(session.startedAtIST),
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      // const SizedBox(height: 2),
                      // Text(
                      //   'End: ${formatISTTime(session.endedAtIST)}',
                      //   style: const TextStyle(fontSize: 14, color: Colors.black54),
                      // ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration: ${formatDuration(session.totalActiveDuration)}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Status: ${session.status?.toUpperCase() ?? 'UNKNOWN'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: session.status == 'active' ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatSessionDetailsScreen(id: session.sId.toString(),astroName: session.astrologer!.name.toString(),),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

// class ChatSessionsScreen extends StatefulWidget {
//   const ChatSessionsScreen({super.key});
//
//   @override
//   State<ChatSessionsScreen> createState() => _ChatSessionsScreenState();
// }
//
// class _ChatSessionsScreenState extends State<ChatSessionsScreen> {
//   final AstrologersApi controller = Get.put(AstrologersApi());
//
//   @override
//   void initState() {
//     controller.fetchChatSession();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomNavigationButton(
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
//         title:  AppbarTitle(text: 'Chat Sessions'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CustomLoadingScreen());
//         }
//         final chatSession = controller.chatSessionList.value;
//         if (chatSession == null || chatSession.isEmpty) {
//           return const Center(child: Text('No chat sessions found'));
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: chatSession.length,
//           itemBuilder: (context, index) {
//             final session = chatSession[index];
//             final date = DateTime.parse(session.startedAt.toString());
//             final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);
//             return Card(
//               elevation: 2,
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(16),
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.red[100],
//                   child: Icon(
//                     Icons.chat,
//                     color: Colors.red[700],
//                   ),
//                 ),
//                 title: Text(
//                   'Chat with ${session.astrologer?.name ?? "Unknown"}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 4),
//                     Text(
//                       formattedDate,
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Status: ${session.status.toString().toUpperCase()}',
//                       style: TextStyle(
//                         color: session.status == 'active' ? Colors.green : Colors.red,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 trailing: Icon(
//                   Icons.arrow_forward_ios,
//                   color: Colors.grey[600],
//                   size: 16,
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ChatSessionDetailsScreen(session: session),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

class ChatSessionDetailsScreen extends StatefulWidget {
  final String id;
  final String astroName;

  const ChatSessionDetailsScreen({super.key, required this.id, required this.astroName});

  @override
  State<ChatSessionDetailsScreen> createState() => _ChatSessionDetailsScreenState();
}

class _ChatSessionDetailsScreenState extends State<ChatSessionDetailsScreen> {
  final AstrologersApi controller = Get.find<AstrologersApi>();

  @override
  void initState() {
    controller.fetchChatMessageSession(sessionId: widget.id.toString()); // Assuming this method exists
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title:  AppbarTitle(text: widget.astroName.toString()),
        centerTitle: true,
      ),
      // appBar: AppBar(
      //   title: Text('Chat with ${}'),
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: Colors.blue[700],
      // ),
      body: Obx(() {
        if (controller.isChatLoading.value) {
          return const Center(child: CustomLoadingScreen());
        }
        final messages = controller.chatSessionMessage.value!.data; // Assuming this is a List<ChatMessage>
        if (messages == null || messages.isEmpty) {
          return const Center(child: Text('No messages found'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isUser = message.senderModel == 'User';
            final timestamp = DateTime.parse(message.timestamp.toString());
            final formattedTime = DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);

            return Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    // if (!isUser)
                    //   CircleAvatar(
                    //     radius: 20,
                    //     backgroundImage: message.sender?.profileImage != null
                    //         ? NetworkImage(EndPoints.imageBaseUrl+message.sender!.profileImage!)
                    //         : null,
                    //     child: message.sender?.profileImage == null
                    //         ? Text(message.sender?.name?[0] ?? 'A')
                    //         : null,
                    //   ),
                    // const SizedBox(width: 8),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFFFFCDD2) : Colors.white,
                          // color: isUser ? Colors.red[100] : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message??"",
                              style: TextStyle(
                                // color: isUser ? Colors.white : Colors.black87,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: Colors.black,
                                // color: isUser ? Colors.white70 : Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isUser)
                      const SizedBox(width: 8),
                    // if (isUser)
                    //   CircleAvatar(
                    //     radius: 20,
                    //     backgroundImage: message.sender?.profileImage != null
                    //         ? NetworkImage(EndPoints.imageBaseUrl+message.sender!.profileImage!)
                    //         : null,
                    //     child: message.sender?.profileImage == null
                    //         ? Text(message.sender?.name?[0] ?? 'U')
                    //         : null,
                    //   ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: isUser ? 0 : 44,
                //     right: isUser ? 44 : 0,
                //   ),
                //   child: CustomPaint(
                //     size: const Size(12, 8),
                //     painter: NotchPainter(isUser: isUser),
                //   ),
                // ),
              ],
            );
          },
        );
      }),
    );
  }
}

class NotchPainter extends CustomPainter {
  final bool isUser;

  NotchPainter({required this.isUser});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isUser ? Colors.red[700]! : Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isUser) {
      path.moveTo(0, 0);
      path.quadraticBezierTo(6, 8, 12, 0);
    } else {
      path.moveTo(0, 0);
      path.quadraticBezierTo(6, 8, 12, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}