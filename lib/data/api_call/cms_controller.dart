
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/core/network/response_handler.dart';
import 'package:astro_shree_user/data/model/custome_review_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_prefix;
import '../../core/network/dio_client.dart';
import '../model/privacy_model.dart';

class CmsController extends GetxController {
  final dio = DioClient().client;
  var isLoading = false.obs;
  var privacyData = <PrivacyPolicyData>[].obs;
  var aboutUsData = <GetAboutUsData>[].obs;
  var termsData = <TermsData>[].obs;

  Future<void> fetchPolicy() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.privacyPolicy);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetPrivacyPolicyModel.fromJson(response.data);
        privacyData.value = result.data!;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchAboutUS() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.aboutUs);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetAboutUsModel.fromJson(response.data);
        aboutUsData.value = result.data!;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchTerms() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.termCondition);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetTermsConditionModel.fromJson(response.data);
        termsData.value = result.data!;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }

}
