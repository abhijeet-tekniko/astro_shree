import 'package:dio/dio.dart' as dio_prefix;
import 'package:get/get.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/search_model.dart';

class SearchControllerApi extends GetxController{
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var searchData = GetGlobalSearchModel().obs;

  var isLoading = false.obs;



  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
  }



  Future<void> fetchSearch({required String search}) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.universalSearch+search,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
         searchData.value = GetGlobalSearchModel.fromJson(response.data);
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