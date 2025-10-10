class RechargeListModel {
  bool? status;
  String? message;
  List<RechargeListData>? data;

  RechargeListModel({this.status, this.message, this.data});

  RechargeListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RechargeListData>[];
      json['data'].forEach((v) {
        data!.add(new RechargeListData.fromJson(v));
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

class RechargeListData {
  String? sId;
  var rechargeAmount;
  String? offerType;
  var offerValue;
  String? createdAt;
  int? iV;

  RechargeListData(
      {this.sId,
        this.rechargeAmount,
        this.offerType,
        this.offerValue,
        this.createdAt,
        this.iV});

  RechargeListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rechargeAmount = json['rechargeAmount'];
    offerType = json['offerType'];
    offerValue = json['offerValue'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rechargeAmount'] = this.rechargeAmount;
    data['offerType'] = this.offerType;
    data['offerValue'] = this.offerValue;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
