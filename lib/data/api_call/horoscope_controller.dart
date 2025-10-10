
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
import '../model/monthly_horoscope_model.dart';
import '../model/product_list_model.dart';
import '../model/product_purchase_model.dart';
import '../model/profile_model.dart';
import '../model/shipping_create_model.dart';

class HoroscopeController extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var categoryListModel = Rxn<CategoryListModel>();
  var createShippingModel = Rxn<ShippingAddressCreateModel>();
  var createPurchaseModel = Rxn<PurchaseProductModel>();
  var horoscopeModel = Rxn<HoroscopeModel>();
  var horoscopeTomorrowModel = Rxn<HoroscopeModel>();
  var horoscopeMonthlyModel = Rxn<GetMonthlyHoroscopeModel>();
  bool? log;
  String? mobile;
  var isLoading = true.obs;
  // var isUpdating = false.obs;

  final List<ProductListData> products = [];
  var isProductLoading = false.obs;
  int currentPage = 1;
  final int _pageSize = 10;
  var hasMore = true.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    fetchCategory();
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
  }




  Future<HoroscopeModel?> getDailyHoroscope({
    required String sign,
    String? language,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.dailyHoroscope,
        data: {
          "zodiacNames":[sign],
          "language":language??"en"
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final purchase = HoroscopeModel.fromJson(response.data);
        horoscopeModel.value = purchase;
        print(purchase);
        print(purchase);


        return purchase;
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


  Future<HoroscopeModel?> getTomorrowHoroscope({
    required String sign,
    String? language,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.tomorrowHoroscope,
        data: {
          "zodiacNames":[sign],
          "language":language??"en"
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final purchase = HoroscopeModel.fromJson(response.data);
        horoscopeTomorrowModel.value = purchase;
        print(purchase);


        return purchase;
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


Future<GetMonthlyHoroscopeModel?> getMonthlyHoroscope({
    required String sign,
  String? language,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.monthlyHoroscope,
        data: {
          "zodiacNames":[sign],
          "language":language??"en"
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final purchase = GetMonthlyHoroscopeModel.fromJson(response.data);
        horoscopeMonthlyModel.value = purchase;
        print(purchase);


        return purchase;
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

  Future<ShippingAddressCreateModel?> createShipping({
    required String name,
    required String mobile,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String landmark,
    required String alternateNumber,
    required String addressType,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.shipping,
        data: {  "name": name,
          "mobile": mobile,
          "address": address,
          "city": city,
          "state": state,
          "pincode": pincode,
          "landmark": landmark,
          "alternateNumber": alternateNumber,
          "addressType": addressType},
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('--- Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201) {
        final wallet = ShippingAddressCreateModel.fromJson(response.data);
        createShippingModel.value = wallet;
        print(wallet);

        Get.snackbar(
          'Create Successfully',
          wallet.message.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );

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


  Future<void> fetchShippingAddress() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.shipping,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = CategoryListModel.fromJson(response.data);
        categoryListModel.value = categoryList;
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


  Future<void> fetchCategory() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.category,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = CategoryListModel.fromJson(response.data);
        categoryListModel.value = categoryList;
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


  Future<List<ProductListData>> fetchProducts(String categoryId, int page) async {
    isProductLoading(true);

    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);

      final response = await dio.get(
        '${EndPoints.product}?categoryId=$categoryId&page=$page',
        options: dio_prefix.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final productList = ProductListModel.fromJson(response.data);
        print(productList.message); // Optional log
        return productList.data ?? [];
      } else {
        print('Failed with status: ${response.statusCode}');
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );
      print('Dio Exception: ${e.message}');
    } catch (e) {
      print('Unhandled Exception: $e');
    } finally {
      isProductLoading(false);
    }
    return [];
  }



  Future<void> loadMoreProducts(String categoryId) async {
    print(categoryId);
    if (isProductLoading.value || !hasMore.value) return;
    isProductLoading(true);
    print('loadingProduct${currentPage}');
    try {
      final newProducts = await fetchProducts(categoryId,currentPage,);
      print('loadingProduct${newProducts}');
      products.addAll(newProducts);
      print('loadingProduct${products}');
      isProductLoading(false);
      // currentPage++;
      if (newProducts.length < _pageSize) hasMore.value = true;
    } catch (e) {
      isProductLoading(false);
    }
  }

}
