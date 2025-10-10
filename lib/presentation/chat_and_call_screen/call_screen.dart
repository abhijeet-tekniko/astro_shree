import 'dart:async';
import 'dart:ui';

import 'package:astro_shree_user/core/utils/image_constant.dart';
import 'package:astro_shree_user/data/model/astrologers_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/endpoints.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/api_call/voice_call_controller.dart';
import '../../widget/custom_image_view.dart';

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../socket_services.dart';

class CallScreen extends StatefulWidget {
  final String profileImage;
  final String name;
  final String id;
  // final Astrologer astro;
  const CallScreen(
      {super.key,
      required this.profileImage,
      required this.name,
      required this.id});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  Timer? _timer;
  int callDuration = 0;

  final VoiceCallController controller = Get.put(VoiceCallController());

  @override
  void initState() {
    super.initState();

    // Start listening to callStatus changes
    ever(controller.callStatus, (status) {
      if (status == 'active') {
        _startCallTimer();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.sendVoiceCallRequest(widget.id);
      _watchCallStatus();
    });
  }

  void _watchCallStatus() {
    ever(controller.callStatus, (status) {
      if (status == 'active') {
        _startCallTimer();
      } else if (status == 'ended' || status == 'rejected') {
        _stopCallTimer();
        Get.back();
      }
    });
  }

  final ProfileApi profileApi = Get.put(ProfileApi());

  void _startCallTimer() {
    _timer?.cancel(); // Cancel any previous timer if exists
    callDuration = 0;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        callDuration++;
      });
    });
  }
  // void _startCallTimer() {
  //   _stopCallTimer(); // clear existing timer
  //   callDuration = 0;
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       callDuration += 1;
  //     });
  //   });
  // }

  void _stopCallTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _endCall() {
    // SocketService.respondChatRequest('reject',profileApi.userProfile.value!.id.toString(),widget.id);

    controller.endVoiceCallSession(true, widget.id);
  }

  @override
  void dispose() {
    _stopCallTimer();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    EndPoints.base + widget.profileImage.toString()),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          Center(
            child: Obx(() {
              final status = controller.callStatus.value;
              print('staus=====$status');
              final isActive = status == 'active';
              final displayText =
                  isActive ? _formatDuration(callDuration) : 'Ringing...';

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.25),
                    child: CustomImageView(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      height: screenHeight * 0.2,
                      radius: BorderRadius.circular(60),
                      imagePath:
                          EndPoints.base + widget.profileImage.toString(),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.25),
                    child: Text(
                      isActive
                          ? 'In Call with ${widget.name}'
                          : 'Calling ${widget.name}...',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -screenHeight * 0.25),
                    child: Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, screenHeight * 0.25),
                    child: InkWell(
                      onTap: _endCall,
                      child: Container(
                        height: screenHeight * 0.08,
                        width: screenHeight * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
