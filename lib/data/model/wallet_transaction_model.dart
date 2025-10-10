class WalletTransactionModel {
  bool? status;
  String? message;
  List<WalletTransactionData>? data;

  WalletTransactionModel({this.status, this.message, this.data});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WalletTransactionData>[];
      json['data'].forEach((v) {
        data!.add(new WalletTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class WalletTransactionData {
  String? sId;
  var amount;
  String? orderId;
  String? transactionId;
  User? user;
  String? astrologer;
  String? description;
  String? status;
  String? type;
  var duration;
  bool? isSettled;
  String? createdAt;
  int? iV;
  String? invoice;
  int? gstAmount;

  WalletTransactionData(
      {this.sId,
        this.amount,
        this.orderId,
        this.transactionId,
        this.user,
        this.astrologer,
        this.description,
        this.status,
        this.type,
        this.duration,
        this.isSettled,
        this.createdAt,
        this.iV,
        this.invoice,
        this.gstAmount});

  WalletTransactionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    amount = json['amount'];
    orderId = json['orderId'];
    transactionId = json['transactionId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    astrologer = json['astrologer'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    duration = json['duration'];
    isSettled = json['isSettled'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    invoice = json['invoice'];
    gstAmount = json['gstAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['amount'] = this.amount;
    data['orderId'] = this.orderId;
    data['transactionId'] = this.transactionId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['astrologer'] = this.astrologer;
    data['description'] = this.description;
    data['status'] = this.status;
    data['type'] = this.type;
    data['duration'] = this.duration;
    data['isSettled'] = this.isSettled;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['invoice'] = this.invoice;
    data['gstAmount'] = this.gstAmount;
    return data;
  }
}

class User {
  String? sId;
  String? mobile;
  String? email;
  String? name;

  User({this.sId, this.mobile, this.email, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}

