import 'dart:io';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:dio/dio.dart' as dio_prefix;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/response_handler.dart';
import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/profile_model.dart';
import '../model/recharge_plan_model.dart';
import '../model/user_add_wallet_model.dart';
import '../model/user_wallet_model.dart';
import '../model/wallet_transaction_model.dart';

class RechargeListApi extends GetxController {
  final dioClient = DioClient();
  late final dio_prefix.Dio dio;
  var rechargeData = Rxn<RechargeListModel>();
  var userWallet = Rxn<UserWalletModel>();
  var userWalletTransaction = Rxn<WalletTransactionModel>();
  var userAddWallet = Rxn<UserAddWalletModel>();
  bool? log;
  String? mobile;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  @override
  void onInit() async {
    super.onInit();
    dio = dioClient.client;
    log = await PrefsUtils.getBool(PrefsKeys.isLoggedIn);
    mobile = await PrefsUtils.getString(PrefsKeys.userMobile);
  }

  Future<void> fetchUserWallet() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.wallet,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final wallet = UserWalletModel.fromJson(response.data);
        userWallet.value = wallet;
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

  Future<void> fetchUserWalletTransaction() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.transaction,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final wallet = WalletTransactionModel.fromJson(response.data);
        userWalletTransaction.value = wallet;
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

  Future<UserAddWalletModel?> fetchUserAddWallet({
    required int amount,
    required int gstAmount,
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.post(
        EndPoints.wallet,
        data: {"amount": amount, "gstAmount": gstAmount},
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print(response);
      print(response.statusCode);

      if (response.statusCode == 201) {
        final wallet = UserAddWalletModel.fromJson(response.data);
        userAddWallet.value = wallet;
        print(wallet);

        Get.snackbar(
          'Add Wallet',
          wallet.message.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          dismissDirection: DismissDirection.horizontal,
          backgroundColor: Colors.green,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );

        fetchUserWallet();
        Navigator.pop(context);
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

  Future<void> fetchRechargeList() async {
    isLoading(true);
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await dio.get(
        EndPoints.rechargePlan,
        options: dio_prefix.Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final profile = RechargeListModel.fromJson(response.data);
        rechargeData.value = profile;
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
