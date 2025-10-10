class GetConsultDetailModel {
  bool? status;
  String? message;
  ConsultDetailData? data;

  GetConsultDetailModel({this.status, this.message, this.data});

  GetConsultDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ConsultDetailData.fromJson(json['data']) : null;
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

class ConsultDetailData {
  String? sId;
  String? name;
  String? email;
  var pincode;
  String? city;
  String? mobile;
  bool? otherPlatformWork;
  String? qualification;
  String? status;
  bool? isBusy;
  String? profileImage;
  String? about;
  List<String>? language;
  var experience;
  List<Speciality>? speciality;
  var commission;
  var poojaCommission;
  Pricing? pricing;
  Wallet? wallet;
  Services? services;
  bool? isBlock;
  String? fcmToken;
  String? bankName;
  String? ifscCode;
  String? accountNumber;
  String? gstNumber;
  String? state;
  String? address;
  bool? isExpert;
  String? adharFrontImage;
  String? adharBackImage;
  String? panImage;
  String? bankPassbookImage;
  String? cancelChecqueImage;
  String? referralCode;
  var referralCommission;
  bool? isVerify;
  String? createdAt;
  var iV;
  var chatDuration;
  var callDuration;
  var videoCallDuration;
  var ratingAverage;
  var ratingCount;

  ConsultDetailData(
      {this.sId,
        this.name,
        this.email,
        this.pincode,
        this.city,
        this.mobile,
        this.otherPlatformWork,
        this.qualification,
        this.status,
        this.isBusy,
        this.profileImage,
        this.about,
        this.language,
        this.experience,
        this.speciality,
        this.commission,
        this.poojaCommission,
        this.pricing,
        this.wallet,
        this.services,
        this.isBlock,
        this.fcmToken,
        this.bankName,
        this.ifscCode,
        this.accountNumber,
        this.gstNumber,
        this.state,
        this.address,
        this.isExpert,
        this.adharFrontImage,
        this.adharBackImage,
        this.panImage,
        this.bankPassbookImage,
        this.cancelChecqueImage,
        this.referralCode,
        this.referralCommission,
        this.isVerify,
        this.createdAt,
        this.iV,
        this.chatDuration,
        this.callDuration,
        this.videoCallDuration,
        this.ratingAverage,
        this.ratingCount});

  ConsultDetailData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    pincode = json['pincode'];
    city = json['city'];
    mobile = json['mobile'];
    otherPlatformWork = json['otherPlatformWork'];
    qualification = json['qualification'];
    status = json['status'];
    isBusy = json['isBusy'];
    profileImage = json['profileImage'];
    about = json['about'];
    language = json['language'].cast<String>();
    experience = json['experience'];
    if (json['speciality'] != null) {
      speciality = <Speciality>[];
      json['speciality'].forEach((v) {
        speciality!.add(new Speciality.fromJson(v));
      });
    }
    commission = json['commission'];
    poojaCommission = json['poojaCommission'];
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    isBlock = json['isBlock'];
    fcmToken = json['fcmToken'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountNumber = json['accountNumber'];
    gstNumber = json['gstNumber'];
    state = json['state'];
    address = json['address'];
    isExpert = json['isExpert'];
    adharFrontImage = json['adharFrontImage'];
    adharBackImage = json['adharBackImage'];
    panImage = json['panImage'];
    bankPassbookImage = json['bankPassbookImage'];
    cancelChecqueImage = json['cancelChecqueImage'];
    referralCode = json['referralCode'];
    referralCommission = json['referralCommission'];
    isVerify = json['isVerify'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    chatDuration = json['chatDuration'];
    callDuration = json['callDuration'];
    videoCallDuration = json['videoCallDuration'];
    ratingAverage = json['ratingAverage'];
    ratingCount = json['ratingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['mobile'] = this.mobile;
    data['otherPlatformWork'] = this.otherPlatformWork;
    data['qualification'] = this.qualification;
    data['status'] = this.status;
    data['isBusy'] = this.isBusy;
    data['profileImage'] = this.profileImage;
    data['about'] = this.about;
    data['language'] = this.language;
    data['experience'] = this.experience;
    if (this.speciality != null) {
      data['speciality'] = this.speciality!.map((v) => v.toJson()).toList();
    }
    data['commission'] = this.commission;
    data['poojaCommission'] = this.poojaCommission;
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['isBlock'] = this.isBlock;
    data['fcmToken'] = this.fcmToken;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountNumber'] = this.accountNumber;
    data['gstNumber'] = this.gstNumber;
    data['state'] = this.state;
    data['address'] = this.address;
    data['isExpert'] = this.isExpert;
    data['adharFrontImage'] = this.adharFrontImage;
    data['adharBackImage'] = this.adharBackImage;
    data['panImage'] = this.panImage;
    data['bankPassbookImage'] = this.bankPassbookImage;
    data['cancelChecqueImage'] = this.cancelChecqueImage;
    data['referralCode'] = this.referralCode;
    data['referralCommission'] = this.referralCommission;
    data['isVerify'] = this.isVerify;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['chatDuration'] = this.chatDuration;
    data['callDuration'] = this.callDuration;
    data['videoCallDuration'] = this.videoCallDuration;
    data['ratingAverage'] = this.ratingAverage;
    data['ratingCount'] = this.ratingCount;
    return data;
  }
}

class Speciality {
  String? sId;
  String? name;
  bool? status;
  String? createdAt;
  var iV;

  Speciality({this.sId, this.name, this.status, this.createdAt, this.iV});

  Speciality.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Pricing {
  var chat;
  var voice;
  var video;

  Pricing({this.chat, this.voice, this.video});

  Pricing.fromJson(Map<String, dynamic> json) {
    chat = json['chat'];
    voice = json['voice'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat'] = this.chat;
    data['voice'] = this.voice;
    data['video'] = this.video;
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

class Services {
  bool? chat;
  bool? voice;
  bool? video;

  Services({this.chat, this.voice, this.video});

  Services.fromJson(Map<String, dynamic> json) {
    chat = json['chat'];
    voice = json['voice'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat'] = this.chat;
    data['voice'] = this.voice;
    data['video'] = this.video;
    return data;
  }
}
