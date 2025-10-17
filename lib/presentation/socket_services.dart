import 'package:astro_shree_user/presentation/videoCallScreen.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/network/endpoints.dart';
import '../data/api_call/profile_api.dart';
import 'call_pick_screen.dart';
import 'newChatScreen.dart';
import 'package:get/get.dart';

///25.7
class SocketService extends GetxController {
  static SocketService get to => Get.find();
  static IO.Socket? socket;
  static String? userId;
  static String userType = 'user';
  static RxString chatRequestId = "".obs;
  static final ProfileApi profileApi = Get.put(ProfileApi());
  static final Map<String, List<Function>> _eventListeners = {};

  /// Safe helpers
  static void _showSnackBar(String message) {
    final ctx = Get.context;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  static void _safePop() {
    Get.back();
  }

  static void _safePush(Widget page) {
    Get.to(() => page);
  }

  /// Initialize socket
  static Future<void> initSocket(String userIdParam) async {
    if (socket != null) {
      print("Already Connected");
      return;
    }
    print("userIdParam: $userIdParam");
    userId = userIdParam;

    socket = IO.io('https://admin.astroshri.in', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
    });

    socket!.connect();

    // Common event listeners
    socket!.onConnect((_) {
      print('Connected to server');
      socket!.emit('join', {'id': userId, 'type': userType});
      _notifyListeners('connect', null);
    });

    socket!.onConnectError((data) {
      print('Connection error: $data');
      _notifyListeners('connectError', data);
    });

    socket!.onDisconnect((_) {
      print('Disconnected from server');
      _notifyListeners('disconnect', null);
    });

    socket!.on('joinSuccess', (data) {
      print('Join success: $data');
      _notifyListeners('joinSuccess', data);
    });

    socket!.on('error', (data) {
      print('Socket error: $data');
      final errorMessage = data is Map && data['message'] != null
          ? data['message'].toString()
          : 'An error occurred';
      // _showSnackBar(errorMessage);
      _notifyListeners('error', data);
    });

    socket!.on('walletUpdate', (data) {
      print('Wallet updated: ${data['balance']}');
      _notifyListeners('walletUpdate', data);
    });

    // Chat-related events
    socket!.on('chatRequestSent', (data) {
      print('Chat request sent: $data');
      chatRequestId.value = data['chatRequestId'];
      _notifyListeners('chatRequestSent', data);
    });

    socket!.on('chatRequestAccepted', (data) {
      print('Chat request accepted: $data');
      Get.back();
      _safePush(ChatNewwScreen(
        chatSessionId: data['chatSessionId'],
        astrologerName: data['astrologerName'],
        astrologerId: data['astrologerId'],
        astrologerImage: EndPoints.imageBaseUrl + data['profileImage'],
        maxDuartion: data['maxWaitingTime']?.toString() ?? '',
      ));
      _notifyListeners('chatRequestAccepted', data);
    });

    socket!.on('chatRequestRejected', (data) {
      print('Chat request rejected: $data');
      _showSnackBar('Chat request rejected');
      _safePop();
      _notifyListeners('chatRequestRejected', data);
    });

    socket!.on('newMessage', (data) async {
      print('New message: $data');
      _notifyListeners('newMessage', data);
    });

    socket!.on('messageSent', (data) async {
      print('Message sent: $data');
      _notifyListeners('messageSent', data);
    });

    socket!.on('messageError', (data) {
      print('Message error: ${data['message']}');
      _showSnackBar('Message error: ${data['message']}');
      _notifyListeners('messageError', data);
    });

    socket!.on('messageUpdated', (data) async {
      print('Message updated: $data');
      _notifyListeners('messageUpdated', data);
    });

    socket!.on('messageEdited', (data) async {
      print('Message edited: $data');
      _notifyListeners('messageEdited', data);
    });

    socket!.on('messageDeleted', (data) async {
      print('Message deleted: $data');
      _notifyListeners('messageDeleted', data);
    });

    socket!.on('messagesRead', (data) async {
      print('Messages read: $data');
      _notifyListeners('messagesRead', data);
    });

    socket!.on('messagesMarkedAsRead', (data) {
      print('Messages marked as read: $data');
      _notifyListeners('messagesMarkedAsRead', data);
    });

    socket!.on('userTyping', (data) {
      print('User typing: $data');
      _notifyListeners('userTyping', data);
    });

    socket!.on('userStoppedTyping', (data) {
      print('User stopped typing: $data');
      _notifyListeners('userStoppedTyping', data);
    });

    socket!.on('chatSessionPaused', (data) {
      // print('Chat session paused: ${data['message']}');
      _showSnackBar(data['message']);
      _notifyListeners('chatSessionPaused', data);
    });

    socket!.on('chatSessionResumed', (data) {
      print('Chat session resumed: ${data['message']}');
      print('Chat session resumed data: ${data}');
      _showSnackBar(data['message']);
      _notifyListeners('chatSessionResumed', data);
    });

    socket!.on('chatSessionEnded', (data) {
      profileApi.fetchProfile();
      print('Chat session ended: $data');
      print('Chat session ended: ${data['reason']}');
      _safePop();
      _safePop();
      _showSnackBar('Chat ended: ${data['reason']}');
      _notifyListeners('chatSessionEnded', data);
    });

    // Video call events
    socket!.on('videoCallRequestSent', (data) {
      print('Video call request sent: $data');
      _notifyListeners('videoCallRequestSent', data);
    });

    socket!.on('videoCallRequestAccepted', (data) {
      print('Video call request accepted: $data');
      _safePop();
      _safePush(VideoCallScreen(
        videoCallSessionId: data['videoCallSessionId'],
        astrologerName: data['astrologerName'].toString(),
        astrologerId: data['astrologerId'].toString(),
        channelName: data['channelName'].toString(),
        token: data['token'],
        uid: data['uid'],
        maxWaitingTime: data['maxWaitingTime'].toString(),
      ));
      _notifyListeners('videoCallRequestAccepted', data);
    });

    socket!.on('videoCallRequestRejected', (data) {
      print('Video call request rejected: $data');
      _safePop();
      _showSnackBar('Video call request rejected');
      _notifyListeners('videoCallRequestRejected', data);
    });

    socket!.on('videoCallSessionEnded', (data) {
      profileApi.fetchProfile();
      print('Video call session ended: ${data['reason']}');
      // _showSnackBar('Video call ended: ${data['reason']}');
      _notifyListeners('videoCallSessionEnded', data);
    });

    // Voice call events (from VoiceCallController)
    socket!.on('voiceCallRequestSent', (data) {
      print('Voice call request sent: $data');
      _notifyListeners('voiceCallRequestSent', data);
    });

    socket!.on('voiceCallRequestReceived', (data) {
      print('Voice call request received: $data');
      _notifyListeners('voiceCallRequestReceived', data);
    });

    socket!.on('voiceCallRequestAccepted', (data) {
      print('Voice call request accepted: $data');
      _notifyListeners('voiceCallRequestAccepted', data);
    });

    socket!.on('voiceCallRequestRejected', (data) {
      print('Voice call request rejected: $data');
      _notifyListeners('voiceCallRequestRejected', data);
    });

    socket!.on('voiceCallSessionStarted', (data) {
      print('Voice call session started: $data');
      _notifyListeners('voiceCallSessionStarted', data);
    });

    socket!.on('voiceCallSessionEnded', (data) {
      profileApi.fetchProfile();
      print('Voice call session ended: ${data['reason']}');
      _notifyListeners('voiceCallSessionEnded', data);
    });

    // User and astrologer status events
    socket!.on('userStatus', (data) {
      print('User status: ${data['userId']} is ${data['status']}');
      _notifyListeners('userStatus', data);
    });

    socket!.on('astrologerStatus', (data) {
      print('Astrologer status: ${data['astrologerId']} is ${data['status']}');
      _notifyListeners('astrologerStatus', data);
    });
  }

  // --- Event Listener Helpers ---
  static void on(String event, Function callback) {
    _eventListeners.putIfAbsent(event, () => []).add(callback);
  }

  static void off(String event, [Function? callback]) {
    if (callback == null) {
      _eventListeners.remove(event);
    } else {
      _eventListeners[event]?.remove(callback);
    }
  }

  static void _notifyListeners(String event, dynamic data) {
    if (_eventListeners.containsKey(event)) {
      for (var callback in _eventListeners[event]!) {
        callback(data);
      }
    }
  }

  // --- User Events ---
  static void join() {
    socket!.emit('join', {'id': userId, 'type': userType});
  }

  static void sendChatRequest(String astrologerId, String name, String gender,
      String dob, String tob, String pob) {
    socket!.emit('sendChatRequest', {
      'userId': userId,
      'astrologerId': astrologerId,
      'memberData': [
        {
          'name': name,
          'gender': gender,
          'dob': dob,
          'birthTime': tob,
          'placeOfBirth': pob,
        }
      ]
    });
  }

  static void sendMessage(String chatSessionId, String messageText) {
    socket!.emit('sendMessage', {
      'chatSessionId': chatSessionId,
      'senderId': userId,
      'senderType': 'User',
      'messageText': messageText,
    });
  }

  static void editMessage(String messageId, String newMessageText) {
    socket!.emit('editMessage', {
      'messageId': messageId,
      'userId': userId,
      'newMessageText': newMessageText,
    });
  }

  static void deleteMessage(String messageId, bool forEveryone) {
    socket!.emit('deleteMessage', {
      'messageId': messageId,
      'userId': userId,
      'forEveryone': forEveryone,
    });
  }

  static void markMessagesAsRead(String senderId) {
    socket!.emit('markMessagesAsRead', {
      'senderId': senderId,
      'recipientId': userId,
    });
  }

  static void emitTyping(String recipientId) {
    socket!.emit('typing', {
      'senderId': userId,
      'recipientId': recipientId,
      'senderType': userType,
    });
  }

  static void emitStopTyping(String recipientId) {
    socket!.emit('stopTyping', {
      'senderId': userId,
      'recipientId': recipientId,
      'senderType': userType,
    });
  }

  static void endChatSession(String chatSessionId) {
    socket!.emit('endChatSession', {
      'chatSessionId': chatSessionId,
      'userId': userId,
      'userType': userType,
    });
  }

  static void pauseChatSession(String chatSessionId) {
    socket!.emit('pauseChatSession', {
      'chatSessionId': chatSessionId,
      'userId': userId,
      'userType': userType,
    });
  }

  static void resumeChatSession(String chatSessionId) {
    socket!.emit('resumeChatSession', {
      'chatSessionId': chatSessionId,
      'userId': userId,
      'userType': userType,
    });
  }

  static void respondChatRequest(
      String action, String userId, String astrologerId) {
    socket!.emit('respondChatRequest', {
      'userId': userId,
      'chatRequestId': chatRequestId.value,
      'astrologerId': astrologerId,
      'action': action,
    });
  }

  static void respondVideoRequest(
      String action, String userId, String astrologerId) {
    socket!.emit('respondVideoRequest', {
      'userId': userId,
      'astrologerId': astrologerId,
      'action': action,
    });
  }

  // static void endChatScreenSession(String chatSessionId,Duration chatDuration,String astrologerName,String astrologerId,String astrologerImage) {
  //   socket!.emit('endChatSession', {
  //     'chatSessionId': chatSessionId,
  //     'userId': userId,
  //     'userType': userType,
  //   });
  //   Get.off(
  //     ChatSummaryScreen(
  //       chatDuration: chatDuration,
  //       astrologerName: astrologerName,
  //       astrologerId: astrologerId,
  //       astrologerImage: astrologerImage,
  //       availableBalance: 400.0,
  //       ratePerMinute: 10.0,
  //     ),
  //   );
  // }

  // --- Video Call Methods ---
  static void sendVideoCallRequest(String astrologerId, String astrologerName) {
    print('Sending video call request to $astrologerId');
    socket!.emit('sendVideoCallRequest', {
      'userId': userId,
      'astrologerId': astrologerId,
    });

    Get.to(CallPickScreen(
      callerName: astrologerName,
      callType: 'video',
      profileImage:
          'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=',
      astroId: astrologerId,
    ));
  }

  static void endVideoCallSession(String videoCallSessionId) {
    socket!.emit('endVideoCallSession', {
      'videoCallSessionId': videoCallSessionId,
      'userId': userId,
      'userType': userType,
    });
  }

  // --- Voice Call Methods ---
  static void sendVoiceCallRequest(String astrologerId) {
    print('Sending voice call request to $astrologerId');
    socket!.emit('sendVoiceCallRequest', {
      'userId': userId,
      'astrologerId': astrologerId,
    });
  }

  static void respondVoiceCallRequest(
      String voiceCallRequestId, String astrologerId, String action) {
    socket!.emit('respondVoiceCallRequest', {
      'voiceCallRequestId': voiceCallRequestId,
      'astrologerId': astrologerId,
      'action': action,
    });
  }

  static void endVoiceCallSession(
      String voiceCallSessionId, String userId, String userType) {
    socket!.emit('endVoiceCallSession', {
      'voiceCallSessionId': voiceCallSessionId,
      'userId': userId,
      'userType': userType,
    });
  }

  static void disconnect() {
    socket?.disconnect();
    socket = null;
    _eventListeners.clear();
  }
}

///for live

class UserSocketService {
  static final UserSocketService _instance = UserSocketService._internal();
  IO.Socket? _socket;

  factory UserSocketService() => _instance;

  UserSocketService._internal();

  IO.Socket get socket {
    if (_socket == null || !_socket!.connected) {
      _initSocket();
    }
    return _socket!;
  }

  void _initSocket() {
    _socket = IO.io(
      'https://admin.astroshri.in',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnection': true,
        'reconnectionAttempts': 10,
        'reconnectionDelay': 1000,
      },
    );

    _socket!.onConnect((_) {
      print('User connected to socket server');
    });

    _socket!.onDisconnect((_) {
      print('User disconnected from socket server');
    });

    _socket!.onConnectError((data) {
      print('User socket connect error: $data');
    });
  }

  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket = null;
    }
  }
}
