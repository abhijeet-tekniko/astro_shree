class GetPoojaModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<PoojaData>? data;

  GetPoojaModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetPoojaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PoojaData>[];
      json['data'].forEach((v) {
        data!.add(new PoojaData.fromJson(v));
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

class PoojaData {
  String? sId;
  String? name;
  String? shortDescription;
  String? about;
  String? image;
  String? purpose;
  List<String>? benefits;
  List<String>? assignAstrologer;
  bool? status;
  String? createdAt;
  int? iV;
  var price;
  var sellPrice;

  PoojaData(
      {this.sId,
        this.name,
        this.shortDescription,
        this.about,
        this.image,
        this.purpose,
        this.benefits,
        this.assignAstrologer,
        this.status,
        this.createdAt,
        this.iV,
        this.price,
        this.sellPrice});

  PoojaData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    about = json['about'];
    image = json['image'];
    purpose = json['purpose'];
    benefits = json['benefits'].cast<String>();
    assignAstrologer = json['assignAstrologer'].cast<String>();
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    price = json['price'];
    sellPrice = json['sellPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['about'] = this.about;
    data['image'] = this.image;
    data['purpose'] = this.purpose;
    data['benefits'] = this.benefits;
    data['assignAstrologer'] = this.assignAstrologer;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['price'] = this.price;
    data['sellPrice'] = this.sellPrice;
    return data;
  }
}
