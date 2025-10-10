class CreateMemberModel {
  bool? status;
  String? message;
  Data? data;

  CreateMemberModel({this.status, this.message, this.data});

  CreateMemberModel.fromJson(Map<String, dynamic> json) {
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
  String? gender;
  User? user;
  String? dob;
  String? birthTime;
  String? placeOfBirth;
  String? sId;
  String? createdAt;
  int? iV;

  Data(
      {this.name,
        this.gender,
        this.user,
        this.dob,
        this.birthTime,
        this.placeOfBirth,
        this.sId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    dob = json['dob'];
    birthTime = json['birthTime'];
    placeOfBirth = json['placeOfBirth'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['gender'] = this.gender;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['dob'] = this.dob;
    data['birthTime'] = this.birthTime;
    data['placeOfBirth'] = this.placeOfBirth;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
  Wallet? wallet;
  String? sId;
  String? mobile;
  String? profileImage;
  bool? status;
  String? createdAt;
  int? iV;
  String? email;
  String? gender;
  String? name;
  String? fcmToken;

  User(
      {this.wallet,
        this.sId,
        this.mobile,
        this.profileImage,
        this.status,
        this.createdAt,
        this.iV,
        this.email,
        this.gender,
        this.name,
        this.fcmToken});

  User.fromJson(Map<String, dynamic> json) {
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    sId = json['_id'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['profileImage'] = this.profileImage;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}

class Wallet {
  int? balance;
  int? lockedBalance;

  Wallet({this.balance, this.lockedBalance});

  Wallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    lockedBalance = json['lockedBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    data['lockedBalance'] = this.lockedBalance;
    return data;
  }
}
