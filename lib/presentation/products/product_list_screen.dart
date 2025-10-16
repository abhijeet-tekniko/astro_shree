import 'dart:async';
import 'dart:ui';
import 'package:astro_shree_user/core/network/endpoints.dart';
import 'package:astro_shree_user/core/network/response_handler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../core/utils/themes/appThemes.dart';
import '../../data/api_call/address_controller.dart';
import '../../data/api_call/product_controller.dart';
import '../../data/api_call/profile_api.dart';
import '../../data/model/category_list_model.dart';
import '../../data/model/get_shipping_address_model.dart';
import '../../data/model/product_details.dart' as detail;
import '../../services/payment_service.dart';
import '../../widget/app_bar/custom_navigate_back_button.dart';
import '../../widget/shimmer_screen.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final controller = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    controller.fetchCategory();
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
            'Categories',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await controller.fetchCategory();
          },
          child: Obx(() {
            return controller.isLoading.value
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 6,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: shimmerPlaceholder(),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount:
                        controller.categoryListModel.value?.data!.length ?? 0,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final category =
                          controller.categoryListModel.value!.data![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductListingPage(category: category),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Image.network(
                                  EndPoints.imageBaseUrl + category.image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    category.name!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
        ));
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String description;

  Product(
      {required this.name,
      required this.imageUrl,
      required this.price,
      required this.description});
}

class ProductListingPage extends StatefulWidget {
  final CategoryListData category;

  const ProductListingPage({super.key, required this.category});

  @override
  ProductListingPageState createState() => ProductListingPageState();
}

class ProductListingPageState extends State<ProductListingPage> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Timer? _debounce;
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      productController.currentPage.value = 1;
      productController.hasMore.value = true;
      productController.products.clear();
      productController.loadMoreProducts(widget.category.sId.toString());
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        productController.loadMoreProducts(widget.category.sId.toString());
      }
    });
  }

  Future<void> _refreshProducts() async {
    setState(() {
      productController.products.clear();
      productController.currentPage.value = 1;
      productController.hasMore.value = true;
      productController.isProductLoading.value = false;
    });

    productController.loadMoreProducts(widget.category.sId.toString());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  String stripHtmlTags(String htmlText) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.category.name!.toUpperCase(),
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce =
                      Timer(const Duration(milliseconds: 300), () async {
                    _searchQuery = value.toLowerCase();

                    productController.products.clear();
                    productController.currentPage.value = 1;
                    productController.hasMore.value = true;

                    if (value.length > 2) {
                      await productController.loadMoreProducts(
                        widget.category.sId.toString(),
                        search: _searchQuery,
                      );
                    } else if (value.isEmpty) {
                      await productController.loadMoreProducts(
                        widget.category.sId.toString(),
                        search: "",
                      );
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Products...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                var isLoading = productController.isProductLoading.value;

                final allProducts = productController.products;
                isLoading = productController.isProductLoading.value;

                if (allProducts.isEmpty && isLoading) {
                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: 6,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: shimmerPlaceholder(),
                      ),
                    ),
                  );
                }

                if (allProducts.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No products available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 210,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: screenHeight * 0.001050),
                    itemCount: allProducts.length + (isLoading ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index == allProducts.length) {
                        return Row(
                          children: [
                            const Center(child: SizedBox()),
                            Spacer(),
                            const Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }

                      final product = allProducts[index];

                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailPage(product: product.sId!),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.network(
                                  EndPoints.imageBaseUrl +
                                      (product.thumbImage ?? ''),
                                  width: 200,
                                  height: 100,
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 200,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.broken_image,
                                        size: 40, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name ?? "",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (product.productVariant != null &&
                                            product.productVariant!
                                                .isNotEmpty) ...[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '₹${product.productVariant?.first.price?.toStringAsFixed(2) ?? '0.00'}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '₹${product.productVariant?.first.sellPrice?.toStringAsFixed(2) ?? '0.00'}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  // color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 22,
                                            width: 35,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              'Buy',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final String product;
  final String? referral;

  const ProductDetailPage({super.key, required this.product, this.referral});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final controller = Get.put(ProductController());
  int _quantity = 1;
  detail.ProductVariant? _selectedVariant;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchProductDetails(widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double? percentage = 0;
      final data = controller.productDetails.value;

      if (controller.isProductLoading.value) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (data == null) {
        return Scaffold(
            body: Center(
          child: Text("No Data Found"),
        ));
      }
      if (data.productVariant != null && data.productVariant!.isNotEmpty) {
        if (data.productVariant?.first.sellPrice != null &&
            data.productVariant?.first.price != null &&
            data.productVariant?.first.price != 0) {
          percentage = double.parse((((data.productVariant!.first.sellPrice! -
                          data.productVariant!.first.price!) /
                      data.productVariant!.first.price!) *
                  100)
              .abs()
              .toStringAsFixed(2));
        }
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            data.name.toString().toUpperCase(),
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: ListView(
          children: [
            ProductImages(
              imageUrls: data.image,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                data.name.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (data.productVariant != null && data.productVariant!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '₹${data.productVariant?.first.sellPrice ?? 0}  ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '₹${data.productVariant?.first.price ?? '0.00'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                          ),
                        ),
                        Text(
                          ' ${percentage.toInt()}% Off',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quantity:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (data.productVariant != null && data.productVariant!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Your Option:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: data.productVariant!.map((variant) {
                        final isSelected = _selectedVariant?.id == variant.id;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedVariant = variant;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.red.shade50
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  variant.name ?? '',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "₹${variant.price}  ",
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: isSelected
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "₹${variant.sellPrice}",
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Description: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Html(
                data: data.description.toString().trim() ?? '',
                style: {
                  '*': Style(maxLines: 10, textOverflow: TextOverflow.ellipsis),
                },
              ),
            ),
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Benefits: ",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Html(
                data: data.benefits.toString().trim(),
                style: {
                  '*': Style(maxLines: 10, textOverflow: TextOverflow.ellipsis),
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _selectedVariant == null
                            ? () {
                                Get.snackbar("Error", "Choose a Option",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white);
                              }
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ShippingAddressScreen(),
                                  ),
                                ).then((selectedAddress) {
                                  if (selectedAddress != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutPage(
                                          product: data,
                                          quantity: _quantity,
                                          selectedAddress: selectedAddress,
                                          selectedVariant: _selectedVariant,
                                          referral: widget.referral,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedVariant == null
                              ? Colors.grey
                              : Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: Text(
                          "Buy Now",
                          style: TextStyle(
                              color: _selectedVariant == null
                                  ? Colors.white38
                                  : Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final controller = Get.put(ProductController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        controller.fetchShippingAddress();
      },
    );
    super.initState();
  }

  ShippingAddress? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Shipping Address'),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () async {
                final newAddress = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAddressScreen(),
                  ),
                );
                if (newAddress != null) {
                  // setState(() {
                  controller.addresses.add(newAddress);
                  // });
                }
              },
            ),
          ],
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? shimmerPlaceholder()
              : controller.addresses.isEmpty
                  ? Center(child: Text('No Address Added'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: controller.addresses.length,
                      itemBuilder: (context, index) {
                        final address = controller.addresses[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: RadioListTile<ShippingAddress>(
                            value: address,
                            groupValue: _selectedAddress,
                            onChanged: (value) {
                              // setState(() {
                              _selectedAddress = value;
                              // });
                              Navigator.pop(context, value);
                            },
                            title: Text(address.name ?? ""),
                            subtitle: Text(
                              '${address.address}, ${address.city}, ${address.state} - ${address.pincode}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            secondary: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.grey),
                              onPressed: () async {
                                final updatedAddress = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddAddressScreen(address: address),
                                  ),
                                );
                                if (updatedAddress != null) {
                                  // setState(() {
                                  controller.addresses[index] = updatedAddress;
                                  // });
                                }
                              },
                            ),
                          ),
                        );
                      },
                    );
        }));
  }
}

///checkout

class CheckoutPage extends StatefulWidget {
  final detail.ProductFullDetails product;
  final int quantity;
  final ShippingAddress selectedAddress;
  final detail.ProductVariant? selectedVariant;
  final String? referral;

  const CheckoutPage({
    super.key,
    this.referral,
    required this.product,
    required this.quantity,
    required this.selectedAddress,
    required this.selectedVariant,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _couponController = TextEditingController();
  final FocusNode _couponFocusNode = FocusNode();
  final profileApi = Get.put(ProfileApi());
  final ProductController productController = Get.put(ProductController());
  final PaymentService _paymentService = PaymentService();
  String _couponCode = '';
  double _discount = 0.0;
  final double _gstRate = 0.03;
  final double _shippingCharge = 0;

  double get _subtotal =>
      double.parse(widget.selectedVariant!.sellPrice.toString()) *
      widget.quantity;
  double get _gstAmount => _subtotal * _gstRate;
  double get _total => _subtotal + _gstAmount + _shippingCharge - _discount;

  void _applyCoupon() {
    if (_couponController.text.isNotEmpty) {
      setState(() {
        if (_couponController.text.toLowerCase() == 'save10') {
          _couponCode = _couponController.text;
          _discount = _subtotal * 0.1; // 10% discount
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Coupon applied successfully!'),
              backgroundColor: Colors.green.shade600,
            ),
          );
        } else {
          _discount = 0.0;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invalid coupon code'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      });
    }
  }

  void _removeCoupon() {
    setState(() {
      _couponCode = '';
      _discount = 0.0;
      _couponController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Coupon removed'),
          backgroundColor: Colors.red.shade600,
        ),
      );
      FocusScope.of(context).requestFocus(_couponFocusNode);
    });
  }

  void _startPayment({
    required String price,
    required String orderId,
    required BuildContext context,
  }) {
    _paymentService.openCheckout(
      price: price,
      orderId: orderId,
      context: context,
      userContact: profileApi.mobile.value,
    );
  }

  void _handlePayment() async {
    print("referral : ${widget.referral}");
    final createProduct = {
      "product": widget.product.id.toString(),
      "shipping": widget.selectedAddress.sId.toString(),
      "quantity": widget.quantity,
      "referralCode": widget.referral ?? "",
      "gstAmount": _gstAmount.toStringAsFixed(2),
      "referral": _couponController.text,
    };

    print('createProductCheck===$createProduct');

    final walletResponse = await productController.createPurchaseProduct(
      product: widget.product.id.toString(),
      shipping: widget.selectedAddress.sId.toString(),
      quantity: widget.quantity,
      gstAmount: _gstAmount.toStringAsFixed(2),
      productVariant: widget.selectedVariant!.id,
      context: context,
    );

    if (walletResponse != null && walletResponse.data != null) {
      _startPayment(
        price: walletResponse.data!.transaction!.amount.toString(),
        orderId: walletResponse.data!.transaction!.orderId.toString(),
        context: context,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to process payment'),
          backgroundColor: Colors.red.shade600,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow('Product', widget.product.name.toString()),
                    _buildSummaryRow('Quantity', widget.quantity.toString()),
                    _buildSummaryRow('Price',
                        '₹${widget.selectedVariant!.sellPrice!.toStringAsFixed(2)}'),
                    const Divider(height: 20),
                    _buildSummaryRow(
                        'Subtotal', '₹${_subtotal.toStringAsFixed(2)}'),
                    _buildSummaryRow(
                        'GST (3%)', '₹${_gstAmount.toStringAsFixed(2)}'),
                    _buildSummaryRow(
                        'Shipping', '₹${_shippingCharge.toStringAsFixed(2)}'),
                    if (_discount > 0)
                      _buildSummaryRow(
                        'Discount',
                        '-₹${_discount.toStringAsFixed(2)}',
                        color: Colors.green,
                      ),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      'Total',
                      '₹${_total.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Shipping Address Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.selectedAddress.name ?? "",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.selectedAddress.address}, ${widget.selectedAddress.city}, '
                      '${widget.selectedAddress.state} - ${widget.selectedAddress.pincode}',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Coupon Section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          'Coupon code',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_couponCode.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Applied Coupon: $_couponCode',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextButton(
                            onPressed: _removeCoupon,
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            focusNode: _couponFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Enter your coupon code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              enabled: _couponCode
                                  .isEmpty, // Disable input if coupon is applied
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: ElevatedButton(
                            onPressed:
                                _couponCode.isEmpty ? _applyCoupon : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Pay Now Button
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ElevatedButton(
            onPressed: _handlePayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: color ?? (isTotal ? Colors.black : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    _couponFocusNode.dispose();
    super.dispose();
  }
}

class AddAddressScreen extends StatefulWidget {
  final ShippingAddress? address;

  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCity;
  String? _selectedState;
  String? _selectedAddressType;

  final List<String> _addressTypes = ['Home', 'Office', 'Others'];

  final shippingController = Get.put(ProductController());
  final pinController = Get.put(PincodeController());

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!.name ?? "";
      _addressController.text = widget.address!.address ?? "";
      _pinCodeController.text = widget.address!.pincode.toString();
      _selectedCity = widget.address!.city;
      _selectedState = widget.address!.state;
    }
    // _fetchStates();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(widget.address != null ? 'Edit Address' : 'Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a mobile number';
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pinCodeController,
                decoration: const InputDecoration(
                  labelText: 'Pin Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a pin code' : null,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) async {
                  await pinController.fetchCity(pincode: value);
                  _cityController.text =
                      pinController.cityData.value.data!.city.toString();
                  _stateController.text =
                      pinController.cityData.value.data!.state.toString();
                  _addressController.text =
                      pinController.cityData.value.data!.address.toString();
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an address' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter state' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter city' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAddressType,
                decoration: const InputDecoration(
                  labelText: 'Address Type',
                  border: OutlineInputBorder(),
                ),
                items: _addressTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  _selectedAddressType = value;

                  print('selectAddressTyep===$_selectedAddressType');
                  // setState(() {
                  //
                  // });
                },
                validator: (value) =>
                    value == null ? 'Please select an address type' : null,
                isExpanded: true,
                hint: const Text('Select Address Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: shippingController.isLoading.value
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final data = {
                            "name": _nameController.text,
                            "mobile": _phoneController.text,
                            "address": _addressController.text,
                            "city": _cityController.text,
                            "state": _stateController.text,
                            "pincode": _pinCodeController.text,
                            "landmark": '',
                            "alternateNumber": '',
                            "addressType": _selectedAddressType!,
                          };
                          final result =
                              await shippingController.createShipping(
                            name: _nameController.text,
                            mobile: _phoneController.text,
                            address: _addressController.text,
                            city: _cityController.text,
                            state: _stateController.text,
                            // city: _selectedCity!,
                            // state: _selectedState!,
                            pincode: _pinCodeController.text,
                            landmark: '',
                            alternateNumber: '',
                            addressType: _selectedAddressType!,
                            context: context,
                          );
                          if (result != null) {
                            // Convert to ShippingAddress for compatibility
                            final newAddress = ShippingAddress(
                              sId:
                                  result.data?.sId ?? DateTime.now().toString(),
                              name: _nameController.text,
                              address: _addressController.text,
                              city: _selectedCity!,
                              state: _selectedState!,
                              pincode: int.parse(_pinCodeController.text),
                            );
                            Navigator.pop(context, newAddress);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: shippingController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.address != null
                            ? 'Update Address'
                            : 'Add Address',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImages extends StatefulWidget {
  final List<String>? imageUrls;

  const ProductImages({super.key, required this.imageUrls});

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    // Set up an auto-scroll timer that changes the image every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _autoScroll(Timer timer) {
    if (_currentPage < widget.imageUrls!.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    _pageController.animateToPage(
      _currentPage,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.imageUrls!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(1.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls!.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${EndPoints.imageBaseUrl}${widget.imageUrls![index]}',
                          height: 250,
                          fit: BoxFit.fill,
                          errorWidget: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 250),
                          placeholder: (context, url) => shimmerPlaceholder(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                _buildPageIndicators(),
              ],
            ),
          )
        : Center(
            child: const Icon(Icons.image_not_supported, size: 250),
          );
  }

  Widget _buildPageIndicators() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.imageUrls!.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _currentPage == index
                ? 24.0
                : 12.0, // Highlight the current dot
            height: 6.0,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  _currentPage == index ? Colors.black : Colors.grey.shade300,
              // shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
