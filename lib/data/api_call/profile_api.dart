import 'dart:io';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/profile_model.dart';

class ProfileApi extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var userProfile = Rxn<User>();
  var isNewUser = false.obs;
  bool? log;
  var mobile = ''.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile.value = (await PrefsUtils.getString(PrefsKeys.userMobile))!;
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    fetchIsNewUser();
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.profile,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final profile = ProfileResponse.fromJson(response.data);
        userProfile.value = profile.data.user;
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

  Future<void> fetchIsNewUser() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        "/api/user/isNewUser",
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result);
      if (response.statusCode == 200) {
        isNewUser.value = result['data']['isNew'];
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

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String mobile,
    required String dob,
    required String birthTime,
    required String placeOfBirth,
    required String gender,
    required String status,
    File? profileImageFile,
  }) async {
    isUpdating.value = true;

    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);

      final Map<String, dynamic> formDataMap = {
        'name': name,
        'email': email,
        'mobile': mobile,
        'dob': dob,
        'gender': gender,
        'maritalStatus': status,
        'birthTime': birthTime,
        'placeOfBirth': placeOfBirth,
      };

      if (profileImageFile != null) {
        final imageBytes = await profileImageFile.readAsBytes();
        final fileName = profileImageFile.path.split('/').last;

        formDataMap['profileImage'] = dio_prefix.MultipartFile.fromBytes(
          imageBytes,
          filename: fileName,
          contentType: dio_prefix.DioMediaType('image', 'jpeg'),
        );
      }

      print('📤 Sending profile update request:');
      formDataMap.forEach((key, value) {
        if (value is dio_prefix.MultipartFile) {
          print('$key: [MultipartFile: ${value.filename}]');
        } else {
          print('$key: $value');
        }
      });

      final formData = dio_prefix.FormData.fromMap(formDataMap);

      final response = await dio.patch(
        EndPoints.profile,
        data: formData,
        options: dio_prefix.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('✅ Profile update response: ${response.data}');

      if (response.statusCode == 200) {
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "Profile Updated Successfully",
        );
        await fetchProfile();
        return true;
      } else {
        HttpStatusHandler.handle(statusCode: response.statusCode);
        print('❌ Failed to update profile: ${response.data}');
        return false;
      }
    } on dio_prefix.DioException catch (e) {
      print('❌ Dio error: ${e.response?.statusCode}');
      print('❌ Dio response data: ${e.response?.data}');
      HttpStatusHandler.handle(statusCode: e.response?.statusCode);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
}
