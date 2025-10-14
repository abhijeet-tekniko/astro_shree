import 'package:astro_shree_user/data/api_call/profile_api.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../presentation/socket_services.dart';

///25.7
import 'package:get/get.dart';

class VoiceCallController extends GetxController {
  // Observables for voice call state
  var isConnected = false.obs;
  var callStatus = 'idle'.obs; // idle, pending, active, ended, rejected
  var voiceCallRequestId = ''.obs;
  var voiceCallSessionId = ''.obs;
  var astrologerName = ''.obs;
  var userName = ''.obs;
  var errorMessage = ''.obs;

  final ProfileApi profileApi = Get.find<ProfileApi>();

  @override
  void onInit() {
    super.onInit();
    // Initialize socket with user ID and register listeners
    SocketService.initSocket(
      profileApi.userProfile.value!.id.toString(),
    );
  }

  void registerVoiceCallListeners() {
    isConnected.value = true;
    // Connection status listeners
    SocketService.on('connect', (_) {
      isConnected.value = true;
      print('Socket connected');
    });
    SocketService.on('disconnect', (_) {
      isConnected.value = false;
      print('Socket disconnected');
    });

    // Error handling
    SocketService.on('error', (data) {
      errorMessage.value = data['message'] ?? 'An error occurred';
    });

    // Voice call event listeners
    SocketService.on('voiceCallRequestSent', (data) {
      voiceCallRequestId.value = data['voiceCallRequestId'] ?? '';
      callStatus.value = data['status'] ?? 'pending';
      Get.snackbar('Call Request', 'Voice call request sent to astrologer');
    });

    SocketService.on('voiceCallRequestReceived', (data) {
      voiceCallRequestId.value = data['voiceCallRequestId'] ?? '';
      userName.value = data['userName'] ?? '';
      callStatus.value = 'pending';
      Get.snackbar(
          'New Call Request', 'Voice call request from ${data['userName']}');
    });

    SocketService.on('voiceCallRequestAccepted', (data) {
      voiceCallSessionId.value = data['voiceCallSessionId'] ?? '';
      astrologerName.value = data['astrologerName'] ?? '';
      callStatus.value = 'active';
      // Get.snackbar('Call Accepted', 'Voice call started with ${data['astrologerName']}');
      // Optionally navigate to VoiceCallScreen
      // Get.to(() => VoiceCallScreen(...));
    });

    SocketService.on('voiceCallRequestRejected', (data) {
      callStatus.value = 'rejected';
      voiceCallRequestId.value = '';
      Get.snackbar('Call Rejected', 'Voice call request was rejected');
    });

    SocketService.on('voiceCallSessionStarted', (data) {
      voiceCallSessionId.value = data['voiceCallSessionId'] ?? '';
      userName.value = data['userName'] ?? '';
      callStatus.value = 'active';
      Get.back();
      // Get.snackbar(
      //     'Call Started', 'Voice call started with ${data['userName']}');
    });

    SocketService.on('voiceCallSessionEnded', (data) {
      callStatus.value = 'ended';
      Get.snackbar('Call Ended',
          'Voice call ended: ${data['reason'] ?? 'Unknown reason'}');
      voiceCallSessionId.value = '';
      voiceCallRequestId.value = '';
      Get.back();
    });
  }

  void sendVoiceCallRequest(String astrologerId) {
    if (!isConnected.value) {
      errorMessage.value = 'Not connected to server';
      Get.snackbar('Error', errorMessage.value);
      return;
    }
    print('sendVoiceRequest');
    SocketService.sendVoiceCallRequest(astrologerId);
    callStatus.value = 'pending';
  }

  // Respond to a voice call request (accept/reject)
  void respondVoiceCallRequest(String action, String astrologerId) {
    if (!isConnected.value) {
      errorMessage.value = 'Not connected to server';
      Get.snackbar('Error', errorMessage.value);
      return;
    }
    SocketService.respondVoiceCallRequest(
        voiceCallRequestId.value, astrologerId, action);
  }

  // End an active voice call session
  void endVoiceCallSession(bool isUser, String astrologerId) {
    if (!isConnected.value) {
      errorMessage.value = 'Not connected to server';
      Get.snackbar('Error', errorMessage.value);
      return;
    }
    SocketService.endVoiceCallSession(
      voiceCallSessionId.value,
      isUser ? profileApi.userProfile.value!.id.toString() : astrologerId,
      isUser ? 'user' : 'astrologer',
    );
    Get.back();
  }

  @override
  void onClose() {
    SocketService.off('connect');
    SocketService.off('disconnect');
    SocketService.off('error');
    SocketService.off('voiceCallRequestSent');
    SocketService.off('voiceCallRequestReceived');
    SocketService.off('voiceCallRequestAccepted');
    SocketService.off('voiceCallRequestRejected');
    SocketService.off('voiceCallSessionStarted');
    SocketService.off('voiceCallSessionEnded');
    super.onClose();
  }
}

///25.7
