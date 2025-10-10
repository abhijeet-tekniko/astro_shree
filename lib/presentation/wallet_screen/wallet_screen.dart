import 'dart:developer';

import 'package:astro_shree_user/core/utils/themes/textStyle.dart';
import 'package:astro_shree_user/data/api_call/recharge_list_api.dart';
import 'package:astro_shree_user/widget/app_bar/appbar_title.dart';
import 'package:astro_shree_user/widget/app_bar/custom_navigate_back_button.dart';
import 'package:astro_shree_user/widget/custom_buttons/custom_Text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/network/endpoints.dart';
import '../../core/network/no_internet_page.dart';
import '../../data/api_call/profile_api.dart';
import '../../services/payment_service.dart';
import '../../widget/custom_buttons/custom_loading.dart';
import '../astro_profile/upload_rating.dart';
import '../pdf_viewer_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final RechargeListApi rechargeListApi = Get.put(RechargeListApi());
  final TextEditingController _amountController = TextEditingController();
  final CheckInternet checkInternet = Get.put(CheckInternet());
  final RechargeListApi controller = Get.put(RechargeListApi());

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    checkInternet.hasConnection();
    rechargeListApi.fetchUserWallet();
    rechargeListApi.fetchRechargeList();
    controller.fetchUserWalletTransaction();
    controller.fetchUserWallet();
  }

  @override
  void dispose() {
    _amountController.dispose();
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
        title: AppbarTitle(
          text: 'Wallet',
          margin: EdgeInsets.only(left: screenWidth * 0.2),
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          loadData();
        },
        child: Obx(() {
          if (rechargeListApi.isLoading.value) {
            return const Center(child: CustomLoadingScreen());
          }
          if (checkInternet.noInternet.value) {
            return Center(child: NoInternetPage(onRetry: loadData));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wallet Balance
                  Row(
                    children: [
                      Text('Wallet Balance', style: TextStyles.bodyText2),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.1,
                        ),
                        child: Text(
                          '₹ ${rechargeListApi.userWallet.value?.data?.wallet?.balance ?? "0"}',
                          style: TextStyles.headline2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.025),

                  // Enter Amount + Button
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.005,
                            ),
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter amount',
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PaymentDetailsScreen(
                                        amount: double.parse(value),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CustomTextButton(
                            text: 'Add Money',
                            textColor: Colors.white,
                            height: screenHeight * 0.05,
                            width: screenWidth * 0.3,
                            onPressed: () {
                              if (_amountController.text.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PaymentDetailsScreen(
                                      amount:
                                          double.parse(_amountController.text),
                                    ),
                                  ),
                                );
                              }
                            },
                            color: const Color(0xFFC62828),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    itemCount:
                        rechargeListApi.rechargeData.value?.data?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.4,
                    ),
                    itemBuilder: (context, index) {
                      final item =
                          rechargeListApi.rechargeData.value!.data![index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentDetailsScreen(
                                amount: double.parse(
                                    item.rechargeAmount.toString()),
                                offerType: item.offerType,
                                offerValue: item.offerValue,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  item.rechargeAmount.toString(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (item.offerType == 'percentage')
                                _buildOfferTag('${item.offerValue}% EXTRA'),
                              if (item.offerType == 'fixed')
                                // _buildOfferTag('₹ ${int.parse(item.offerValue.toString()) - int.parse(item.rechargeAmount.toString())} EXTRA',
                                _buildOfferTag(
                                  '₹ ${int.parse(item.offerValue.toString())} EXTRA',
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 24),
                  Text('Transaction History', style: TextStyles.headline2),
                  SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        controller.userWalletTransaction.value?.data?.length ??
                            0,
                    itemBuilder: (context, index) {
                      final transaction =
                          controller.userWalletTransaction.value!.data![index];
                      final date =
                          DateTime.parse(transaction.createdAt.toString());
                      final formattedDate =
                          DateFormat('MMM dd, yyyy • hh:mm a').format(date);

                      return controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller
                                  .userWalletTransaction.value!.data!.isEmpty
                              ? Center(
                                  child: Text(
                                    'No data found',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : Card(
                                  elevation: 2,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.red[100],
                                              child: const Icon(
                                                  Icons.account_balance_wallet,
                                                  color: Color(0xFFC62828)),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transaction.description
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(formattedDate,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontSize: 14)),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Status: ${transaction.status!.toUpperCase()}',
                                                    style: TextStyle(
                                                      color:
                                                          transaction.status ==
                                                                  'success'
                                                              ? Colors.green
                                                              : Colors.red,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '₹${transaction.amount.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color(0xFFC62828),
                                              ),
                                            ),
                                          ],
                                        ),

                                        /// Add Rating button if type is not 'wallet'
                                        if (transaction.type !=
                                                'walletRecharge' &&
                                            transaction.type != "giftCard") ...[
                                          const SizedBox(height: 12),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                showInAppReviewBottomSheet(
                                                    context,
                                                    transaction.astrologer,
                                                    transaction.sId);
                                              },
                                              icon: const Icon(Icons.star_rate),
                                              label: const Text("Rate"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.orangeAccent,
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],

                                        /// Tap to view invoice
                                        transaction.status == 'success' &&
                                                transaction.type ==
                                                    "walletRecharge"
                                            ? InkWell(
                                                onTap: () {
                                                  print(
                                                      'checkkk=====${transaction.invoice.toString()}');
                                                  Get.to(PdfViewerScreen(
                                                    pdfUrl:
                                                        EndPoints.imageBaseUrl +
                                                            transaction.invoice
                                                                .toString(),
                                                  ));
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8),
                                                  child: Text(
                                                    'View Invoice',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                );
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOfferTag(String label) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class PaymentDetailsScreen extends StatefulWidget {
  final double amount;
  final String? offerType;
  final int? offerValue;

  const PaymentDetailsScreen({
    super.key,
    required this.amount,
    this.offerType,
    this.offerValue,
  });

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final RechargeListApi rechargeListApi = Get.put(RechargeListApi());
  final ProfileApi profileApi = Get.put(ProfileApi());
  late PaymentService _paymentService;

  void _startPayment({
    required String price,
    required String orderId,
    required BuildContext context,
  }) {
    _paymentService.openCheckout(
        price: price,
        userContact: profileApi.mobile.value,
        orderId: orderId,
        context: context);
  }

  @override
  void initState() {
    profileApi.fetchProfile();
    _paymentService = PaymentService(
      onPaymentSuccessCallback: () {
        rechargeListApi.fetchUserWallet();
        rechargeListApi.fetchUserWalletTransaction();
        profileApi.fetchProfile();
      },
    );
    super.initState();

    // Show popup if extraAmount exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_calculateExtraAmount() > 0) {
        _showOfferPopup(context);
      }
    });
  }

  double _calculateExtraAmount() {
    double extraAmount = 0;
    if (widget.offerType == 'percentage' && widget.offerValue != null) {
      extraAmount = widget.amount * (widget.offerValue! / 100);
    } else if (widget.offerType == 'fixed' && widget.offerValue != null) {
      // extraAmount = widget.offerValue! - widget.amount;
      extraAmount = double.parse(widget.offerValue.toString());
    }
    return extraAmount;
  }

  void _showOfferPopup(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final extraAmount = _calculateExtraAmount();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4081), Color(0xFFFF6F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitPumpingHeart(
                  color: Colors.white,
                  size: screenWidth * 0.15,
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  'Offer! 🎉',
                  style: TextStyles.headline2.copyWith(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  'You got an extra ₹${extraAmount.toStringAsFixed(2)}!',
                  style: TextStyles.bodyText2.copyWith(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenWidth * 0.03,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Claim Now!',
                    style: TextStyles.bodyText2.copyWith(
                      color: const Color(0xFFFF4081),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate extra amount based on offer
    final double extraAmount = _calculateExtraAmount();

    // Calculate GST (assuming 18% GST rate)
    const double gstRate = 0.18;
    final double gstAmount = widget.amount * gstRate;
    final double totalAmount =
        widget.amount + gstAmount; // Exclude extraAmount from total

    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: AppbarTitle(
          text: 'Payment Details',
          margin: EdgeInsets.only(left: screenWidth * 0.15),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Summary', style: TextStyles.headline2),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount', style: TextStyles.bodyText2),
                      Text('₹ ${widget.amount.toStringAsFixed(2)}',
                          style: TextStyles.bodyText2),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GST (18%)', style: TextStyles.bodyText2),
                      Text('₹ ${gstAmount.toStringAsFixed(2)}',
                          style: TextStyles.bodyText3),
                    ],
                  ),
                  Divider(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: TextStyles.headline2),
                      Text('₹ ${totalAmount.toStringAsFixed(2)}',
                          style: TextStyles.headline2),
                    ],
                  ),
                ],
              ),
            ),
            if (extraAmount > 0) ...[
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: Text(
                  'Extra Offer: ₹${extraAmount.toStringAsFixed(2)}',
                  style: TextStyles.bodyText2.copyWith(
                    color: const Color(0xFFC62828),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: CustomTextButton(
                text: 'Proceed to Payment',
                textColor: Colors.white,
                height: screenHeight * 0.06,
                width: screenWidth * 0.5,
                onPressed: () async {
                  final walletResponse =
                      await rechargeListApi.fetchUserAddWallet(
                    amount: widget.amount.toInt(),
                    gstAmount: gstAmount.toInt(),
                    context: context,
                  );

                  if (walletResponse != null &&
                      walletResponse.data?.razorpayOrder != null) {
                    _startPayment(
                      price:
                          walletResponse.data!.razorpayOrder!.amount.toString(),
                      orderId: walletResponse.data!.razorpayOrder!.orderId
                          .toString(),
                      context: context,
                    );
                  } else {
                    print('Failed to fetch wallet or razorpay order is null');
                  }
                },
                color: const Color(0xFFC62828),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
