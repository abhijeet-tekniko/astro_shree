import 'package:astro_shree_user/presentation/live_screen/user_live_attend_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../../data/api_call/astrologers_api.dart';
import '../../data/model/get_gift_list_model.dart';
import '../../data/model/sed_gift_model.dart';
import '../socket_services.dart';
import 'package:dio/dio.dart' as dio_prefix;

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class UserLiveController extends GetxController {
  final UserSocketService socketService = UserSocketService();
  final RxString liveSessionId = ''.obs;
  final RxString channelName = ''.obs;
  final RxString token = ''.obs;
  final RxInt uid = 0.obs;
  final RxInt viewerCount = 0.obs;
  final RxString title = ''.obs;
  final RxString astrologerName = ''.obs;
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxString errorMessage = ''.obs;
  final Set<String> _messageIds = {};

  final RxList<GiftListData> gifts = <GiftListData>[].obs;

  final AstrologersApi astrologersApi = Get.put(AstrologersApi());

  final RxBool isLoading = false.obs;

  SendGiftModel? sendGiftModel;

  final dioClient = DioClient();

  late final dio_prefix.Dio dio;

  @override
  void onInit() {
    super.onInit();
    dio = dioClient.client;
    initSocketListeners('');
    fetchGiftList();
  }

  void initSocketListeners(String userId) {
    final socket = socketService.socket;

    socket.off('liveSessionJoined');
    socket.off('viewerCountUpdate');
    socket.off('liveSessionMessage');
    socket.off('liveSessionEnded');
    socket.off('blockedFromLiveSession');
    socket.off('liveSessionLeft');
    socket.off('error');

    socket.on('liveSessionJoined', (data) {
      print('liveSessionJoined: $data');
      liveSessionId.value = data['liveSessionId'] ?? '';
      channelName.value = data['channelName'] ?? '';
      token.value = data['token'] ?? '';
      uid.value = data['uid'] ?? 0;
      title.value = data['title'] ?? '';
      astrologerName.value = data['astrologerName'] ?? '';
      viewerCount.value = data['viewCount'] ?? 0;
    });

    socket.on('viewerCountUpdate', (data) {
      viewerCount.value = data['viewCount'] ?? 0;
    });

    socket.on('liveSessionMessage', (data) {
      print('liveSessionMessage: $data');
      final messageId = data['_id'] as String? ?? '';
      if (!_messageIds.contains(messageId)) {
        _messageIds.add(messageId);
        messages.add(data);
      }
    });

    socket.on('liveSessionEnded', (_) {
      messages.clear();
      _messageIds.clear();
      astrologersApi.fetchLiveAstrologers("");
      Get.back();
    });

    socket.on('blockedFromLiveSession', (data) {
      errorMessage.value = data['message'] ?? 'You have been blocked';
      Get.back();
    });

    socket.on('liveSessionLeft', (_) {
      messages.clear();
      _messageIds.clear();
      Get.back();
    });

    socket.on('error', (data) {
      errorMessage.value = data['message'] ?? 'An error occurred';
    });
  }

  Future<SendGiftModel?> sendGift({
    required String astroId,
    required String giftId,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      print("giftCardId=========${giftId}");
      print("astroId=========${astroId}");
      final response = await dio.post(
        EndPoints.sentGiftCard,
        data: {"giftCardId": giftId, "astrologerId": astroId},
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final purchase = SendGiftModel.fromJson(response.data);
        sendGiftModel = purchase;
        print(purchase);

        Get.snackbar(
          'Send Successfully',
          purchase.message.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );

        return purchase;
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Failed',
          response.statusMessage ?? "",
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.red,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      }
    } on dio_prefix.DioException catch (e) {
      Get.snackbar(
        'Failed',
        'Recharge your wallet first',
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      );
      // HttpStatusHandler.handle(
      //   statusCode: e.response?.statusCode,
      //   customSuccessMessage: "Error",
      // );
      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<void> fetchGiftList() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.giftCard,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('resdsdsdsdsdGifttt===${response.data}');
      print('resdsdsdsdsdGifttt===${response.statusCode}');
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final giftList = GetGiftList.fromJson(response.data);
        if (giftList.status == true && giftList.data != null) {
          gifts.assignAll(giftList.data!);
        } else {
          errorMessage.value = giftList.message ?? 'Failed to load gift list';
        }
      } else {
        final giftList = GetGiftList.fromJson(response.data);
        errorMessage.value = giftList.message ?? 'Failed to load gift list';
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );

      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
    }
  }

  // Future<void> fetchGiftList() async {
  //   isLoading(true);
  //   try {
  //     final token = await PrefsUtils.getString(PrefsKeys.userToken);
  //     final response = await dio.get(
  //       EndPoints.giftCard,
  //       options: dio_prefix.Options(
  //         headers: {'Authorization': 'Bearer $token'},
  //       ),
  //     );
  //     var result = response.data;
  //     print('check=========='+response.statusCode.toString());
  //     print(result['message']);
  //     if (response.statusCode == 200) {
  //       final giftList = GetGiftList.fromJson(response.data);
  //       if (giftList.status == true && giftList.data != null) {
  //         gifts.assignAll(giftList.data!);
  //       } else {
  //         errorMessage.value = giftList.message ?? 'Failed to load gift list';
  //       }
  //     }
  //   } on dio_prefix.DioException catch (e) {
  //     HttpStatusHandler.handle(
  //       statusCode: e.response?.statusCode,
  //       customSuccessMessage: "Error",
  //     );
  //     print('Dio Exception: ${e.message}');
  //     errorMessage.value = 'Failed to fetch gift list: ${e.message}';
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  joinLiveSession(String liveSessionId, String userId) {
    socketService.socket.emit('joinLiveSession', {
      'liveSessionId': liveSessionId,
      'userId': userId,
    });
  }

  Future<void> refreshToken(String liveSessionId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('https://your-backend.com/refresh-token'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'liveSessionId': liveSessionId, 'userId': userId}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        token.value = data['token'] ?? '';
        print('Refreshed token: ${token.value}');
      } else {
        errorMessage.value = 'Failed to refresh token: Server error';
      }
    } catch (e) {
      errorMessage.value = 'Failed to refresh token: $e';
    }
  }

  void sendMessage(String liveSessionId, String userId, String messageText) {
    socketService.socket.emit('sendLiveSessionMessage', {
      'liveSessionId': liveSessionId,
      'senderId': userId,
      'senderType': 'User',
      'messageText': messageText,
    });
  }

  void leaveLiveSession(String liveSessionId, String userId) {
    socketService.socket.emit('leaveLiveSession', {
      'liveSessionId': liveSessionId,
      'userId': userId,
    });
  }

  void clearError() {
    errorMessage.value = '';
  }

  @override
  void onClose() {
    socketService.socket.off('liveSessionJoined');
    socketService.socket.off('viewerCountUpdate');
    socketService.socket.off('liveSessionMessage');
    socketService.socket.off('liveSessionEnded');
    socketService.socket.off('blockedFromLiveSession');
    socketService.socket.off('liveSessionLeft');
    socketService.socket.off('error');
    super.onClose();
  }
}

//bellow is fine

// class UserLiveController extends GetxController {
//   final UserSocketService socketService = UserSocketService();
//   final RxString liveSessionId = ''.obs;
//   final RxString channelName = ''.obs;
//   final RxString token = ''.obs;
//   final RxInt uid = 0.obs;
//   final RxInt viewerCount = 0.obs;
//   final RxString title = ''.obs;
//   final RxString astrologerName = ''.obs;
//   final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
//   final RxString errorMessage = ''.obs;
//   final Set<String> _messageIds = {}; // To track unique message IDs
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize socket listeners once
//     // initSocketListeners('');
//   }
//
//   void initSocketListeners(String userId) {
//     final socket = socketService.socket;
//
//     // Clear existing listeners to prevent duplicates
//     socket.off('liveSessionJoined');
//     socket.off('viewerCountUpdate');
//     socket.off('liveSessionMessage');
//     socket.off('liveSessionEnded');
//     socket.off('blockedFromLiveSession');
//     socket.off('liveSessionLeft');
//     socket.off('error');
//
//     socket.on('liveSessionJoined', (data) {
//       print('liveSessionJoined: $data');
//       liveSessionId.value = data['liveSessionId'] ?? '';
//       channelName.value = data['channelName'] ?? '';
//       token.value = data['token'] ?? '';
//       uid.value = data['uid'] ?? 0;
//       title.value = data['title'] ?? '';
//       astrologerName.value = data['astrologerName'] ?? '';
//       viewerCount.value = data['viewCount'] ?? 0;
//       Get.to(UserLiveScreen(liveSessionId:liveSessionId.value , userId: userId,/*channelName: channelName.value,token: token.value,uid: uid.value,*/));
//       // Do NOT call Get.to(UserLiveScreen) here; it should be handled externally
//     });
//
//     socket.on('viewerCountUpdate', (data) {
//       viewerCount.value = data['viewCount'] ?? 0;
//     });
//
//     socket.on('liveSessionMessage', (data) {
//       print('liveSessionMessage: $data');
//       // Prevent duplicate messages
//       final messageId = data['_id'] as String? ?? '';
//       if (!_messageIds.contains(messageId)) {
//         _messageIds.add(messageId);
//         messages.add(data);
//       }
//     });
//
//     socket.on('liveSessionEnded', (_) {
//       messages.clear();
//       _messageIds.clear();
//       Get.back();
//     });
//
//     socket.on('blockedFromLiveSession', (data) {
//       errorMessage.value = data['message'] ?? 'You have been blocked';
//       Get.back();
//     });
//
//     socket.on('liveSessionLeft', (_) {
//       messages.clear();
//       _messageIds.clear();
//       Get.back();
//     });
//
//     socket.on('error', (data) {
//       errorMessage.value = data['message'] ?? 'An error occurred';
//     });
//   }
//
//   void joinLiveSession(String liveSessionId, String userId) {
//     socketService.socket.emit('joinLiveSession', {
//       'liveSessionId': liveSessionId,
//       'userId': userId,
//     });
//   }
//
//   Future<void> refreshToken(String liveSessionId, String userId) async {
//     try {
//       // Replace with your backend token refresh endpoint
//       final response = await http.post(
//         Uri.parse('https://your-backend.com/refresh-token'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'liveSessionId': liveSessionId, 'userId': userId}),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         token.value = data['token'] ?? '';
//         print('Refreshed token: ${token.value}');
//       } else {
//         errorMessage.value = 'Failed to refresh token: Server error';
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to refresh token: $e';
//     }
//   }
//
//   void sendMessage(String liveSessionId, String userId, String messageText) {
//     socketService.socket.emit('sendLiveSessionMessage', {
//       'liveSessionId': liveSessionId,
//       'senderId': userId,
//       'senderType': 'User',
//       'messageText': messageText,
//     });
//   }
//
//   void leaveLiveSession(String liveSessionId, String userId) {
//     socketService.socket.emit('leaveLiveSession', {
//       'liveSessionId': liveSessionId,
//       'userId': userId,
//     });
//   }
//
//   void clearError() {
//     errorMessage.value = '';
//   }
//
//   @override
//   void onClose() {
//     socketService.socket.off('liveSessionJoined');
//     socketService.socket.off('viewerCountUpdate');
//     socketService.socket.off('liveSessionMessage');
//     socketService.socket.off('liveSessionEnded');
//     socketService.socket.off('blockedFromLiveSession');
//     socketService.socket.off('liveSessionLeft');
//     socketService.socket.off('error');
//     super.onClose();
//   }
// }
