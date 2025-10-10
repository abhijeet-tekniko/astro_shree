class ProductListModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<ProductListData>? data;

  ProductListModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductListData>[];
      json['data'].forEach((v) {
        data!.add(new ProductListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductListData {
  String? sId;
  String? name;
  var price;
  var sellPrice;
  String? benefits;
  String? description;
  String? thumbImage;
  List<String>? image;
  Category? category;
  bool? status;
  String? createdAt;
  List<ProductVariant>? productVariant;
  int? iV;

  ProductListData(
      {this.sId,
        this.name,
        this.price,
        this.sellPrice,
        this.benefits,
        this.description,
        this.thumbImage,
        this.image,
        this.category,
        this.status,
        this.createdAt,
        this.productVariant,
        this.iV});

  ProductListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    sellPrice = json['sellPrice'];
    benefits = json['benefits'];
    description = json['description'];
    thumbImage = json['thumbImage'];
    image = json['image'].cast<String>();
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    if (json['productVariant'] != null) {
      productVariant = <ProductVariant>[];
      json['productVariant'].forEach((v) {
        productVariant!.add(ProductVariant.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['sellPrice'] = this.sellPrice;
    data['benefits'] = this.benefits;
    data['description'] = this.description;
    data['thumbImage'] = this.thumbImage;
    data['image'] = this.image;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    if (productVariant != null) {
      data['productVariant'] = productVariant!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Category {
  String? sId;
  String? name;

  Category({this.sId, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class ProductVariant {
  String? sId;
  String? name;
  String? description;
  var price;
  var sellPrice;
  String? createdAt;
  int? iV;

  ProductVariant({
    this.sId,
    this.name,
    this.description,
    this.price,
    this.sellPrice,
    this.createdAt,
    this.iV,
  });

  ProductVariant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    sellPrice = json['sellPrice'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['sellPrice'] = sellPrice;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductVariant &&
              runtimeType == other.runtimeType &&
              sId == other.sId;

  @override
  int get hashCode => sId.hashCode;
}
