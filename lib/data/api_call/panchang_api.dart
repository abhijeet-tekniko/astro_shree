import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_prefix;

import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../model/panchang_model.dart';


class PanchangApi extends GetxController {
  final dio = DioClient().client;
  var isLoading = false.obs;
  var panchangData = Rxn<AdvancedPanchangData>();

  Future<void> fetchPanchang(String? date
      ) async {
    isLoading(true);
    try {
      final response = await dio.post(
        EndPoints.panchang,

        data: {  "date": date},
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = AdvancedPanchangResponse.fromJson(response.data);
        panchangData.value = result.data;

      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: response.data['message'],
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: e.response?.data['message'],
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }
}
