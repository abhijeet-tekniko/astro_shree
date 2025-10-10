class ShippingAddressCreateModel {
  bool? status;
  String? message;
  Data? data;

  ShippingAddressCreateModel({this.status, this.message, this.data});

  ShippingAddressCreateModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? mobile;
  String? address;
  String? city;
  String? state;
  int? pincode;
  String? landmark;
  String? alternateNumber;
  String? addressType;
  String? user;
  String? sId;
  String? createdAt;
  int? iV;

  Data(
      {this.name,
        this.mobile,
        this.address,
        this.city,
        this.state,
        this.pincode,
        this.landmark,
        this.alternateNumber,
        this.addressType,
        this.user,
        this.sId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    landmark = json['landmark'];
    alternateNumber = json['alternateNumber'];
    addressType = json['addressType'];
    user = json['user'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['landmark'] = this.landmark;
    data['alternateNumber'] = this.alternateNumber;
    data['addressType'] = this.addressType;
    data['user'] = this.user;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
