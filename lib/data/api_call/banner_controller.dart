import 'dart:io';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/banner_model.dart';
import '../model/profile_model.dart';

class BannerController extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var banner = Rxn<BannerModel>();
  bool? log;
  String? mobile;
  var isBannerLoading = true.obs;
  var isUpdating = false.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    fetchBanner();
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
  }

  Future<void> fetchBanner() async {
    isBannerLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.banner,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final profile = BannerModel.fromJson(response.data);
        banner.value = profile;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );

      print('Dio Exception: ${e.message}');
    } finally {
      isBannerLoading(false);
    }
  }

}
