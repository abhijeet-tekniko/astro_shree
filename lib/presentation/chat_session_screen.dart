import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
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
                        builder: (_) => ChatSessionDetailsScreen(sessionId: session.sId.toString()),
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

// class _ChatSessionDetailsScreenState extends State<ChatSessionDetailsScreen> {
//   final AstrologersApi controller = Get.find<AstrologersApi>();
//
//   @override
//   void initState() {
//     controller.fetchChatMessageSession(sessionId: widget.id.toString()); // Assuming this method exists
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
//         title:  AppbarTitle(text: widget.astroName.toString()),
//         centerTitle: true,
//       ),
//       // appBar: AppBar(
//       //   title: Text('Chat with ${}'),
//       //   centerTitle: true,
//       //   elevation: 0,
//       //   backgroundColor: Colors.blue[700],
//       // ),
//       body: Obx(() {
//         if (controller.isChatLoading.value) {
//           return const Center(child: CustomLoadingScreen());
//         }
//         final messages = controller.chatSessionMessage.value!.data; // Assuming this is a List<ChatMessage>
//         if (messages == null || messages.isEmpty) {
//           return const Center(child: Text('No messages found'));
//         }
//         return ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: messages.length,
//           itemBuilder: (context, index) {
//             final message = messages[index];
//             final isUser = message.senderModel == 'User';
//             final timestamp = DateTime.parse(message.timestamp.toString());
//             final formattedTime = DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);
//
//             return Column(
//               crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//                   children: [
//                     // if (!isUser)
//                     //   CircleAvatar(
//                     //     radius: 20,
//                     //     backgroundImage: message.sender?.profileImage != null
//                     //         ? NetworkImage(EndPoints.imageBaseUrl+message.sender!.profileImage!)
//                     //         : null,
//                     //     child: message.sender?.profileImage == null
//                     //         ? Text(message.sender?.name?[0] ?? 'A')
//                     //         : null,
//                     //   ),
//                     // const SizedBox(width: 8),
//                     Flexible(
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isUser ? const Color(0xFFFFCDD2) : Colors.white,
//                           // color: isUser ? Colors.red[100] : Colors.grey[300],
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(12),
//                             topRight: const Radius.circular(12),
//                             bottomLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
//                             bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(12),
//                           ),
//                         ),
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.65,
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               message.message??"",
//                               style: TextStyle(
//                                 // color: isUser ? Colors.white : Colors.black87,
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               formattedTime,
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 // color: isUser ? Colors.white70 : Colors.grey[600],
//                                 fontSize: 10,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     if (isUser)
//                       const SizedBox(width: 8),
//                     // if (isUser)
//                     //   CircleAvatar(
//                     //     radius: 20,
//                     //     backgroundImage: message.sender?.profileImage != null
//                     //         ? NetworkImage(EndPoints.imageBaseUrl+message.sender!.profileImage!)
//                     //         : null,
//                     //     child: message.sender?.profileImage == null
//                     //         ? Text(message.sender?.name?[0] ?? 'U')
//                     //         : null,
//                     //   ),
//                   ],
//                 ),
//                 // Padding(
//                 //   padding: EdgeInsets.only(
//                 //     left: isUser ? 0 : 44,
//                 //     right: isUser ? 44 : 0,
//                 //   ),
//                 //   child: CustomPaint(
//                 //     size: const Size(12, 8),
//                 //     painter: NotchPainter(isUser: isUser),
//                 //   ),
//                 // ),
//               ],
//             );
//           },
//         );
//       }),
//     );
//   }
// }

class ChatSessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const ChatSessionDetailsScreen({super.key, required this.sessionId});

  @override
  State<ChatSessionDetailsScreen> createState() =>
      _ChatSessionDetailsScreenState();
}

class _ChatSessionDetailsScreenState extends State<ChatSessionDetailsScreen> {
  final AstrologersApi controller = Get.put(AstrologersApi());

  @override
  void initState() {
    controller.fetchChatMessageSession(sessionId: widget.sessionId.toString());
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
        title:  AppbarTitle(text: "Detailed Chat"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isChatLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final messages = controller.chatSessionMessage.value!.data;
        if (messages == null || messages.isEmpty) {
          return const Center(child: Text('No messages found'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isAstro = message.senderModel == 'Astrologer';
            final media = message.media;
            final timestamp = DateTime.parse(message.createdAtIST.toString());
            final formattedTime =
            DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp);

            return Column(
              crossAxisAlignment:
              isAstro ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  isAstro ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isAstro
                              ? Colors.red.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isAstro
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            bottomRight: isAstro
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.65,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (message.message != null)
                              Text(
                                message.message ?? "",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            if (media != null && media.isNotEmpty) ...[
                              SizedBox(height: 5),
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: media.map((m) {
                                  final url =
                                      'http://167.71.232.245:4856/${m.url}';
                                  if (m.type == 'image') {
                                    print(url);
                                    return GestureDetector(
                                      onTap: () => _launchURL(url),
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error,
                                                color: Colors.red),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () => _launchURL(url),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          m.fileName ?? "",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 4),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isAstro) const SizedBox(width: 8),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file')),
      );
    }
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