class PurchaseProductModel {
  bool? status;
  String? message;
  PurchaseProductData? data;

  PurchaseProductModel({this.status, this.message, this.data});

  PurchaseProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new PurchaseProductData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PurchaseProductData {
  Transaction? transaction;

  PurchaseProductData({this.transaction});

  PurchaseProductData.fromJson(Map<String, dynamic> json) {
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  String? transactionId;
  String? orderId;
  String? user;
  String? shipping;
  String? deliverStatus;
  String? product;
  var quantity;
  String? paymentMethod;
  var amount;
  String? status;
  String? sId;
  String? createdAt;
  int? iV;

  Transaction(
      {this.transactionId,
        this.orderId,
        this.user,
        this.shipping,
        this.deliverStatus,
        this.product,
        this.quantity,
        this.paymentMethod,
        this.amount,
        this.status,
        this.sId,
        this.createdAt,
        this.iV});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    orderId = json['orderId'];
    user = json['user'];
    shipping = json['shipping'];
    deliverStatus = json['deliverStatus'];
    product = json['product'];
    quantity = json['quantity'];
    paymentMethod = json['PaymentMethod'];
    amount = json['amount'];
    status = json['status'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['orderId'] = this.orderId;
    data['user'] = this.user;
    data['shipping'] = this.shipping;
    data['deliverStatus'] = this.deliverStatus;
    data['product'] = this.product;
    data['quantity'] = this.quantity;
    data['PaymentMethod'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
