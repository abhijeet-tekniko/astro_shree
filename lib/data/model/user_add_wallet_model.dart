class UserAddWalletModel {
  bool? status;
  String? message;
  Data? data;

  UserAddWalletModel({this.status, this.message, this.data});

  UserAddWalletModel.fromJson(Map<String, dynamic> json) {
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
  var amount;
  String? orderId;
  String? transactionId;
  String? user;
  String? description;
  String? status;
  String? type;
  var duration;
  bool? isSettled;
  String? sId;
  String? createdAt;
  int? iV;

  Transaction(
      {this.amount,
        this.orderId,
        this.transactionId,
        this.user,
        this.description,
        this.status,
        this.type,
        this.duration,
        this.isSettled,
        this.sId,
        this.createdAt,
        this.iV});

  Transaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    orderId = json['orderId'];
    transactionId = json['transactionId'];
    user = json['user'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    duration = json['duration'];
    isSettled = json['isSettled'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['orderId'] = this.orderId;
    data['transactionId'] = this.transactionId;
    data['user'] = this.user;
    data['description'] = this.description;
    data['status'] = this.status;
    data['type'] = this.type;
    data['duration'] = this.duration;
    data['isSettled'] = this.isSettled;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class RazorpayOrder {
  String? orderId;
  int? amount;
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
