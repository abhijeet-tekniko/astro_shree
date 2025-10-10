class ProductDetailsResponse {
  final bool status;
  final String message;
  final ProductFullDetails? data;

  ProductDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? ProductFullDetails.fromJson(json['data'])
          : null,
    );
  }
}

class ProductFullDetails {
  final String id;
  final String name;
  final int? price;
  final int? sellPrice;
  final String benefits;
  final String description;
  final String thumbImage;
  final List<String> image;
  final Category category;
  final bool status;
  final String createdAt;
  final int v;
  final List<ProductVariant>? productVariant;

  ProductFullDetails({
    required this.id,
    required this.name,
    this.price,
    this.sellPrice,
    required this.benefits,
    required this.description,
    required this.thumbImage,
    required this.image,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.v,
    this.productVariant,
  });

  factory ProductFullDetails.fromJson(Map<String, dynamic> json) {
    return ProductFullDetails(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      sellPrice: json['sellPrice'],
      benefits: json['benefits'],
      description: json['description'],
      thumbImage: json['thumbImage'],
      image: List<String>.from(json['image']),
      category: Category.fromJson(json['category']),
      status: json['status'],
      createdAt: json['createdAt'],
      v: json['__v'],
      productVariant: (json['productVariant'] as List)
          .map((e) => ProductVariant.fromJson(e))
          .toList(),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final String description;
  var price;
  var sellPrice;
  final String createdAt;
  final int v;

  ProductVariant({
    required this.id,
    required this.name,
    required this.description,
    this.price,
    this.sellPrice,
    required this.createdAt,
    required this.v,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      sellPrice: json['sellPrice'] ?? 0,
      createdAt: json['createdAt'] ?? 0,
      v: json['__v'],
    );
  }
}
