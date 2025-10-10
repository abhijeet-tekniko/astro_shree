
import 'package:astro_shree_user/data/model/create_member_model.dart';
import 'package:astro_shree_user/data/model/get_kundali_member_model.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/create_kundli_member_model.dart';
import '../model/user_member_model.dart' as get_member;

class MemberController extends GetxController{
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var memberList = <get_member.Data>[].obs;
  var kundaliMemberList = <GetKundliMemberData>[].obs;

  var createMemberModel=CreateMemberModel().obs;
  var createKundliMemberModel=CreateKundliMemberModel().obs;
  bool? log;
  String? mobile;
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchMembers();
    dio = dioClient.client;
  }


  Future<CreateMemberModel?> createMember({
    required String name,
    required String gender,
    required String dob,
    required String birthTime,
    required String placeOfBirth,
  }) async {
    isLoading(true);
    try {

      debugPrint('chedejkhdkh${name}');
      debugPrint('chedejkhdkh${gender}');
      debugPrint('chedejkhdkh${dob}');
      debugPrint('chedejkhdkh${birthTime}');
      debugPrint('chedejkhdkh${placeOfBirth}');
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.requestMember,
        data: {  "name": name,
          "gender": gender,
          "dob": dob,
          "birthTime": birthTime,
          "placeOfBirth": placeOfBirth,},
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('--- Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201) {
        final wallet = CreateMemberModel.fromJson(response.data);
        createMemberModel.value = wallet;
        print(wallet);

        return wallet;
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
    return null;
  }


  Future<CreateKundliMemberModel?> createKundliMember({
    required String name,
    required String gender,
    required String dob,
    required String birthTime,
    required String placeOfBirth,
  }) async {
    isLoading(true);
    try {

      debugPrint('chedejkhdkh${name}');
      debugPrint('chedejkhdkh${gender}');
      debugPrint('chedejkhdkh${dob}');
      debugPrint('chedejkhdkh${birthTime}');
      debugPrint('chedejkhdkh${placeOfBirth}');
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.kundliMember,
        data: {  "name": name,
          "gender": gender,
          "dob": dob,
          "birthTime": birthTime,
          "placeOfBirth": placeOfBirth,},
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('--- Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201) {
        final member = CreateKundliMemberModel.fromJson(response.data);
        createKundliMemberModel.value = member;
        print(member);

        return member;
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
    return null;
  }


  Future<void> fetchMembers() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.requestMember,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = get_member.GetMemberListModel.fromJson(response.data);
        memberList.value = categoryList.data!;
      }else{
        memberList.value = [];
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

  Future<void> fetchKundaliMembers() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.kundliMember,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = GetKundliMemberModel.fromJson(response.data);
        kundaliMemberList.value = categoryList.data!;
      }else{
        kundaliMemberList.value = [];
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

  Future<void> deleteKundaliMembers({required String id}) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.delete(
        EndPoints.kundliMember+'/$id',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        fetchKundaliMembers();
        Fluttertoast.showToast(msg: 'Delete Successfully');
      }else{
        kundaliMemberList.value = [];
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
}