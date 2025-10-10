import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/core/utils/themes/appThemes.dart';
import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/data/api_call/recharge_list_api.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_Text_button.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/navigator_service.dart';
import '../../routes/app_routes.dart';
import '../pdf_viewer_screen.dart';

class TransactionScreen1 extends StatefulWidget {
  const TransactionScreen1({super.key});

  @override
  State<TransactionScreen1> createState() => _TransactionScreen1State();
}

class _TransactionScreen1State extends State<TransactionScreen1> {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title:AppbarTitle(
          text: 'Transaction',
          margin: EdgeInsets.only(left:screenWidth * 0.2),
        )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFF3F3F3),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wallet Balance', style: TextStyles.headline1),
                        Text('₹320', style: TextStyles.headline2),
                      ],
                    ),
                    Spacer(),
                    CustomTextButton(
                      text: 'Recharge',
                      textColor: Colors.white,
                      height: screenHeight * 0.05,
                      width: screenWidth * 0.3,
                      onPressed: () {},
                      color: const Color(0xFFC62828),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text('Transactions', style: TextStyles.headline4),
                    Spacer(),
                    Text('See all'),
                  ],
                ),
              ),
              Container(
                height: screenHeight, // Adjust height as needed
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: screenHeight * 0.1,
                        color: const Color(0xFFF3F3F3),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Top up', style: TextStyles.bodyText2),
                                Text('Today 01:53 PM', style: TextStyles.caption),
                              ],
                            ),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('+₹100', style: TextStyles.bodyText2),
                                Text('Deposit', style: TextStyles.caption),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



///


class TransactionScreen extends StatefulWidget {
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final double walletBalance = 489;

  final RechargeListApi controller=Get.put(RechargeListApi());

  @override
  void initState() {
controller.fetchUserWalletTransaction();
controller.fetchUserWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Wallet Transactions',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFC62828),
      ),
      body:
     Obx((){
       return controller.isLoading.value?Center(child: CustomLoadingScreen(),):  Column(
         children: [
           // Wallet Balance Section
           Container(
             padding: EdgeInsets.all(20),
             color:Color(0xFFC62828),
             child: Column(
               children: [
                 // Text(
                 //   'Wallet Balance',
                 //   style: TextStyle(
                 //     color: Colors.white,
                 //     fontSize: 18,
                 //     fontWeight: FontWeight.w400,
                 //   ),
                 // ),
                 // SizedBox(height: 10),
                 Text(
                   // '₹${walletBalance.toStringAsFixed(2)}',
                   '₹${controller.userWallet.value?.data?.wallet?.balance??0}',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 32,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 SizedBox(height: 20),
                 ElevatedButton(
                   onPressed: () {
                     NavigatorService.pushNamed(AppRoutes.walletScreen);
                   },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     foregroundColor:Color(0xFFC62828),
                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(30),
                     ),
                   ),
                   child: Text(
                     'Add Money',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ],
             ),
           ),
           // Transaction List Section
           Expanded(
             child: ListView.builder(
               padding: EdgeInsets.all(16),
               // itemCount: transactions.length,
               itemCount: controller.userWalletTransaction.value!.data!.length,
               itemBuilder: (context, index) {
                 final transaction = controller.userWalletTransaction.value!.data![index];
                 final date = DateTime.parse(transaction.createdAt.toString());
                 final formattedDate = DateFormat('MMM dd, yyyy • hh:mm a').format(date);

                 return Card(
                   elevation: 2,
                   margin: EdgeInsets.symmetric(vertical: 8),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: ListTile(
                     contentPadding: EdgeInsets.all(16),
                     leading: CircleAvatar(
                       backgroundColor: Colors.red[100],
                       child: Icon(
                         Icons.account_balance_wallet,
                         color: Color(0xFFC62828),
                       ),
                     ),
                     title: Text(
                       transaction.description.toString(),
                       style: TextStyle(
                         fontWeight: FontWeight.w600,
                         fontSize: 16,
                       ),
                     ),
                     subtitle: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: 4),
                         Text(
                           formattedDate,
                           style: TextStyle(
                             color: Colors.grey[600],
                             fontSize: 14,
                           ),
                         ),
                         SizedBox(height: 4),
                         Text(
                           'Status: ${transaction.status!.toUpperCase()}',
                           style: TextStyle(
                             color: transaction.status == 'success' ? Colors.green : Colors.red,
                             fontSize: 14,
                           ),
                         ),
                       ],
                     ),
                     trailing: Text(
                       '₹${transaction.amount.toStringAsFixed(2)}',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                         color: Color(0xFFC62828),
                       ),
                     ),
                     onTap: (){
                       Get.to(PdfViewerScreen(pdfUrl: EndPoints.imageBaseUrl+transaction.invoice.toString(),));
                     },
                   ),
                 );
               },
             ),
           ),
         ],
       );
     })
    );
  }
}