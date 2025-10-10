import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/presentation/live_screen/user_live_controller.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class UserLiveScreen extends StatefulWidget {
  final String liveSessionId;
  final String userId;
  final String astroId;

  const UserLiveScreen({
    required this.liveSessionId,
    required this.userId,
    super.key,
    required this.astroId,
  });

  @override
  _UserLiveScreenState createState() => _UserLiveScreenState();
}

class _UserLiveScreenState extends State<UserLiveScreen> {
  RtcEngine? _engine;
  bool _isAgoraInitialized = false;
  final controller = Get.put(UserLiveController());
  final TextEditingController messageController = TextEditingController();
  bool _chatVisible = false;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _elapsedTime = "00:00";
  bool _hasJoinedChannel = false;
  int? _broadcasterUid;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final minutes =
            (_stopwatch.elapsed.inMinutes).toString().padLeft(2, '0');
        final seconds =
            (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
        _elapsedTime = "$minutes:$seconds";
      });
    });
    _initAgora();
    controller.initSocketListeners(widget.userId);
    controller.joinLiveSession(widget.liveSessionId, widget.userId);
    controller.fetchGiftList();
  }

  Future<void> _initAgora() async {
    try {
      await [Permission.camera, Permission.microphone].request();
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(
        // appId: '4b02d4dd07ba42ed983d64fd46552880',
        appId: '146ded7496614e2eaeb5b74dc7387464',
      ));
      await _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
      await _engine!.enableVideo();

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('User joined Agora channel');
            setState(() {
              _hasJoinedChannel = true;
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('Broadcaster joined with UID: $remoteUid');
            setState(() {
              _broadcasterUid = remoteUid; // Store the broadcaster's UID
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            print('Broadcaster offline: $remoteUid, Reason: $reason');
            if (remoteUid == _broadcasterUid) {
              setState(() {
                _broadcasterUid = null; // Clear broadcaster UID
              });
            }
          },
          onError: (err, String msg) {
            print('Agora Error: $err, Message: $msg');
            if (err == ErrorCodeType.errTokenExpired) {
              Get.snackbar(
                  'Error', 'Session token expired, attempting to refresh...');
              _refreshAndRejoin();
            } else {
              Get.snackbar('Agora Error', msg);
            }
          },
          onTokenPrivilegeWillExpire:
              (RtcConnection connection, String token) async {
            print('Token will expire, refreshing...');
            Get.snackbar('Info', 'Session token expiring soon, refreshing...');
            await controller.refreshToken(widget.liveSessionId, widget.userId);
            if (controller.token.value.isNotEmpty) {
              print('Renewing token: ${controller.token.value}');
              await _engine!.renewToken(controller.token.value);
            } else {
              Get.snackbar('Error', 'Failed to renew token');
            }
          },
        ),
      );

      setState(() {
        _isAgoraInitialized = true;
      });
    } catch (e) {
      print('Failed to initialize Agora: $e');
      Get.snackbar('Error', 'Failed to initialize Agora: $e');
    }
  }

  Future<void> _refreshAndRejoin() async {
    await controller.refreshToken(widget.liveSessionId, widget.userId);
    if (controller.token.value.isNotEmpty && _engine != null) {
      print('Rejoining with new token: ${controller.token.value}');
      await _engine!.renewToken(controller.token.value);
      if (!_hasJoinedChannel) {
        _joinAgoraChannel();
      }
    } else {
      Get.snackbar(
          'Error', 'Failed to refresh token, please try rejoining the session');
      controller.leaveLiveSession(widget.liveSessionId, widget.userId);
    }
  }

  void _joinAgoraChannel() {
    if (_isAgoraInitialized &&
        _engine != null &&
        controller.channelName.value.isNotEmpty &&
        controller.token.value.isNotEmpty &&
        controller.uid.value != 0 &&
        !_hasJoinedChannel) {
      print('Joining Agora channel with token: ${controller.token.value}, '
          'channel: ${controller.channelName.value}, uid: ${controller.uid.value}');
      _engine!.joinChannel(
        token: controller.token.value,
        channelId: controller.channelName.value,
        uid: controller.uid.value,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          autoSubscribeVideo: true, // Ensure video stream is subscribed
        ),
      );
    }
  }

  void _showGiftList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.gifts.isEmpty) {
            return const Center(child: Text('No gifts available'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Send a Gift',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: controller.gifts.length,
                    itemBuilder: (context, index) {
                      final gift = controller.gifts[index];
                      return GestureDetector(
                        onTap: () {
                          controller.sendGift(
                            astroId: widget.astroId, giftId: gift.sId!,
                            context: context,
                            // widget.liveSessionId,
                            // widget.userId,
                            // controller.astrologerId.value,
                            // gift.sId!,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (gift.image != null)
                                Image.network(
                                  EndPoints.imageBaseUrl + gift.image!,
                                  height: 50,
                                  width: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.error),
                                ),
                              const SizedBox(height: 8),
                              Text(
                                gift.name ?? 'Gift',
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '${gift.amount ?? 0} coins',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    if (_engine != null) {
      _engine!.leaveChannel();
      _engine!.release();
    }
    _timer.cancel();
    _stopwatch.stop();
    messageController.dispose();
    controller.leaveLiveSession(widget.liveSessionId, widget.userId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.errorMessage.value.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar('Notice', controller.errorMessage.value);
          controller.clearError();
        });
      }

      if (!_hasJoinedChannel) {
        _joinAgoraChannel();
      }

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: _isAgoraInitialized && _engine != null
                  ? (_broadcasterUid != null
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine!,
                            canvas: VideoCanvas(
                                uid: _broadcasterUid), // Use broadcaster's UID
                          ),
                        )
                      : const Center(
                          child: Text('Waiting for broadcaster...',
                              style: TextStyle(color: Colors.white))))
                  : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.astrologerName.value.isNotEmpty
                                    ? controller.astrologerName.value
                                    : 'Astrologer',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "LIVE • $_elapsedTime",
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.remove_red_eye,
                                size: 16, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${controller.viewerCount.value}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: _chatVisible
                  ? MediaQuery.of(context).size.height * 0.35 + 140
                  : 200,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.yellow,
                onPressed: _showGiftList,
                child: const Icon(Icons.card_giftcard, color: Colors.black),
              ),
            ),
            Positioned(
              bottom: _chatVisible
                  ? MediaQuery.of(context).size.height * 0.35 + 80
                  : 140,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () => controller.leaveLiveSession(
                  widget.liveSessionId,
                  widget.userId,
                ),
                child: const Icon(Icons.exit_to_app, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: _chatVisible
                  ? MediaQuery.of(context).size.height * 0.35 + 20
                  : 80,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black54,
                onPressed: () => setState(() => _chatVisible = !_chatVisible),
                child: Icon(_chatVisible
                    ? Icons.chat_bubble
                    : Icons.chat_bubble_outline),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height:
                  _chatVisible ? MediaQuery.of(context).size.height * 0.35 : 60,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message =
                              controller.messages.reversed.toList()[index];
                          final isUser = message['senderModel'] == 'User';
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue[100]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['senderName'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    message['message'] ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_chatVisible)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: messageController,
                                decoration: InputDecoration(
                                  hintText: 'Send a message...',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () {
                                if (messageController.text.isNotEmpty) {
                                  controller.sendMessage(
                                    widget.liveSessionId,
                                    widget.userId,
                                    messageController.text,
                                  );
                                  messageController.clear();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
