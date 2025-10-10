import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio_prefix;

import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/pooja_controller.dart';
import '../../data/model/get_product_trnasaction_model.dart';
import '../../widget/app_bar/appbar_title.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';



class PoojaTransactionListScreen extends StatefulWidget {
  const PoojaTransactionListScreen({super.key});

  @override
  State<PoojaTransactionListScreen> createState() => _PoojaTransactionListScreenState();
}

class _PoojaTransactionListScreenState extends State<PoojaTransactionListScreen> {
  final controller = Get.put(PoojaController());

  @override
  void initState() {
    controller.fetchPoojaTransaction();
    super.initState();
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
        title:  AppbarTitle(text: 'Pooja Transaction'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)));
        }
        if (controller.getPoojaTransactionModel.value == null ||
            controller.getPoojaTransactionModel.value!.data == null ||
            controller.getPoojaTransactionModel.value!.data!.isEmpty) {
          return const Center(child: Text('No transactions found', style: TextStyle(fontSize: 16)));
        }
        return RefreshIndicator(
          color: const Color(0xFFC62828),
          onRefresh: controller.fetchPoojaTransaction,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.getPoojaTransactionModel.value!.data!.length,
            itemBuilder: (context, index) {
              final transaction = controller.getPoojaTransactionModel.value!.data![index];
              return TransactionCard(transaction: transaction);
            },
          ),
        );
      }),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Data transaction;

  const TransactionCard({super.key, required this.transaction});

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
                // Pooja Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: transaction.pooja?.image != null
                      ? CachedNetworkImage(
                    imageUrl: EndPoints.imageBaseUrl+transaction.pooja!.image!,
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
                          Text(
                            transaction.pooja?.name ?? 'Unknown Pooja',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: const Color(0xFFC62828),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: transaction.poojaStatus == 'Completed'
                                  ? Colors.green[100]
                                  : Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transaction.poojaStatus ?? 'Unknown',
                              style: TextStyle(
                                color: transaction.poojaStatus == 'Completed'
                                    ? Colors.green[800]
                                    : Colors.orange[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.pooja?.shortDescription ?? 'No description available',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 12),
            // Text(
            //   'Transaction ID: ${transaction.transactionId ?? 'N/A'}',
            //   style: theme.textTheme.bodySmall,
            // ),
            // const SizedBox(height: 4),
            // Text(
            //   'Order ID: ${transaction.orderId ?? 'N/A'}',
            //   style: theme.textTheme.bodySmall,
            // ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Astrologer: ${transaction.astrologer?.name ?? 'N/A'}',
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
            // const SizedBox(height: 12),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  transaction.isSettled == true ? 'Settled' : 'Not Settled',
                  style: TextStyle(
                    color: transaction.isSettled == true ? Colors.green[800] : Colors.red[800],
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


// class PoojaTransactionListScreen extends StatefulWidget {
//   const PoojaTransactionListScreen({super.key});
//
//   @override
//   State<PoojaTransactionListScreen> createState() => _PoojaTransactionListScreenState();
// }
//
// class _PoojaTransactionListScreenState extends State<PoojaTransactionListScreen> {
//   final controller = Get.put(PoojaController());
//
//
//   @override
//   void initState() {
//    controller.fetchPoojaTransaction();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: CustomNavigationButton(
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.white,
//         title: AppbarTitle(
//           text: 'Pooja Transactions',
//           // margin: EdgeInsets.only(left: screenWidth * 0.2),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator(color: Color(0xFFC62828)));
//         }
//         if (controller.getPoojaTransactionModel.value == null ||
//             controller.getPoojaTransactionModel.value!.data == null ||
//             controller.getPoojaTransactionModel.value!.data!.isEmpty) {
//           return const Center(child: Text('No transactions found'));
//         }
//         return RefreshIndicator(
//           onRefresh: controller.fetchPoojaTransaction,
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: controller.getPoojaTransactionModel.value!.data!.length,
//             itemBuilder: (context, index) {
//               final transaction = controller.getPoojaTransactionModel.value!.data![index];
//               return TransactionCard(transaction: transaction);
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
//
// class TransactionCard extends StatelessWidget {
//   final Data transaction;
//
//   const TransactionCard({super.key, required this.transaction});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final date = DateTime.parse(transaction.createdAt ?? DateTime.now().toIso8601String());
//     final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   transaction.pooja?.name ?? 'Unknown Pooja',
//                   style: theme.textTheme.titleLarge?.copyWith(
//                     color: const Color(0xFFC62828),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: transaction.poojaStatus == 'Completed'
//                         ? Colors.green[100]
//                         : Colors.orange[100],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     transaction.poojaStatus ?? 'Unknown',
//                     style: TextStyle(
//                       color: transaction.poojaStatus == 'Completed'
//                           ? Colors.green[800]
//                           : Colors.orange[800],
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Transaction ID: ${transaction.transactionId ?? 'N/A'}',
//               style: theme.textTheme.bodySmall,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Order ID: ${transaction.orderId ?? 'N/A'}',
//               style: theme.textTheme.bodySmall,
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'User: ${transaction.user?.name ?? 'N/A'}',
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                     Text(
//                       'Email: ${transaction.user?.email ?? 'N/A'}',
//                       style: theme.textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Amount: ₹${transaction.amount ?? 0}',
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'GST: ₹${transaction.gstAmount?.toStringAsFixed(2) ?? '0.00'}',
//                       style: theme.textTheme.bodySmall,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Text(
//                 //   'Astrologer: ${transaction.astrologer ?? 'N/A'}',
//                 //   style: theme.textTheme.bodyMedium,
//                 // ),
//                 Text(
//                   'Payment: ${transaction.paymentMethod ?? 'N/A'}',
//                   style: theme.textTheme.bodyMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   formattedDate,
//                   style: theme.textTheme.bodySmall,
//                 ),
//                 Text(
//                   transaction.isSettled == true ? 'Settled' : 'Not Settled',
//                   style: TextStyle(
//                     color: transaction.isSettled == true
//                         ? Colors.green[800]
//                         : Colors.red[800],
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
