import 'dart:async';

import 'package:astro_shree_user/presentation/home_screen/home_screen.dart';
import 'package:astro_shree_user/presentation/wallet_screen/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import '../data/api_call/profile_api.dart';
import 'socket_services.dart';

class VideoCallScreen extends StatefulWidget {
  final String videoCallSessionId;
  final String astrologerName;
  final String maxWaitingTime;
  final String astrologerId;
  final String channelName;
  final String token;
  final int uid;

  const VideoCallScreen({
    super.key,
    required this.videoCallSessionId,
    required this.astrologerName,
    required this.astrologerId,
    required this.channelName,
    required this.token,
    required this.uid,
    required this.maxWaitingTime,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  bool _localUserJoined = false;
  int? _remoteUid;
  bool _muted = false;
  bool _cameraSwitched = false;

  final ProfileApi profileApi = Get.put(ProfileApi());
// Replace with your Agora App ID from the Agora Console
//   static const String appId = '4b02d4dd07ba42ed983d64fd46552880';
  static const String appId = '146ded7496614e2eaeb5b74dc7387464';

  @override
  void initState() {
    super.initState();
    initializeAgora();
    remainingSeconds = int.parse(widget.maxWaitingTime);
    startTimer();
// Listen for video call session end
    SocketService.on('videoCallSessionEnded', (data) {
      if (data['videoCallSessionId'] == widget.videoCallSessionId) {
        Get.offAll(HomeScreen()); // Close the video call screen
      }
    });
  }

  Future<void> initializeAgora() async {
// Request permissions
    await [Permission.camera, Permission.microphone].request();

// Initialize Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

// Set up event handlers

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Local user ${connection.localUid} joined');
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user $remoteUid joined');
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('Remote user $remoteUid left');
          setState(() {
            _remoteUid = null;
          });
          SocketService.endVideoCallSession(widget.videoCallSessionId);
        },
        onError: (ErrorCodeType err, String msg) {
          print('Agora error: $err, $msg');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Agora error: $msg')),
          );
        },
      ),
    );

    print('cchewjfjkhwfkjrf${widget.token}');
    print('cchewjfjkhwfkjrf${widget.channelName}');
    print('cchewjfjkhwfkjrf${widget.uid}');

// Enable video and join the channel
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: widget.uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }

  void _endSession(BuildContext context) {
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
              SocketService.endVideoCallSession(widget.videoCallSessionId);
              Navigator.pop(context);
            },
            child:
                const Text('End Session', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  late int remainingSeconds;
  Timer? timer;

  Future<bool> _showRechargePopup() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Low Balance'),
              content: const Text(
                  'Your chat time is below 3 minutes. Would you like to recharge your wallet to continue?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Recharge'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  bool hasRecharged = false;
  Set<int> shownPopupThresholds =
      {}; // Stores which thresholds have already triggered a popup

  void startTimer() {
    final isNew = profileApi.isNewUser.value;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      if (remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            remainingSeconds--;
          });
        }
        if (!isNew) {
          print('Remaining seconds: $remainingSeconds');
          print('Shown popups: $shownPopupThresholds');
          print('Has recharged: $hasRecharged');

          // Check thresholds: 180, 120, 60
          List<int> popupThresholds = [/*180,*/ 121, 61];
          for (int threshold in popupThresholds) {
            if (remainingSeconds <= threshold &&
                !shownPopupThresholds.contains(threshold) &&
                !hasRecharged) {
              shownPopupThresholds.add(threshold);
              t.cancel(); // Pause timer during popup
              // SocketService.pauseChatSession(widget.chatSessionId);

              final shouldRecharge = await _showRechargePopup();
              if (mounted) {
                if (shouldRecharge) {
                  hasRecharged = true;
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => WalletScreen()),
                  );
                  // SocketService.resumeChatSession(widget.chatSessionId);
                } else {
                  // SocketService.resumeChatSession(widget.chatSessionId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Chat will continue until time runs out')),
                  );
                }
                startTimer(); // Resume timer
              }
              return;
            }
          }
        }
      } else {
        t.cancel();
        if (mounted) {
          _endSession(context);
        }
      }
    });
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = secs.toString().padLeft(2, '0');

    if (hours > 0) {
      final hoursStr = hours.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr:$secondsStr'; // HH:MM:SS
    } else {
      return '$minutesStr:$secondsStr'; // MM:SS
    }
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    SocketService.off('videoCallSessionEnded');
    super.dispose();
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for astrologer to join...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _localVideo() {
    return _localUserJoined
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
// Mute/Unmute button
          RawMaterialButton(
            onPressed: () {
              setState(() {
                _muted = !_muted;
              });
              _engine.muteLocalAudioStream(_muted);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: _muted ? Colors.white : Colors.blueAccent,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              _muted ? Icons.mic_off : Icons.mic,
              color: _muted ? Colors.red : Colors.white,
              size: 20.0,
            ),
          ),
// End call button
          RawMaterialButton(
            onPressed: () {
              _endSession(context);
              // SocketService.endVideoCallSession(widget.videoCallSessionId);
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
// Switch camera button
          RawMaterialButton(
            onPressed: () {
              setState(() {
                _cameraSwitched = !_cameraSwitched;
              });
              _engine.switchCamera();
            },
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.blueAccent,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.white,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34343F),
        elevation: 0,
        title: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: NetworkImage(widget.astrologerImage),
            //   radius: 18,
            //   backgroundColor: Colors.white,
            // ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.astrologerName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatDuration(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
// Remote video (full screen)
          Center(child: _remoteVideo()),
// Local video (small overlay)
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 150,
              child: _localVideo(),
            ),
          ),
// Toolbar with controls
          _toolbar(),
        ],
      ),
    );
  }
}
