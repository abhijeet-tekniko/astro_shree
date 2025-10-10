
import 'dart:io';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/data/model/pooja_model.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../../presentation/e_pooja/pooja_listing.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../model/astro_booking_model.dart';
import '../model/category_list_model.dart';
import '../model/create_pooja_order_model.dart';
import '../model/get_product_trnasaction_model.dart';
import '../model/pooja_detail_model.dart';
import '../model/product_list_model.dart';
import '../model/product_purchase_model.dart';
import '../model/profile_model.dart';
import '../model/shipping_create_model.dart';

class PoojaController extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var poojaList = <PoojaData>[].obs;

  var selectedIndex = (-1).obs;
  var poojaAstroList = <BookingAstrologerData>[].obs;
  var poojaDetailModel = Rxn<GetPoojaDetailModel>();
  var createShippingModel = Rxn<ShippingAddressCreateModel>();
  var createPoojaModel = Rxn<CreatePoojaTransactionModel>();
  var createPurchaseModel = Rxn<PurchaseProductModel>();
  var getPoojaTransactionModel = Rxn<GetPoojaTransactionModel>();
  bool? log;
  String? mobile;
  var isLoading = false.obs;
  var isPoojaDetailLoading = false.obs;
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
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
    fetchPoojaTransaction();
  }




  Future<PurchaseProductModel?> createPurchaseProduct({
    required String product,
    required String shipping,
    String? referral,
    required String gstAmount,
    required int quantity,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.productTransaction,
        data: {
          "product": product,  // product ID from your database
          "quantity": quantity,
          "gstAmount":gstAmount,
          "referralCode":referral,
          "PaymentMethod": "online",
          "shipping":shipping
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final purchase = PurchaseProductModel.fromJson(response.data);
        createPurchaseModel.value = purchase;
        print(purchase);

        Get.snackbar(
          'Create Successfully',
          purchase.message.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );

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


  Future<CreatePoojaTransactionModel?> purchasePooja({
    required String poojaId,
    required String astroId,
    required int amount,
    required int gstAmount,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.poojaTransaction,
        data: {
          "pooja":poojaId, "PaymentMethod":"online", "amount":amount, "gstAmount":gstAmount, "astrologer":astroId,
        },
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('--- Response Details ---');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Response Body: ${response.data}');

      if (response.statusCode == 201) {
        final wallet = CreatePoojaTransactionModel.fromJson(response.data);
        createPoojaModel.value = wallet;
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
        // purchaseProduct


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

  Future<void> fetchPooja() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.pooja,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = GetPoojaModel.fromJson(response.data);
        poojaList.value = categoryList.data!;
      }else{
        poojaList.value = [];
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


  Future<void> fetchDetailPooja({required String poojaId}) async {
    isPoojaDetailLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      // print('PoojaDetail=====>${EndPoints.pooja}/$poojaId');
      final response = await dio.get(
        '${EndPoints.pooja}/$poojaId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        poojaDetailModel.value = GetPoojaDetailModel.fromJson(response.data);
      }else{
        poojaDetailModel.value=null;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );

      print('Dio Exception: ${e.message}');
    } finally {
      isPoojaDetailLoading(false);
    }
  }


  Future<void> fetchPoojaAstro({required String poojaId}) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        '${EndPoints.poojaAstrologer}/$poojaId',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final categoryList = GetBookingAstrologerModel.fromJson(response.data);
        poojaAstroList.value = categoryList.data!;
      }else{
        poojaAstroList.value = [];
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


  Future<void> fetchPoojaTransaction() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.poojaTransaction,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
         getPoojaTransactionModel.value = GetPoojaTransactionModel.fromJson(response.data);
      }else{
        getPoojaTransactionModel.value=null;
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
