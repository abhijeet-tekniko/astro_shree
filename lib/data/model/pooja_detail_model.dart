class GetPoojaDetailModel {
  bool? status;
  String? message;
  Data? data;

  GetPoojaDetailModel({this.status, this.message, this.data});

  GetPoojaDetailModel.fromJson(Map<String, dynamic> json) {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
