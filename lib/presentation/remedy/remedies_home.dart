import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/api_call/banner_controller.dart';
import '../../data/api_call/product_controller.dart';
import '../../data/model/category_list_model.dart';
import '../../widget/banners.dart';
import '../../widget/custom_image_view.dart';
import '../../widget/shimmer_screen.dart';
import '../e_pooja/pooja_listing.dart';
import '../products/product_list_screen.dart';

class RemediesHome extends StatefulWidget {
  const RemediesHome({super.key});

  @override
  State<RemediesHome> createState() => _RemediesHomeState();
}

class _RemediesHomeState extends State<RemediesHome> {
  final controller = Get.put(ProductController());
  final BannerController bannerController = Get.put(BannerController());
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    controller.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Obx(
          () {
            final originalData = controller.categoryListModel.value!.data!
                .where(
                    (item) => item.name!.toLowerCase().contains(_searchQuery))
                .toList();

            final data = List.from(originalData);
            data.insert(
                0,
                CategoryListData(
                  name: "Pooja",
                  image: "assets/images/poojaImage.png",
                ));

            if (data.isEmpty && controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(children: [
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                    ),
                  ),
                ),
                (bannerController.isBannerLoading.value ||
                        bannerController.banner.value == null)
                    ? Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )
                    : BannerCarouselSlider(
                        banners: bannerController.banner.value!.data!,
                        autoPlay: true,
                        horizontalPadding: 10,
                        imageFit: BoxFit.fill,
                      ),
                const SizedBox(height: 15),
                controller.isLoading.value
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.525,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: 6,
                        itemBuilder: (_, __) => shimmerPlaceholder(),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.525,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          return RemedyCard(
                            title: item.name ?? "",
                            imagePath: item.name!.toLowerCase() != "pooja"
                                ? EndPoints.imageBaseUrl + item.image.toString()
                                : item.image.toString(),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        item.name!.toLowerCase() != "pooja"
                                            ? ProductListingPage(category: item)
                                            : ProductListingScreen(),
                                  ));
                            },
                          );
                        }),
              ]),
            );
          },
        ),
      ),
    );
  }
}

class RemedyCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const RemedyCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: CustomImageView(
                    imagePath: imagePath,
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
