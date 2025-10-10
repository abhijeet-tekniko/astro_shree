

class GetBookingAstrologerModel {
  bool? status;
  String? message;
  List<BookingAstrologerData>? data;

  GetBookingAstrologerModel({this.status, this.message, this.data});

  GetBookingAstrologerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BookingAstrologerData>[];
      json['data'].forEach((v) {
        data!.add(new BookingAstrologerData.fromJson(v));
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

class BookingAstrologerData {
  String? sId;
  Astrologer? astrologer;
  Pooja? pooja;
  var price;
  var sellPrice;
  String? assignedAt;
  int? iV;

  BookingAstrologerData(
      {this.sId,
        this.astrologer,
        this.pooja,
        this.price,
        this.sellPrice,
        this.assignedAt,
        this.iV});

  BookingAstrologerData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    astrologer = json['astrologer'] != null
        ? new Astrologer.fromJson(json['astrologer'])
        : null;
    pooja = json['pooja'] != null ? new Pooja.fromJson(json['pooja']) : null;
    price = json['price'];
    sellPrice = json['sellPrice'];
    assignedAt = json['assignedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.toJson();
    }
    if (this.pooja != null) {
      data['pooja'] = this.pooja!.toJson();
    }
    data['price'] = this.price;
    data['sellPrice'] = this.sellPrice;
    data['assignedAt'] = this.assignedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Astrologer {
  Pricing? pricing;
  Wallet? wallet;
  Services? services;
  String? sId;
  String? mobile;
  String? status;
  bool? isBusy;
  List<String>? language;
  var experience;
  List<Speciality>? speciality;
  var commission;
  bool? isBlock;
  bool? isVerify;
  String? createdAt;
  int? iV;
  String? about;
  String? accountNumber;
  String? address;
  String? bankName;
  String? city;
  String? email;
  String? gstNumber;
  String? ifscCode;
  String? name;
  String? profileImage;
  String? state;
  String? adharBackImage;
  String? adharFrontImage;
  String? bankPassbookImage;
  String? cancelChecqueImage;
  String? fcmToken;
  bool? isExpert;
  bool? otherPlatformWork;
  String? otp;
  String? otpExpiry;
  String? panImage;
  var poojaCommission;
  var referralCommission;
  String? maxWaitingTime;

  Astrologer(
      {this.pricing,
        this.wallet,
        this.services,
        this.sId,
        this.mobile,
        this.status,
        this.isBusy,
        this.language,
        this.experience,
        this.speciality,
        this.commission,
        this.isBlock,
        this.isVerify,
        this.createdAt,
        this.iV,
        this.about,
        this.accountNumber,
        this.address,
        this.bankName,
        this.city,
        this.email,
        this.gstNumber,
        this.ifscCode,
        this.name,
        this.profileImage,
        this.state,
        this.adharBackImage,
        this.adharFrontImage,
        this.bankPassbookImage,
        this.cancelChecqueImage,
        this.fcmToken,
        this.isExpert,
        this.otherPlatformWork,
        this.otp,
        this.otpExpiry,
        this.panImage,
        this.poojaCommission,
        this.referralCommission,
        this.maxWaitingTime});

  Astrologer.fromJson(Map<String, dynamic> json) {
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    sId = json['_id'];
    mobile = json['mobile'];
    status = json['status'];
    isBusy = json['isBusy'];
    language = json['language'].cast<String>();
    experience = json['experience'];
    if (json['speciality'] != null) {
      speciality = <Speciality>[];
      json['speciality'].forEach((v) {
        speciality!.add(new Speciality.fromJson(v));
      });
    }
    commission = json['commission'];
    isBlock = json['isBlock'];
    isVerify = json['isVerify'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    about = json['about'];
    accountNumber = json['accountNumber'];
    address = json['address'];
    bankName = json['bankName'];
    city = json['city'];
    email = json['email'];
    gstNumber = json['gstNumber'];
    ifscCode = json['ifscCode'];
    name = json['name'];
    profileImage = json['profileImage'];
    state = json['state'];
    adharBackImage = json['adharBackImage'];
    adharFrontImage = json['adharFrontImage'];
    bankPassbookImage = json['bankPassbookImage'];
    cancelChecqueImage = json['cancelChecqueImage'];
    fcmToken = json['fcmToken'];
    isExpert = json['isExpert'];
    otherPlatformWork = json['otherPlatformWork'];
    otp = json['otp'];
    otpExpiry = json['otpExpiry'];
    panImage = json['panImage'];
    poojaCommission = json['poojaCommission'];
    referralCommission = json['referralCommission'];
    maxWaitingTime = json['maxWaitingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.toJson();
    }
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['status'] = this.status;
    data['isBusy'] = this.isBusy;
    data['language'] = this.language;
    data['experience'] = this.experience;
    if (this.speciality != null) {
      data['speciality'] = this.speciality!.map((v) => v.toJson()).toList();
    }
    data['commission'] = this.commission;
    data['isBlock'] = this.isBlock;
    data['isVerify'] = this.isVerify;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['about'] = this.about;
    data['accountNumber'] = this.accountNumber;
    data['address'] = this.address;
    data['bankName'] = this.bankName;
    data['city'] = this.city;
    data['email'] = this.email;
    data['gstNumber'] = this.gstNumber;
    data['ifscCode'] = this.ifscCode;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    data['state'] = this.state;
    data['adharBackImage'] = this.adharBackImage;
    data['adharFrontImage'] = this.adharFrontImage;
    data['bankPassbookImage'] = this.bankPassbookImage;
    data['cancelChecqueImage'] = this.cancelChecqueImage;
    data['fcmToken'] = this.fcmToken;
    data['isExpert'] = this.isExpert;
    data['otherPlatformWork'] = this.otherPlatformWork;
    data['otp'] = this.otp;
    data['otpExpiry'] = this.otpExpiry;
    data['panImage'] = this.panImage;
    data['poojaCommission'] = this.poojaCommission;
    data['referralCommission'] = this.referralCommission;
    data['maxWaitingTime'] = this.maxWaitingTime;
    return data;
  }
}

class Pricing {
  int? chat;
  int? voice;
  int? video;

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

class Pooja {
  String? sId;
  String? name;
  String? shortDescription;

  Pooja({this.sId, this.name, this.shortDescription});

  Pooja.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    return data;
  }
}


class Speciality {
  String? sId;
  String? name;

  Speciality({this.sId, this.name});

  Speciality.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
