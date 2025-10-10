import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/presentation/newChatScreen.dart';
import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api_call/astrologers_api.dart';
import '../data/model/active_session_model.dart';

// class ActiveSessionFAB extends StatelessWidget {
//   final ActiveSessionModel session;
//
//   const ActiveSessionFAB({Key? key, required this.session}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () => _showSessionDetails(context),
//       backgroundColor: Colors.red.shade800,
//       child: const Icon(Icons.chat_bubble, color: Colors.white),
//       elevation: 6,
//       tooltip: 'View Active Session',
//     );
//   }
//
//   void _showSessionDetails(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       builder: (context) => DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         maxChildSize: 0.9,
//         minChildSize: 0.5,
//         expand: false,
//         builder: (context, scrollController) => SingleChildScrollView(
//           controller: scrollController,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Active Session Details',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Status and Active
//                 _buildInfoCard(
//                   'Status',
//                   session.status != null
//                       ? session.status! ? 'Success' : 'Failed'
//                       : 'N/A',
//                   icon: Icons.info,
//                 ),
//                 _buildInfoCard(
//                   'Active',
//                   session.active != null
//                       ? session.active! ? 'Yes' : 'No'
//                       : 'N/A',
//                   icon: Icons.toggle_on,
//                 ),
//
//                 // Message
//                 if (session.message != null)
//                   _buildInfoCard('Message', session.message!, icon: Icons.message),
//
//                 // Session Data
//                 if (session.data != null) ...[
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Session Information',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   _buildInfoCard(
//                     'Session ID',
//                     session.data!.chatSessionId ?? 'N/A',
//                     icon: Icons.confirmation_number,
//                   ),
//                   _buildInfoCard(
//                     'Type',
//                     session.data!.type ?? 'N/A',
//                     icon: Icons.category,
//                   ),
//                   _buildInfoCard(
//                     'Started At',
//                     session.data!.startedAt ?? 'N/A',
//                     icon: Icons.timer,
//                   ),
//                   _buildInfoCard(
//                     'Duration',
//                     session.data!.durationMinutes != null
//                         ? '${session.data!.durationMinutes} minutes'
//                         : 'N/A',
//                     icon: Icons.hourglass_empty,
//                   ),
//                   _buildInfoCard(
//                     'Remaining Time',
//                     session.data!.remainingTime != null
//                         ? '${session.data!.remainingTime} minutes'
//                         : 'N/A',
//                     icon: Icons.hourglass_bottom,
//                   ),
//
//                   // User Information
//                   if (session.data!.user != null) ...[
//                     const SizedBox(height: 16),
//                     const Text(
//                       'User',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                     _buildUserCard(session.data!.user!),
//                   ],
//
//                   // Astrologer Information
//                   if (session.data!.astrologer != null) ...[
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Astrologer',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                     _buildUserCard(session.data!.astrologer!),
//                   ],
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoCard(String title, String value, {required IconData icon}) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.deepPurple),
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Text(value),
//       ),
//     );
//   }
//
//   Widget _buildUserCard(User user) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         leading: CircleAvatar(
//           radius: 24,
//           backgroundImage: user.profileImage != null
//               ? NetworkImage(user.profileImage!)
//               : null,
//           backgroundColor: Colors.grey[200],
//           child: user.profileImage == null
//               ? const Icon(Icons.person, color: Colors.grey)
//               : null,
//         ),
//         title: Text(
//           user.name ?? 'N/A',
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         subtitle: Text('ID: ${user.sId ?? 'N/A'}'),
//       ),
//     );
//   }
// }


class ActiveSessionFAB extends StatefulWidget {
  final ActiveSessionModel session;

  const ActiveSessionFAB({Key? key, required this.session}) : super(key: key);

  @override
  State<ActiveSessionFAB> createState() => _ActiveSessionFABState();
}

class _ActiveSessionFABState extends State<ActiveSessionFAB> {

  final astrologersApi = Get.put(AstrologersApi());
  @override
  Widget build(BuildContext context) {
    final astrologer = widget.session.data!.astrologer;
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: Colors.red.shade800,
      child: GestureDetector(
        onTap: () {


          // Navigate to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatNewwScreen(
                chatSessionId: widget.session.data!.chatSessionId ?? '',
                astrologerName: widget.session.data!.astrologer?.name ?? '',
                astrologerId: widget.session.data!.astrologer?.sId ?? '',
                astrologerImage:  EndPoints.imageBaseUrl +widget.session.data!.astrologer!.profileImage.toString() ?? '',
                maxDuartion: widget.session.data!.remainingTime.toString() ?? '',
                // chatPrice: 10,
              ),
            ),
          );
        },
        child: Container(
          width: 150, // Set custom width for FAB
          height: 56, // Standard FAB height
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Astrologer image and name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: astrologer?.profileImage != null
                        ? NetworkImage(EndPoints.imageBaseUrl + astrologer!.profileImage!)
                        : null,
                    backgroundColor: Colors.grey[200],
                    child: astrologer?.profileImage == null
                        ? const Icon(Icons.person, color: Colors.grey, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      astrologer?.name ?? 'Astrologer',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14, // Slightly larger font for clarity
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // End session button (top-right corner)
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _endSession(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _endSession(BuildContext context) {

    astrologersApi.activeSessionData.value = ActiveSessionModel(); // Clear session
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session'),
        content: const Text('Are you sure you want to end this session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement end session logic (e.g., API call)
              Navigator.pop(context);

              SocketService.endChatSession(astrologersApi.activeSessionData.value.data!.chatSessionId.toString());
            },
            child: const Text('End Session', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}