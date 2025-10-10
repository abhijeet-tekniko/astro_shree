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
import '../model/get_shipping_address_model.dart';
import '../model/product_details.dart';
import '../model/product_list_model.dart';
import '../model/product_purchase_model.dart';
import '../model/product_transaction_list_model.dart';
import '../model/profile_model.dart';
import '../model/shipping_create_model.dart';

class ProductController extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var categoryListModel = Rxn<CategoryListModel>();
  var getProductTransactionModel = Rxn<GetProductTransactionModel>();
  var createShippingModel = Rxn<ShippingAddressCreateModel>();
  var getShippingModel = Rxn<GetShippingAddressModel>();
  var createPurchaseModel = Rxn<PurchaseProductModel>();
  var addresses = <ShippingAddress>[].obs;
  var productDetails = Rxn<ProductFullDetails>();
  bool? log;
  String? mobile;
  var isLoading = false.obs;
  var isProductDetailLoading = false.obs;
  // var isUpdating = false.obs;

  final List<ProductListData> products = [];
  var isProductLoading = false.obs;
  var currentPage = 1.obs;

  var isLoadingMore = false.obs;
  var currentProductPage = 1.obs;
  final int _pageSize = 10;
  var hasMore = true.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    fetchProductTransaction(page: 1);
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
  }

  Future<PurchaseProductModel?> createPurchaseProduct({
    required String product,
    required String shipping,
    String? referral,
    required String gstAmount,
    required int quantity,
    required String productVariant,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.productTransaction,
        data: {
          "product": product, // product ID from your database
          "quantity": quantity,
          "gstAmount": double.parse(gstAmount),
          "referralCode": referral,
          "PaymentMethod": "online",
          "productVariant": productVariant,
          "shipping": shipping
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
        data: {
          "name": name,
          "mobile": mobile,
          "address": address,
          "city": city,
          "state": state,
          "pincode": pincode,
          "landmark": landmark,
          "alternateNumber": alternateNumber,
          "addressType": addressType
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
        final wallet = ShippingAddressCreateModel.fromJson(response.data);
        createShippingModel.value = wallet;
        print(wallet);

        fetchShippingAddress();
        Get.back();

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
        getShippingModel.value =
            GetShippingAddressModel.fromJson(response.data);
        addresses.value = getShippingModel.value!.data!;
      } else {
        addresses.value = [];
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

  Future<void> fetchProductTransaction({required int page}) async {
    try {
      if (page == 1) {
        isLoading(true);
        getProductTransactionModel.value = null;
      } else {
        isLoadingMore(true);
      }

      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        '${EndPoints.productTransaction}?page=$page',
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        final newData = GetProductTransactionModel.fromJson(response.data);
        if (page == 1) {
          getProductTransactionModel.value = newData;
        } else {
          final currentData = getProductTransactionModel.value?.data ?? [];
          getProductTransactionModel.value = GetProductTransactionModel(
            status: newData.status,
            totalResult: newData.totalResult,
            totalPage: newData.totalPage,
            message: newData.message,
            data: [...currentData, ...?newData.data],
          );
        }
        currentProductPage.value = page;
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "Error",
      );
      print('Dio Exception: ${e.message}');
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  Future<List<ProductListData>> fetchProducts(String categoryId, int page,
      {String? search = ""}) async {
    isProductLoading(true);

    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);

      final response = await dio.get(
        '${EndPoints.product}?search=$search&categoryId=$categoryId&page=$page',
        options: dio_prefix.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final productList = ProductListModel.fromJson(response.data);
        print(productList.message);
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

  Future<void> fetchProductDetails(String id) async {
    isProductLoading(true);
    try {
      final response = await dio.get(
        '${EndPoints.product}/$id',
      );

      var result = response.data;
      print(result['message']);
      if (result['status'] == true) {
        final result1 = ProductDetailsResponse.fromJson(result);
        productDetails.value = result1.data!;
      }
    } catch (e) {
      print('Unhandled Exception: $e');
    } finally {
      isProductLoading(false);
    }
  }

  Future<void> loadMoreProducts(String categoryId,
      {String? search = ""}) async {
    if (isProductLoading.value || !hasMore.value) return;
    isProductLoading(true);
    try {
      final newProducts =
          await fetchProducts(categoryId, currentPage.value, search: search);
      final existingIds = products.map((p) => p.sId).toSet();
      final filteredNewProducts =
          newProducts.where((p) => !existingIds.contains(p.sId)).toList();

      products.addAll(filteredNewProducts);

      isProductLoading(false);
      if (filteredNewProducts.isNotEmpty) {
        currentPage++;
      }

      if (newProducts.length < _pageSize) hasMore.value = true;
    } catch (e) {
      isProductLoading(false);
    }
  }
}
