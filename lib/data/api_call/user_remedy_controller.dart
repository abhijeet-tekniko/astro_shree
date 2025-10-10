import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../core/utils/sharePrefs/prefsKeys.dart';
import '../../core/utils/sharePrefs/prefsUtils.dart';
import '../model/user_remedy_model.dart';

class UserRemedyController extends GetxController {
  final Dio _dio = Dio();

  RxList<RemedyData> remedyList = <RemedyData>[].obs;
  RxList<String> categories = <String>[].obs;

  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;

  RxString selectedCategory = ''.obs;
  RxString searchQuery = ''.obs;

  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchRemedies(reset: true);
  }

  Future<void> fetchRemedies({bool reset = false}) async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    try {
      if (reset) {
        remedyList.clear();
        currentPage.value = 1;
        hasMore.value = true;
      }
      final token = await PrefsUtils.getString(PrefsKeys.userToken);

      final response = await _dio.get(
        'http://167.71.232.245:4856/api/user/suggestedProduct',
        queryParameters: {
          "page": currentPage.value,
          "limit": pageSize,
          "category": selectedCategory.value.isNotEmpty ? selectedCategory.value : null,
          "search": searchQuery.value.isNotEmpty ? searchQuery.value : null,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final model = GetRemedyListModel.fromJson(response.data);
      if (model.data != null && model.data!.isNotEmpty) {
        remedyList.addAll(model.data!);
        if (model.data!.length < pageSize) {
          hasMore.value = false;
        } else {
          currentPage.value++;
        }
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      print("Error fetching remedies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchCategories() async {
    try {
      final token = await PrefsUtils.getString(PrefsKeys.userToken);
      final response = await _dio.get('http://167.71.232.245:4856/api/user/category',  options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),);
      if (response.statusCode == 200 && response.data is List) {
        categories.assignAll(List<String>.from(response.data));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query.trim();
    fetchRemedies(reset: true);
  }

  void onCategoryChanged(String category) {
    selectedCategory.value = category;
    fetchRemedies(reset: true);
  }
}
