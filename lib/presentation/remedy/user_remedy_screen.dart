import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/api_call/user_remedy_controller.dart';

class UserRemedyListScreen extends StatelessWidget {
  final UserRemedyController controller = Get.put(UserRemedyController());
  final ScrollController _scrollController = ScrollController();

  UserRemedyListScreen({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        controller.fetchRemedies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Suggested Remedies"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Obx(() => DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  hint: const Text("Filter by Category"),
                  items: controller.categories
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) controller.onCategoryChanged(val);
                  },
                )),
                const SizedBox(height: 10),
                TextField(
                  onChanged: controller.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search remedies...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.remedyList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchRemedies(reset: true),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.remedyList.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.remedyList.length) {
                final remedy = controller.remedyList[index];

                // First show product if available, else pooja
                final product = remedy.product?.isNotEmpty == true ? remedy.product!.first : null;
                final pooja = remedy.pooja?.isNotEmpty == true ? remedy.pooja!.first : null;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: InkWell(
                    onTap: (){
                      // Get.to(page)pag
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Row(
                        children: [
                          // LEFT: Image
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                            child: Image.network(
                                product?.thumbImage!=null?   EndPoints.imageBaseUrl+product!.thumbImage.toString(): EndPoints.imageBaseUrl+pooja!.image.toString() ?? '',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                          ),
                    
                          // RIGHT: Text Info
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product?.name ?? pooja?.name ?? "Untitled Remedy",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product?.benefits ?? pooja?.purpose ?? '',
                                    style: const TextStyle(color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (product?.sellPrice != null || pooja?.sellPrice != null)
                                        Text(
                                          "₹${product?.sellPrice ?? pooja?.sellPrice}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      if ((product?.price != null && product!.price != product.sellPrice) ||
                                          (pooja?.price != null && pooja!.price != pooja.sellPrice))
                                        Text(
                                          "₹${product?.price ?? pooja?.price}",
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // return Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                //   child: Card(
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                //     elevation: 4,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         if (product != null)
                //           ClipRRect(
                //             borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                //             child: Image.network(
                //               EndPoints.imageBaseUrl+product.thumbImage.toString() ?? '',
                //               height: 180,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //               errorBuilder: (context, error, stackTrace) => Container(
                //                 height: 180,
                //                 color: Colors.grey[200],
                //                 child: const Center(child: Icon(Icons.broken_image)),
                //               ),
                //             ),
                //           )
                //         else if (pooja != null)
                //           ClipRRect(
                //             borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                //             child: Image.network(
                //               EndPoints.imageBaseUrl+pooja.image.toString() ?? '',
                //               height: 180,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //               errorBuilder: (context, error, stackTrace) => Container(
                //                 height: 180,
                //                 color: Colors.grey[200],
                //                 child: const Center(child: Icon(Icons.broken_image)),
                //               ),
                //             ),
                //           ),
                //         Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                 product?.name ?? pooja?.name ?? "Unnamed Remedy",
                //                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //               ),
                //               const SizedBox(height: 8),
                //               Text(
                //                 product?.benefits ?? pooja?.purpose ?? '',
                //                 maxLines: 2,
                //                 overflow: TextOverflow.ellipsis,
                //                 style: const TextStyle(color: Colors.grey),
                //               ),
                //               const SizedBox(height: 12),
                //               Row(
                //                 children: [
                //                   if (product?.sellPrice != null || pooja?.sellPrice != null)
                //                     Text(
                //                       "₹${product?.sellPrice ?? pooja?.sellPrice}",
                //                       style: const TextStyle(
                //                           fontWeight: FontWeight.bold, fontSize: 16),
                //                     ),
                //                   const SizedBox(width: 8),
                //                   if ((product?.price != null && product!.price != product.sellPrice) ||
                //                       (pooja?.price != null && pooja!.price != pooja.sellPrice))
                //                     Text(
                //                       "₹${product?.price ?? pooja?.price}",
                //                       style: const TextStyle(
                //                         decoration: TextDecoration.lineThrough,
                //                         color: Colors.red,
                //                       ),
                //                     ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }
}

