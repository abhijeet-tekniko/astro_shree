class GetKundliMemberModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<GetKundliMemberData>? data;

  GetKundliMemberModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetKundliMemberModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetKundliMemberData>[];
      json['data'].forEach((v) {
        data!.add(new GetKundliMemberData.fromJson(v));
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

class GetKundliMemberData {
  String? sId;
  String? name;
  String? gender;
  User? user;
  String? dob;
  String? birthTime;
  String? placeOfBirth;
  String? createdAt;
  int? iV;

  GetKundliMemberData(
      {this.sId,
        this.name,
        this.gender,
        this.user,
        this.dob,
        this.birthTime,
        this.placeOfBirth,
        this.createdAt,
        this.iV});

  GetKundliMemberData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    gender = json['gender'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    dob = json['dob'];
    birthTime = json['birthTime'];
    placeOfBirth = json['placeOfBirth'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['dob'] = this.dob;
    data['birthTime'] = this.birthTime;
    data['placeOfBirth'] = this.placeOfBirth;
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
  String? fcmToken;
  String? countryCode;
  String? placeOfBirth;
  String? birthTime;
  String? maritalStatus;
  bool? status;
  String? createdAt;
  int? iV;
  String? dob;
  String? email;
  String? gender;
  String? name;
  String? otpExpiry;

  User(
      {this.wallet,
        this.sId,
        this.mobile,
        this.profileImage,
        this.fcmToken,
        this.countryCode,
        this.placeOfBirth,
        this.birthTime,
        this.maritalStatus,
        this.status,
        this.createdAt,
        this.iV,
        this.dob,
        this.email,
        this.gender,
        this.name,
        this.otpExpiry});

  User.fromJson(Map<String, dynamic> json) {
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    sId = json['_id'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    placeOfBirth = json['placeOfBirth'];
    birthTime = json['birthTime'];
    maritalStatus = json['maritalStatus'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    dob = json['dob'];
    email = json['email'];
    gender = json['gender'];
    name = json['name'];
    otpExpiry = json['otpExpiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['profileImage'] = this.profileImage;
    data['fcmToken'] = this.fcmToken;
    data['countryCode'] = this.countryCode;
    data['placeOfBirth'] = this.placeOfBirth;
    data['birthTime'] = this.birthTime;
    data['maritalStatus'] = this.maritalStatus;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['name'] = this.name;
    data['otpExpiry'] = this.otpExpiry;
    return data;
  }
}

class Wallet {
  var balance;
  var lockedBalance;

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
