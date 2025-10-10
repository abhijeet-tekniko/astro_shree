class SendGiftModel {
  bool? status;
  String? message;
  SendGiftData? data;

  SendGiftModel({this.status, this.message, this.data});

  SendGiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SendGiftData.fromJson(json['data']) : null;
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

class SendGiftData {
  GiftCard? giftCard;

  SendGiftData(
      {
        this.giftCard,});

  SendGiftData.fromJson(Map<String, dynamic> json) {

    giftCard = json['giftCard'] != null
        ? new GiftCard.fromJson(json['giftCard'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.giftCard != null) {
      data['giftCard'] = this.giftCard!.toJson();
    }

    return data;
  }
}

class GiftCard {
  String? sId;
  String? name;
  String? image;
  int? amount;
  String? createdAt;
  int? iV;

  GiftCard(
      {this.sId, this.name, this.image, this.amount, this.createdAt, this.iV});

  GiftCard.fromJson(Map<String, dynamic> json) {
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
