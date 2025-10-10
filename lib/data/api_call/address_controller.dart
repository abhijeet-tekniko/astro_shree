

import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/core/network/response_handler.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_prefix;
import '../../core/network/dio_client.dart';
import '../model/blog_model.dart';
import '../model/get_city_pincode_model.dart';

class PincodeController extends GetxController {
  final dio = DioClient().client;
  var isLoading = false.obs;
  var cityData = GetAddressPincodeDetailModel().obs;

  Future<void> fetchCity({required String pincode}) async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.pincode+pincode);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetAddressPincodeDetailModel.fromJson(response.data);
        cityData.value = result;
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
