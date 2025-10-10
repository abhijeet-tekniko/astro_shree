import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/data/model/product_transaction_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/product_controller.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import '../../widget/shimmer_screen.dart';


class ProductTransactionListScreen extends StatefulWidget {
  const ProductTransactionListScreen({Key? key}) : super(key: key);

  @override
  State<ProductTransactionListScreen> createState() => _ProductTransactionListScreenState();
}

class _ProductTransactionListScreenState extends State<ProductTransactionListScreen> {
  final controller = Get.put(ProductController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchProductTransaction(page: 1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !controller.isLoadingMore.value &&
          controller.currentProductPage.value < (controller.getProductTransactionModel.value?.totalPage ?? 1)) {
        controller.fetchProductTransaction(page: controller.currentProductPage.value + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: AppbarTitle(text: 'Product Transaction'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.getProductTransactionModel.value == null) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)));
        }
        if (controller.getProductTransactionModel.value == null ||
            controller.getProductTransactionModel.value!.data == null ||
            controller.getProductTransactionModel.value!.data!.isEmpty) {
          return const Center(child: Text('No transactions found', style: TextStyle(fontSize: 16)));
        }
        return RefreshIndicator(
          color: const Color(0xFFC62828),
          onRefresh: () => controller.fetchProductTransaction(page: 1),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.getProductTransactionModel.value!.data!.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.getProductTransactionModel.value!.data!.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: Color(0xFFC62828)),
                  ),
                );
              }
              final transaction = controller.getProductTransactionModel.value!.data![index];
              return ProductTransactionCard(transaction: transaction);
            },
          ),
        );
      }),
    );
  }
}

class ProductTransactionCard extends StatelessWidget {
  final EProductData transaction;

  const ProductTransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = DateTime.parse(transaction.createdAt ?? DateTime.now().toIso8601String());
    final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: transaction.product?.image != null && transaction.product!.image!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: EndPoints.imageBaseUrl + transaction.product!.image!.first.toString(),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(
                      color: Color(0xFFC62828),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      size: 60,
                      color: Colors.grey,
                    ),
                  )
                      : const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              transaction.product?.name?.capitalizeFirst ?? 'Unknown Product',
                              maxLines: 2,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: const Color(0xFFC62828),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: transaction.status == 'completed'
                                  ? Colors.green[100]
                                  : transaction.status == 'pending'
                                  ? Colors.orange[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transaction.status ?? 'Unknown',
                              style: TextStyle(
                                color: transaction.status == 'completed'
                                    ? Colors.green[800]
                                    : transaction.status == 'pending'
                                    ? Colors.orange[800]
                                    : Colors.red[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   transaction.product?.description ?? 'No description available',
                      //   style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),

                      Text(
                        transaction.product?.benefits ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User: ${transaction.user?.name ?? 'N/A'}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'Payment: ${transaction.paymentMethod ?? 'N/A'}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Amount: ₹${transaction.amount ?? 0}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'GST: ₹${transaction.gstAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  transaction.deliverStatus ?? 'Not Delivered',
                  style: TextStyle(
                    color: transaction.deliverStatus == 'delivered' ? Colors.green[800] : Colors.red[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}