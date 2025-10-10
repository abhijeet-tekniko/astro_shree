import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum ResultType { success, error }

class HttpStatusHandler {
  static void handle({
    required int? statusCode,
    String? customSuccessMessage,
  }) {
    switch (statusCode) {
      case 200:
        if(customSuccessMessage != "none") {
          _showSnackbar(
          title: "Success!",
          message: customSuccessMessage ?? "Request completed successfully.",
          type: ResultType.success,
        );
        }
        break;

      case 201:
      case 202:
      case 204:
      if(customSuccessMessage != "none") {
        _showSnackbar(
          title: "Success!",
          message: customSuccessMessage ?? "Request completed successfully.",
          type: ResultType.success,
        );
      }
        break;

      case 400:
        _showSnackbar(
          title: "Bad Request",
          message: "Please check your input and try again.",
          type: ResultType.error,
        );
        break;
      case 401:
        _showSnackbar(
          title: "Unauthorized",
          message: "You are not authorized. Please login.",
          type: ResultType.error,
        );
        break;
      case 403:
        _showSnackbar(
          title: "Access Denied",
          message: "You do not have permission.",
          type: ResultType.error,
        );
        break;
      case 404:
        _showSnackbar(
          title: "Not Found",
          message: "The requested resource was not found.",
          type: ResultType.error,
        );
        break;
      case 409:
        _showSnackbar(
          title: "Conflict",
          message: "Mobile number is already registered.",
          type: ResultType.error,
        );
        break;
      case 500:
      case 501:
      case 502:
      case 503:
        _showSnackbar(
          title: "Server Error",
          message: "Something went wrong on our end. Please try again later.",
          type: ResultType.error,
        );
        break;
      default:
        // _showSnackbar(
        //   title: "Error!",
        //   message:
        //   "Unexpected error occurred. Status code: $statusCode",
        //   type: ResultType.error,
        // );
    }
  }

  static void _showSnackbar({
    required String title,
    required String message,
    required ResultType type,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: type == ResultType.success ? Colors.green : Colors.red,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }
}
