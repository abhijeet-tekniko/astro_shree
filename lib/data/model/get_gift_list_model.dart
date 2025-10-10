class GetGiftList {
  bool? status;
  String? message;
  List<GiftListData>? data;

  GetGiftList({this.status, this.message, this.data});

  GetGiftList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GiftListData>[];
      json['data'].forEach((v) {
        data!.add(new GiftListData.fromJson(v));
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

class GiftListData {
  String? sId;
  String? name;
  String? image;
  int? amount;
  String? createdAt;
  int? iV;

  GiftListData({this.sId, this.name, this.image, this.amount, this.createdAt, this.iV});

  GiftListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    amount = json['amount'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['amount'] = this.amount;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
