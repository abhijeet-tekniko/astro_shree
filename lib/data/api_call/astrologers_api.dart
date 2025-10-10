import 'dart:io';

import 'package:astro_shree_user/data/model/get_consultant_detail_model.dart';
import 'package:astro_shree_user/data/model/get_live_astro_model.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../../presentation/astro_profile/astrologer_rating_model.dart';
import '../model/active_session_model.dart';
import '../model/astrologers_model.dart';
import '../model/chat_session_message_model.dart';
import '../model/chat_session_model.dart';
import '../model/get_my_session_model.dart'as session;
import '../model/not_respond_chat_model.dart';
import '../model/notifyAstro_model.dart';
import '../model/speciality_list_model.dart';

class AstrologersApi extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;

  var astrologerList = Rxn<List<Astrologer>>();

  ///
  var astrologerLiveList = Rxn<List<LiveAstrologerListData>>();
  String selectedSpecialityId = ""; // "" means All
  List<SpecialityListData> specialities = [];

  ///live


  var mySessionList = Rxn<List<session.MySessionData>>();
  var astrologerDetail = GetConsultDetailModel().obs;
  var activeSessionData = ActiveSessionModel().obs;
  var chatSessionList = Rxn<List<ChatSessionListData>>();
  var notRespondData = Rxn<NotRespondChatModel>();
  var chatSessionMessage = Rxn<ChatSessionMessagesModel>();
  bool? log;
  String? mobile;
  var isLoading = true.obs;
  var isDetailLoading = false.obs;
  var isRatingsLoading = true.obs;
  var isChatLoading = true.obs;
  var isUpdating = false.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
    fetchActiveSession();
    fetchAstrologers();
    fetchLiveAstrologers("");
    fetchMySessions();
  }

  Future<void> fetchActiveSession() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.activeSession,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final activeSession = ActiveSessionModel.fromJson(response.data);
        activeSessionData.value = activeSession;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAstrologers() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.astrologers,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = AstrologerResponse.fromJson(response.data);
        astrologerList.value = astrologers.data;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchSpeciality() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.speciality,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final specialityModel = SpecialityListModel.fromJson(response.data);
        if (specialityModel.data != null) {

            specialities = [
              SpecialityListData(sId: '', name: 'All', status: true), // Insert All at first
              ...specialityModel.data!,
            ];

        }
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchLiveAstrologers(String? specialityId) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        '${EndPoints.liveAsterologer}?speciality=$specialityId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      // print(result['message']);
      print(response.statusCode.toString()+'Hellllll');
      if (response.statusCode == 200) {
        final astrologers = LiveAstrologerListModel.fromJson(response.data);
        astrologerLiveList.value = astrologers.data;
        print(astrologerLiveList.value!.first.toString()+'Hellllll');
      }
      else{
        astrologerLiveList.value=[];
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMySessions() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.mySession,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = session.GetMySessionModel.fromJson(response.data);
        mySessionList.value = astrologers.data;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }
  Future<void> fetchAstrologersDetail({required String consultantId}) async {
    isDetailLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        '${EndPoints.astrologers}/$consultantId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = GetConsultDetailModel.fromJson(response.data);
        astrologerDetail.value = astrologers;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isDetailLoading(false);
    }
  }

  Future<void> fetchChatSession() async {

    // isLoading.value=true;
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.chatSession,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = ChatSessionListModel.fromJson(response.data);
        chatSessionList.value = astrologers.data;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchChatMessageSession({required String sessionId, String? from}) async {
    isChatLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        '${EndPoints.sessionMessage}/$sessionId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = ChatSessionMessagesModel.fromJson(response.data);
        chatSessionMessage.value = astrologers;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isChatLoading(false);
    }
  }

  Future<void> notifyAstrologer({
    required String astrologerId,
    required String title,
    required String message,
    required String type,
  }) async {
    isChatLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.notifyAstrologer,
        data: {
          "astrologerId": astrologerId,
          "title": title,
          "message": message,
          "type": type,
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final astrologers = NotifyAstroModel.fromJson(response.data);
        Fluttertoast.showToast(
            msg: 'Notify to Astrologer', backgroundColor: Colors.red.shade800);
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isChatLoading(false);
    }
  }

  Future<void> notRespondAstrologer({required String chatId}) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      print('checkkkkkkkkkkkkNotRespond${EndPoints.notRespond}/$chatId');
      final response = await dio.get(
        '${EndPoints.notRespond}/$chatId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
    print('checkkkkkkkkkkkkNotRespond$result');
      print(result['message']);
      if (response.statusCode == 200) {
        final astrologers = NotRespondChatModel.fromJson(response.data);
        notRespondData.value = astrologers;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  void sendRatingReview({astrologerId, rating, comment, transactionId}) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.rating,
        data: {
          "astrologerId": astrologerId,
          "rating": rating,
          "comment": comment,
          "transactionId": transactionId
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      // log(result);
      print(result['message']);
      if (response.statusCode == 200 || response.statusCode == 200) {
        HttpStatusHandler.handle(
            statusCode: response.statusCode,
            customSuccessMessage: "Review Sent");
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<RatingsData?> fetchAstrologersRatings(String id,
      {int page = 1, int limit = 10}) async {
    isRatingsLoading(true);
    final token = await PrefsUtils.getString(PrefsKeys.userToken);
    final response = await dio.get(
      EndPoints.astrologerRating,
      queryParameters: {
        "astrologerId": id,
        "page": page,
        "limit": limit,
      },
      options: dio_prefix.Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    print(response.data);
    if (response.statusCode == 200) {
      final astrologers = RatingsResponse.fromJson(response.data);
      return astrologers.data;
    }
    try {

    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error fetching astrologers",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unexpected fetchAstrologersRatings error: $e');
    } finally {
      isRatingsLoading(false);
    }
    return null;
  }
}
