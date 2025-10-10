import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/core/network/response_handler.dart';
import 'package:astro_shree_user/data/model/custome_review_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio_prefix;
import '../../core/network/dio_client.dart';
import '../model/blog_model.dart';
import '../model/news_model.dart';

class BlogApi extends GetxController {
  final dio = DioClient().client;
  var isLoading = false.obs;
  var blogs = <Blog>[].obs;
  var news = <NewsData>[].obs;
  var reviewData = <CustomerReviewData>[].obs;

  Future<void> fetchBlogs() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.blog);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = BlogResponse.fromJson(response.data);
        blogs.value = result.data;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchNews() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.news);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetNewsModel.fromJson(response.data);
        news.value = result.data!;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchTestimonial() async {
    isLoading(true);
    try {
      final response = await dio.get(EndPoints.testimonial);
      var result = response.data;
      print(result['message']);
      if (response.statusCode == 200) {
        final result = GetCustomerReviewModel.fromJson(response.data);
        reviewData.value = result.data!;
      } else {
        print('⚠️ Error: ${response.statusCode}');
        HttpStatusHandler.handle(
          statusCode: response.statusCode,
          customSuccessMessage: "none",
        );
      }
    } on dio_prefix.DioException catch (e) {
      HttpStatusHandler.handle(
        statusCode: e.response?.statusCode,
        customSuccessMessage: "none",
      );
      print('❌ DioException: ${e.message}');
    } finally {
      isLoading(false);
    }
  }
}
