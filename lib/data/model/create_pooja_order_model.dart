class CreatePoojaTransactionModel {
  bool? status;
  String? message;
  Data? data;

  CreatePoojaTransactionModel({this.status, this.message, this.data});

  CreatePoojaTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  Transaction? transaction;
  RazorpayOrder? razorpayOrder;

  Data({this.transaction, this.razorpayOrder});

  Data.fromJson(Map<String, dynamic> json) {
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
    razorpayOrder = json['razorpayOrder'] != null
        ? new RazorpayOrder.fromJson(json['razorpayOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    if (this.razorpayOrder != null) {
      data['razorpayOrder'] = this.razorpayOrder!.toJson();
    }
    return data;
  }
}

class Transaction {
  String? transactionId;
  String? orderId;
  String? user;
  String? pooja;
  String? paymentMethod;
  String? astrologer;
  String? poojaStatus;
  var amount;
  var gstAmount;
  bool? isSettled;
  String? status;
  String? sId;
  String? createdAt;
  int? iV;

  Transaction(
      {this.transactionId,
        this.orderId,
        this.user,
        this.pooja,
        this.paymentMethod,
        this.astrologer,
        this.poojaStatus,
        this.amount,
        this.gstAmount,
        this.isSettled,
        this.status,
        this.sId,
        this.createdAt,
        this.iV});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    orderId = json['orderId'];
    user = json['user'];
    pooja = json['pooja'];
    paymentMethod = json['PaymentMethod'];
    astrologer = json['astrologer'];
    poojaStatus = json['poojaStatus'];
    amount = json['amount'];
    gstAmount = json['gstAmount'];
    isSettled = json['isSettled'];
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
    data['pooja'] = this.pooja;
    data['PaymentMethod'] = this.paymentMethod;
    data['astrologer'] = this.astrologer;
    data['poojaStatus'] = this.poojaStatus;
    data['amount'] = this.amount;
    data['gstAmount'] = this.gstAmount;
    data['isSettled'] = this.isSettled;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class RazorpayOrder {
  String? orderId;
  var amount;
  String? key;
  String? currency;

  RazorpayOrder({this.orderId, this.amount, this.key, this.currency});

  RazorpayOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    amount = json['amount'];
    key = json['key'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['key'] = this.key;
    data['currency'] = this.currency;
    return data;
  }
}
