class GetShippingAddressModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<ShippingAddress>? data;

  GetShippingAddressModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetShippingAddressModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ShippingAddress>[];
      json['data'].forEach((v) {
        data!.add(new ShippingAddress.fromJson(v));
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

class ShippingAddress {
  String? sId;
  String? name;
  String? mobile;
  String? address;
  String? city;
  String? state;
  int? pincode;
  String? landmark;
  String? alternateNumber;
  String? addressType;
  User? user;
  String? createdAt;
  int? iV;

  ShippingAddress(
      {this.sId,
        this.name,
        this.mobile,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.landmark,
        this.alternateNumber,
        this.addressType,
        this.user,
        this.createdAt,
        this.iV});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    alternateNumber = json['alternateNumber'];
    addressType = json['addressType'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['alternateNumber'] = this.alternateNumber;
    data['addressType'] = this.addressType;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
