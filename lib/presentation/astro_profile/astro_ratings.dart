import 'package:astro_shree_user/data/api_call/astrologers_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../core/utils/themes/textStyle.dart';
import 'astrologer_rating_model.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import '../../widget/custom_image_view.dart';

class RatingsController extends GetxController {
  final AstrologersApi controller = Get.put(AstrologersApi());
  final RxList<Rating> ratings = <Rating>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  final int _limit = 10;
  int _currentPage = 1;
  String astrologerId = "";

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
  }

  void setAstrologerId(String id) {
    astrologerId = id;
    _currentPage = 1;
    ratings.clear();
    hasMore.value = true;
    fetchRatings();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        hasMore.value) {
      fetchRatings();
    }
  }

  Future<void> fetchRatings() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    final data = await controller.fetchAstrologersRatings(
      astrologerId,
      page: _currentPage,
      limit: _limit,
    );

    if (data != null) {
      if (data.ratings.length < _limit) {
        hasMore.value = false;
      }
      ratings.addAll(data.ratings);
      _currentPage++;
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class RatingsPage extends StatefulWidget {
  final String astrologerId;
  final String astrologerName;
  const RatingsPage(
      {super.key, required this.astrologerId, required this.astrologerName});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  final RatingsController controller = Get.put(RatingsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.setAstrologerId(widget.astrologerId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
          title: AppbarTitle(
            text: widget.astrologerName,
            margin: EdgeInsets.only(left: 8),
          ),
        ),
        body: Obx(() {
          if (controller.ratings.isEmpty && controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              ListView.builder(
                controller: controller.scrollController,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.ratings.length,
                itemBuilder: (context, index) {
                  final data = controller.ratings[index];

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              CustomImageView(
                                height: 40,
                                radius: BorderRadius.circular(60),
                                width: 40,
                                fit: BoxFit.fill,
                                imagePath: data.user.profileImage,
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.user.name),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: _buildStarRow(data.rating),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(data.createdAt
                                      .toLocal()
                                      .toString()
                                      .split(" ")
                                      .first),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.comment??"",
                          style: TextStyles.bodyText5,
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (controller.isLoading.value)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                )
            ],
          );
        }));
  }

  List<Widget> _buildStarRow(int rating) {
    return List.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        size: 16,
        color: Colors.yellow[700],
      );
    });
  }
}
