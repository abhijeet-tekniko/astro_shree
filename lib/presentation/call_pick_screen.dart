import 'dart:async';

import 'package:astro_shree_user/presentation/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../core/utils/image_constant.dart';
import '../data/api_call/astrologers_api.dart';
import '../data/api_call/profile_api.dart';

class CallPickScreen extends StatefulWidget {
  final String callerName;
  final String callType;
  final String profileImage;
  final String astroId;

  const CallPickScreen({
    super.key,
    required this.callerName,
    required this.callType,
    required this.profileImage,
    required this.astroId,
  });

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallPickScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AudioPlayer player;
  Timer? timeoutTimer;
  bool _isScreenActive = true;
  bool _dialogShown = false;
  String chatSocketId = '';
  bool isRinging = true;

  final astrologersApi = Get.put(AstrologersApi());
  final profileApi = Get.put(ProfileApi());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    player = AudioPlayer();

    if (widget.callType == 'chat') {
      SocketService.on('chatRequestSent', _handleChatRequestSent);
    }

    _playRingingSound();
    _startTimeoutTimer();
  }

  void _handleChatRequestSent(dynamic data) {
    chatSocketId = data["chatRequestId"];
  }

  void _startTimeoutTimer() {
    timeoutTimer = Timer(const Duration(seconds: 60), () async {
      if (!_isScreenActive || !mounted) return;

      try {
        await astrologersApi.notRespondAstrologer(chatId: chatSocketId);
      } catch (e) {
        debugPrint("API Error: $e");
      }

      if (!_dialogShown && mounted) {
        _dialogShown = true;
        _handleReject(); // safely handles cleanup
        _showNotAvailableDialog();
      }
    });
  }

  void _showNotAvailableDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Astrologer Not Available'),
        content: const Text(
            'The astrologer did not respond in time. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _playRingingSound() async {
    try {
      await player.setAsset('assets/audio/callingRing.mp3');
      await player.play();
    } catch (e) {
      debugPrint('Ringtone Error: $e');
    }
  }

  Future<void> _stopRingingSound() async {
    try {
      await player.stop();
    } catch (e) {
      debugPrint('Stop ringtone failed: $e');
    }
  }

  void _handleRequest(String action) {
    if (widget.callType == 'chat') {
      SocketService.respondChatRequest(
          "notRespond",
          profileApi.userProfile.value!.id.toString(),
          widget.astroId);
    } else {
      SocketService.respondChatRequest(
        action,
        profileApi.userProfile.value!.id.toString(),
        widget.astroId,
      );
    }
  }

  void _handleAccept() {
    _isScreenActive = false;
    timeoutTimer?.cancel();
    _stopRingingSound();
    _handleRequest('accept');
    setState(() => isRinging = false);

    // navigate to chat or call screen if needed
  }

  void _handleReject() {
    _isScreenActive = false;
    timeoutTimer?.cancel();
    _stopRingingSound();
    _handleRequest('reject');

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _isScreenActive = false;
    timeoutTimer?.cancel();
    _controller.dispose();
    player.dispose();
    _stopRingingSound();
    SocketService.off('chatRequestSent', _handleChatRequestSent);
    super.dispose();
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, size: 30, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF221217),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstant.imgSplash),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 335.0),
            child: const Text(
              'AstroShree',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC62828),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isRinging ? _animation.value : 1.0,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: widget.profileImage.isNotEmpty
                                ? NetworkImage(widget.profileImage)
                                : null,
                            backgroundColor: Colors.grey[300],
                            child: widget.profileImage.isEmpty
                                ? const Icon(Icons.person, size: 60, color: Colors.white)
                                : null,
                          ),
                        );
                      },
                    ),
                    Text(
                      widget.callerName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isRinging ? 'Ringing...' : 'Connecting...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.callType.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      icon: Icons.call_end,
                      color: Colors.red,
                      onPressed: _handleReject,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// class _CallScreenState extends State<CallPickScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   bool isRinging = true;
//   late AudioPlayer player;
//   Timer? timeoutTimer;
//   final AstrologersApi astrologersApi = Get.put(AstrologersApi());
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     )..repeat(reverse: true);
//     _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//
//     if(widget.callType=='chat'){
//       SocketService.on('chatRequestSent', _handleChatRequestSent);
//     }
//
//
//
//     player = AudioPlayer();
//     _playRingingSound();
//     startTimeoutTimer();
//   }
//
//   String chatSocketId='';
//
//   void _handleChatRequestSent(dynamic data) {
//     chatSocketId=data["chatRequestId"];
//     setState(() {
//
//     });
//
//   }
//   void startTimeoutTimer() {
//     timeoutTimer = Timer(const Duration(seconds: 60), () {
//       // API call to mark astrologer as not responding
//       astrologersApi.notRespondAstrologer(chatId: chatSocketId);
//
//       // _handleRequest('reject');
//
//       // Close the current screen
//       if (mounted) {
//         _handleReject();
//         // Navigator.pop(context);
//
//         // Show dialog to user
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Astrologer Not Available'),
//             content: const Text(
//               'The astrologer did not respond in time. Please try again later.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('OK', style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           ),
//         );
//       }
//     });
//   }
//
//
//   Future<void> _playRingingSound() async {
//     try {
//       await player.setAsset('assets/audio/callingRing.mp3');
//       await player.play();
//     } catch (e) {
//       print('Error playing ringtone: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to play ringtone')),
//       );
//     }
//   }
//
//   Future<void> _stopRingingSound() async {
//     try {
//       await player.stop();
//     } catch (e) {
//       print('Error stopping ringtone: $e');
//     }
//   }
//
//   final ProfileApi profileApi = Get.put(ProfileApi());
//
//   void _handleRequest(String action,/*String chatSessionId,String astrologerId*/) {
//
// if(widget.callType=='chat'){
//   SocketService.respondChatRequest('reject',profileApi.userProfile.value!.id.toString(),widget.astroId);
//
// }else if(widget.callType=='video'){
//   // Get.back();
//   SocketService.respondChatRequest('reject',profileApi.userProfile.value!.id.toString(),widget.astroId);
// }else{
//   Get.back();
// }
//     // final request = SocketService.to.chatRequests.firstWhereOrNull(
//     //       (req) => req['type'] == widget.callType && req['status'] == 'pending',
//     // );
//     // SocketService.respondChatRequest(action, chatSessionId, astrologerId);
//     // Get the latest request that matches the callType
//     // final request = SocketService.to.chatRequests.firstWhereOrNull(
//     //       (req) => req['type'] == widget.callType && req['status'] == 'pending',
//     // );f
//     // if (request != null) {
//     //   if (widget.callType == 'chat') {
//     //     SocketService.respondChatRequest(request['_id'], action);
//     //   } else {
//     //     SocketService.respondVideoCallRequest(request['_id'], action);
//     //   }
//     // } else {
//     //   ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text('No pending request found')),
//     //   );
//     //   Navigator.pop(context);
//     // }
//   }
//
//   void _handleAccept() {
//     setState(() {
//       isRinging = false;
//     });
//     _stopRingingSound();
//     _handleRequest('accept');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Call Accepted')),
//     );
//   }
//
//   void _handleReject() {
//     timeoutTimer?.cancel(); // Cancel timer
//     setState(() {
//       isRinging = false;
//     });
//     _stopRingingSound();
//     _handleRequest('reject');
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Call Rejected')),
//     );
//   }
//
//   @override
//   void dispose() {
//     timeoutTimer?.cancel();
//     _controller.dispose();
//     player.stop();
//     player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: const Color(0xFF221217),
//       body: SafeArea(
//         child:  Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: screenWidth,
//               height: screenHeight,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage( ImageConstant.imgSplash),
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top:335.0),
//               child: Text('AstroShree',style: TextStyle(fontSize: 42,fontWeight: FontWeight.bold,color: Color(0xFFC62828)),),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 40.0),
//                   child: Column(
//                     children: [
//                       AnimatedBuilder(
//                         animation: _animation,
//                         builder: (context, child) {
//                           return Transform.scale(
//                             scale: isRinging ? _animation.value : 1.0,
//                             child: CircleAvatar(
//                               radius: 60,
//                               backgroundImage: widget.profileImage.isNotEmpty
//                                   ? NetworkImage(widget.profileImage)
//                                   : null,
//                               backgroundColor: Colors.grey[300],
//                               child: widget.profileImage.isEmpty
//                                   ? const Icon(Icons.person, size: 60, color: Colors.white)
//                                   : null,
//                             ),
//                           );
//                         },
//                       ),
//                       // const SizedBox(height: 20),
//                       Text(
//                         widget.callerName,
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         isRinging ? 'Ringing...' : 'Connecting...',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         widget.callType.toUpperCase(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.teal,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 40.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildActionButton(
//                         icon: Icons.call_end,
//                         color: Colors.red,
//                         // label: 'Reject',
//                         label: '',
//                         onPressed: _handleReject,
//                       ),
//                       // _buildActionButton(
//                       //   icon: Icons.call,
//                       //   color: Colors.green,
//                       //   label: 'Accept',
//                       //   onPressed: _handleAccept,
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//         ///
//         // child: Column(
//         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //   children: [
//         //     Padding(
//         //       padding: const EdgeInsets.only(top: 40.0),
//         //       child: Column(
//         //         children: [
//         //           AnimatedBuilder(
//         //             animation: _animation,
//         //             builder: (context, child) {
//         //               return Transform.scale(
//         //                 scale: isRinging ? _animation.value : 1.0,
//         //                 child: CircleAvatar(
//         //                   radius: 60,
//         //                   backgroundImage: widget.profileImage.isNotEmpty
//         //                       ? NetworkImage(widget.profileImage)
//         //                       : null,
//         //                   backgroundColor: Colors.grey[300],
//         //                   child: widget.profileImage.isEmpty
//         //                       ? const Icon(Icons.person, size: 60, color: Colors.white)
//         //                       : null,
//         //                 ),
//         //               );
//         //             },
//         //           ),
//         //           const SizedBox(height: 20),
//         //           Text(
//         //             widget.callerName,
//         //             style: const TextStyle(
//         //               fontSize: 28,
//         //               fontWeight: FontWeight.bold,
//         //               color: Colors.white,
//         //             ),
//         //           ),
//         //           const SizedBox(height: 10),
//         //           Text(
//         //             isRinging ? 'Ringing...' : 'Connecting...',
//         //             style: TextStyle(
//         //               fontSize: 18,
//         //               color: Colors.grey[400],
//         //             ),
//         //           ),
//         //           const SizedBox(height: 10),
//         //           Text(
//         //             widget.callType.toUpperCase(),
//         //             style: const TextStyle(
//         //               fontSize: 16,
//         //               color: Colors.teal,
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: const EdgeInsets.only(bottom: 40.0),
//         //       child: Row(
//         //         mainAxisAlignment: MainAxisAlignment.center,
//         //         children: [
//         //           _buildActionButton(
//         //             icon: Icons.call_end,
//         //             color: Colors.red,
//         //             // label: 'Reject',
//         //             label: '',
//         //             onPressed: _handleReject,
//         //           ),
//         //           // _buildActionButton(
//         //           //   icon: Icons.call,
//         //           //   color: Colors.green,
//         //           //   label: 'Accept',
//         //           //   onPressed: _handleAccept,
//         //           // ),
//         //         ],
//         //       ),
//         //     ),
//         //   ],
//         // ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return Column(
//       children: [
//         FloatingActionButton(
//           onPressed: onPressed,
//           backgroundColor: color,
//           child: Icon(icon, size: 30, color: Colors.white),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//       ],
//     );
//   }
// }
