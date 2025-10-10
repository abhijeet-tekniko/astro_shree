import 'package:astro_shree_user/data/model/kundali_matching_model.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:get/get.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../../presentation/kundali/kundli_match_detaIl_screen.dart';

class KundaliMatchingController extends GetxController{
  final dioClient = DioClient();
  final dio = DioClient().client;
  var kundliMatching = Rxn<KundliMatchingResponse>();
  bool? log;
  String? mobile;
  var isButtonLoading = false.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  Future<void> getKundliMatching(Map<String, dynamic> data) async {
    isButtonLoading(true);
    isLoading(true);
    try {
      final response = await dio.post(EndPoints.kundliMatching, data: data);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final kundali = KundliMatchingResponse.fromJson(response.data);
        kundliMatching.value = kundali;
        Get.to(() => KundaliMatchingHome());
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );

      print('Dio Exception: ${e.message}');
    } finally {
      isButtonLoading(false);
      isLoading(false);
    }
  }
}
