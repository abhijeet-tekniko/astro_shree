import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/data/api_call/pooja_controller.dart';
import 'package:astro_shree_user/data/model/pooja_model.dart';
import 'package:astro_shree_user/presentation/astro_profile/astrologers_profile.dart';
import 'package:astro_shree_user/presentation/home_screen/home_page.dart';
import 'package:astro_shree_user/widget/shimmer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/profile_api.dart';
import '../../services/payment_service.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import '../../widget/homepagewidgets/top_astrologers_card.dart';
import '../home_screen/home_screen.dart';
import 'package:astro_shree_user/data/model/pooja_detail_model.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final controller = Get.put(PoojaController());

  @override
  void initState() {
    controller.fetchPooja();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: const Text(
          'Pooja Booking',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await controller.fetchPooja();
        },
        child: Obx(() {
          final poojas = controller.poojaList;
          return controller.isLoading.value
              ? ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: 6, // shimmer placeholders
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: shimmerPlaceholder(),
                  ),
                )
              : poojas.isEmpty
                  ? Center(
                      child: Text('No Booking'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: poojas.length,
                      itemBuilder: (context, index) {
                        final pooja = poojas[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                EndPoints.imageBaseUrl + pooja.image.toString(),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported,
                                      size: 40),
                                ),
                              ),
                            ),
                            title: Text(
                              pooja.name ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              pooja.shortDescription ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      poojaId: pooja.sId.toString(),
                                    ),
                                  ));
                            },
                          ),
                        );
                      },
                    );
        }),
      ),
    );
  }
}

const headlineLarge =
    TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87);
const headlineMedium =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87);
const bodyLarge = TextStyle(fontSize: 16, color: Colors.black54);
const bodyMedium = TextStyle(fontSize: 14, color: Colors.black54);
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFFC62828),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  elevation: 2,
);
var cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: const BorderRadius.all(Radius.circular(16)),
  border: Border.all(color: Color(0xFFC62828)),
  boxShadow: const [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
);

class ProductDetailScreen extends StatefulWidget {
  // final PoojaData pooja;
  final String poojaId;
  const ProductDetailScreen({super.key, required this.poojaId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final controller = Get.put(PoojaController());

  @override
  void initState() {
    controller.fetchDetailPooja(poojaId: widget.poojaId);
    super.initState();
  }

  String? selectedAstrologer;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: controller.isPoojaDetailLoading.value
            ? SizedBox.shrink()
            : Text(
                controller.poojaDetailModel.value!.data!.name
                    .toString()
                    .toUpperCase(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
        elevation: 0,
      ),
      body: Obx(() {
        return controller.isPoojaDetailLoading.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: shimmerPlaceholder(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        EndPoints.imageBaseUrl +
                            controller.poojaDetailModel.value!.data!.image
                                .toString(),
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 200),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.poojaDetailModel.value!.data!.name
                          .toString()
                          .toUpperCase(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller
                              .poojaDetailModel.value!.data!.shortDescription ??
                          "",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      // style: bodyLarge.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'About',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.poojaDetailModel.value!.data!.about!
                          .replaceAll('\r\n', '\n'),
                      // style: bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Benefits',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...controller.poojaDetailModel.value!.data!.benefits!
                        .map((benefit) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(
                                    ' $benefit',
                                  )),
                                ],
                              ),
                            )),
                  ],
                ),
              );
      }),
      bottomNavigationBar: Obx(() {
        return controller.isPoojaDetailLoading.value
            ? Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: shimmerPlaceholder(),
              )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    if (controller.poojaDetailModel.value!.data!.sellPrice !=
                        null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          children: [
                            // Original Price with strikethrough
                            Text(
                              'Price: ₹${controller.poojaDetailModel.value!.data!.price!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    8), // space between original and discounted price

                            // Discounted Sell Price
                            Text(
                              '₹${controller.poojaDetailModel.value!.data!.sellPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC62828),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AstrologerSelectionScreen(
                                  pooja:
                                      controller.poojaDetailModel.value!.data!,
                                  selectedAstrologerId: selectedAstrologer,
                                ),
                              ),
                            );
                          },
                          style: elevatedButtonStyle.copyWith(
                            minimumSize: WidgetStatePropertyAll(
                                Size(screenWidth - 60, 30)),
                          ),
                          child: const Text('Proceed',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
      }),
    );
  }
}

// Astrologer Selection Screen
class AstrologerSelectionScreen extends StatefulWidget {
  final Data pooja;
  final String? selectedAstrologerId;

  const AstrologerSelectionScreen(
      {super.key, required this.pooja, this.selectedAstrologerId});

  @override
  State<AstrologerSelectionScreen> createState() =>
      _AstrologerSelectionScreenState();
}

class _AstrologerSelectionScreenState extends State<AstrologerSelectionScreen> {
  final controller = Get.put(PoojaController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchPoojaAstro(poojaId: widget.pooja.sId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: const Text(
          'Select Astrologer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        final astrologers = controller.poojaAstroList;
        return controller.isLoading.value
            ? ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 6, // shimmer placeholders
                padding: const EdgeInsets.all(12),
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: shimmerPlaceholder(),
                ),
              )
            : astrologers.isEmpty
                ? Center(
                    child: Text('No astrologer'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: astrologers.length,
                    itemBuilder: (context, index) {
                      final astrologer = astrologers[index];

                      return Obx(() {
                        bool isSelected =
                            controller.selectedIndex.value == index;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  pooja: widget.pooja,
                                  selectedAstrologer:
                                      astrologer.astrologer!.sId.toString(),
                                  selectedAstrologerName:
                                      astrologer.astrologer!.name,
                                  sellPrice: widget.pooja.sellPrice,
                                  // sellPrice: astrologer.sellPrice,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: TopAstrologersListCard(
                              imageUrl: EndPoints.base +
                                  astrologer.astrologer!.profileImage
                                      .toString(),
                              name: astrologer.astrologer!.name.toString(),
                              position: astrologer.astrologer!.speciality!
                                  .map((e) => e.name.toString())
                                  .join(', '),
                              language:
                                  astrologer.astrologer!.language!.join(', '),
                              charge: "${astrologer.astrologer!.pricing!.chat}",
                              comesFrom: 'selectAstro',
                              isCall: false,
                              isChat: astrologer.astrologer!.services!.chat!,
                              isPopular: index % 3 == 0,
                              status: astrologer.astrologer!.status ?? "",
                              isBusy: astrologer.astrologer!.isBusy!,
                              experience:
                                  astrologer.astrologer!.experience.toString(),
                              maxDuration: "",
                              onPressed: () {},
                              onTap: () {
                                Get.to(() => AstrologersProfile(
                                    astroId: astrologer.astrologer!.sId!));
                              },
                            ),
                          ),
                        );
                      });
                    },
                  );
      }),
    );
  }
}

// Checkout Screen
class CheckoutScreen extends StatefulWidget {
  final Data pooja;
  final String? selectedAstrologer;
  final String? selectedAstrologerName;
  final int? sellPrice;

  const CheckoutScreen({
    super.key,
    required this.pooja,
    this.selectedAstrologer,
    this.selectedAstrologerName,
    this.sellPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  var controller = Get.put(PoojaController());
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
    _paymentService = PaymentService(
      onPaymentSuccessCallback: () {
        Get.offAll(() => HomeScreen());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const double gstRate = 0.18; // 18% GST
    final int basePrice = widget.sellPrice /*?? widget.pooja.sellPrice*/ ?? 0;
    final double gstAmount = basePrice * gstRate;
    final double totalPrice = basePrice + gstAmount;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CustomNavigationButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: AppTheme.lightTheme.appBarTheme.iconTheme,
        title: const Text(
          'Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checkout for ${widget.pooja.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (widget.selectedAstrologer != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: cardDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person,
                          color: Color(0xFFC62828), size: 30),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Astrologer: ${widget.selectedAstrologerName ?? widget.selectedAstrologer}',
                          style: bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: cardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Details',
                      style: headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Base Price:', style: bodyLarge),
                        Text('₹${basePrice.toStringAsFixed(2)}',
                            style: bodyLarge),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GST (18%):', style: bodyLarge),
                        Text('₹${gstAmount.toStringAsFixed(2)}',
                            style: bodyLarge),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price:',
                          style:
                              headlineMedium.copyWith(color: Color(0xFFC62828)),
                        ),
                        Text(
                          '₹${totalPrice.toStringAsFixed(2)}',
                          style:
                              headlineMedium.copyWith(color: Color(0xFFC62828)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SafeArea(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Payment Processed Successfully!')),
                    // );

                    await controller.purchasePooja(
                        poojaId: widget.pooja.sId.toString(),
                        astroId: widget.selectedAstrologer.toString(),
                        amount: widget.sellPrice!.toInt(),
                        gstAmount: gstAmount.toInt(),
                        context: context);
                    _startPayment(
                        price: totalPrice.toString(),
                        orderId: controller
                            .createPoojaModel.value!.data!.transaction!.orderId
                            .toString(),
                        context: context);
                  },
                  style: elevatedButtonStyle.copyWith(
                    minimumSize:
                        WidgetStatePropertyAll(Size(screenWidth - 60, 30)),
                  ),
                  child: const Text('Confirm Payment',
                      style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
