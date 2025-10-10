// kundli


import 'dart:convert';
import 'dart:io';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/category_list_model.dart';
import '../model/horoscope_daily_model.dart';
import '../model/kundli_model.dart';
import '../model/product_list_model.dart';
import '../model/product_purchase_model.dart';
import '../model/profile_model.dart';
import '../model/shipping_create_model.dart';

class KundaliController extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;



  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
  }


  var isLoading = true.obs;
  var kundali = Rx<KundliModel?>(null);


  // void fetchKundali() async {
  //   try {
  //     isLoading(true);
  //     final response = await dio.getKundali();
  //     kundali.value = response;
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to fetch kundali data');
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<Rx<KundliModel?>?> fetchKundli({
    required String name,
    required String dob,
    required String tob,
    required String address,
    String? language,
    String? gender,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.kundli,
        data: {
          "name": name,
          "dob": dob,
          "tob":"10:30"/* tob*/,
          "place": address,
          "latitude": 19.0760,
          "longitude": 72.8777,
          "timezone": 5.5,
          "gender": gender??"male",
          "language":language?? "en",
          "chartTypes" : [
            "chalit",
            "SUN",
            "MOON",
            "D1",
            "D2",
            "D3",
            "D4",
            "D5",
            "D7",
            "D8",
            "D9",
            "D10",
            "D12",
            "D16",
            "D20",
            "D24",
            "D27",
            "D30",
            "D40",
            "D45",
            "D60"
          ],
          "sections":[]
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('--- Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final kundliData =
        KundliModel.fromJson(response.data);
        kundali.value = kundliData;
        print(kundliData);


        return kundali;
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




}



