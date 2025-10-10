class GetProductTransactionModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<EProductData>? data;

  GetProductTransactionModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetProductTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EProductData>[];
      json['data'].forEach((v) {
        data!.add(new EProductData.fromJson(v));
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

class EProductData {
  String? sId;
  String? transactionId;
  String? orderId;
  User? user;
  Shipping? shipping;
  String? deliverStatus;
  Product? product;
  int? quantity;
  String? paymentMethod;
  var amount;
  var gstAmount;
  String? referralCode;
  var referralAmount;
  bool? isSettled;
  String? status;
  String? createdAt;
  int? iV;

  EProductData(
      {this.sId,
        this.transactionId,
        this.orderId,
        this.user,
        this.shipping,
        this.deliverStatus,
        this.product,
        this.quantity,
        this.paymentMethod,
        this.amount,
        this.gstAmount,
        this.referralCode,
        this.referralAmount,
        this.isSettled,
        this.status,
        this.createdAt,
        this.iV});

  EProductData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    transactionId = json['transactionId'];
    orderId = json['orderId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;
    deliverStatus = json['deliverStatus'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    paymentMethod = json['PaymentMethod'];
    amount = json['amount'];
    gstAmount = json['gstAmount'];
    referralCode = json['referralCode'];
    referralAmount = json['referralAmount'];
    isSettled = json['isSettled'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['transactionId'] = this.transactionId;
    data['orderId'] = this.orderId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    data['deliverStatus'] = this.deliverStatus;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    data['quantity'] = this.quantity;
    data['PaymentMethod'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['gstAmount'] = this.gstAmount;
    data['referralCode'] = this.referralCode;
    data['referralAmount'] = this.referralAmount;
    data['isSettled'] = this.isSettled;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String? sId;
  String? email;
  String? name;

  User({this.sId, this.email, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}

class Shipping {
  String? sId;
  String? name;
  String? address;
  String? city;
  String? state;
  int? pincode;

  Shipping(
      {this.sId, this.name, this.address, this.city, this.state, this.pincode});

  Shipping.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    return data;
  }
}

class Product {
  String? sId;
  String? name;
  int? price;
  int? sellPrice;
  String? benefits;
  String? description;
  String? thumbImage;
  List<String>? image;
  String? category;
  bool? status;
  String? createdAt;
  int? iV;

  Product(
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
        this.iV});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    sellPrice = json['sellPrice'];
    benefits = json['benefits'];
    description = json['description'];
    thumbImage = json['thumbImage'];
    image = json['image'].cast<String>();
    category = json['category'];
    status = json['status'];
    createdAt = json['createdAt'];
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
    data['category'] = this.category;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
