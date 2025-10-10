class GetCustomerReviewModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<CustomerReviewData>? data;

  GetCustomerReviewModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetCustomerReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerReviewData>[];
      json['data'].forEach((v) {
        data!.add(new CustomerReviewData.fromJson(v));
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

class CustomerReviewData {
  String? sId;
  User? user;
  String? message;
  var rating;
  bool? verify;
  String? createdAt;
  int? iV;

  CustomerReviewData(
      {this.sId,
        this.user,
        this.message,
        this.rating,
        this.verify,
        this.createdAt,
        this.iV});

  CustomerReviewData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
    rating = json['rating'];
    verify = json['verify'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['rating'] = this.rating;
    data['verify'] = this.verify;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  String? sId;
  String? profileImage;
  String? email;
  String? name;

  User({this.sId, this.profileImage, this.email, this.name});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profileImage'];
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profileImage'] = this.profileImage;
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}
