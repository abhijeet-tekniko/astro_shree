class GetPoojaTransactionModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<Data>? data;

  GetPoojaTransactionModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetPoojaTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? sId;
  String? transactionId;
  String? orderId;
  User? user;
  Pooja? pooja;
  String? paymentMethod;
  Astrologer? astrologer;
  String? poojaStatus;
  int? amount;
  int? gstAmount;
  bool? isSettled;
  String? status;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.transactionId,
        this.orderId,
        this.user,
        this.pooja,
        this.paymentMethod,
        this.astrologer,
        this.poojaStatus,
        this.amount,
        this.gstAmount,
        this.isSettled,
        this.status,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    transactionId = json['transactionId'];
    orderId = json['orderId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pooja = json['pooja'] != null ? new Pooja.fromJson(json['pooja']) : null;
    paymentMethod = json['PaymentMethod'];
    astrologer = json['astrologer'] != null
        ? new Astrologer.fromJson(json['astrologer'])
        : null;
    poojaStatus = json['poojaStatus'];
    amount = json['amount'];
    gstAmount = json['gstAmount'];
    isSettled = json['isSettled'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['transactionId'] = this.transactionId;
    data['orderId'] = this.orderId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.pooja != null) {
      data['pooja'] = this.pooja!.toJson();
    }
    data['PaymentMethod'] = this.paymentMethod;
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.toJson();
    }
    data['poojaStatus'] = this.poojaStatus;
    data['amount'] = this.amount;
    data['gstAmount'] = this.gstAmount;
    data['isSettled'] = this.isSettled;
    data['status'] = this.status;
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

class Pooja {
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

  Pooja(
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
        this.iV});

  Pooja.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Astrologer {
  Pricing? pricing;
  Wallet? wallet;
  Services? services;
  int? poojaCommission;
  String? fcmToken;
  int? referralCommission;
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? status;
  bool? isBusy;
  String? profileImage;
  String? about;
  List<String>? language;
  int? experience;
  List<String>? speciality;
  int? commission;
  bool? isBlock;
  String? bankName;
  String? ifscCode;
  String? accountNumber;
  String? gstNumber;
  String? state;
  String? city;
  String? address;
  // List<String>? documentImage;
  bool? isVerify;
  String? createdAt;
  int? iV;
  String? adharBackImage;
  String? adharFrontImage;
  String? bankPassbookImage;
  String? cancelChecqueImage;
  bool? isExpert;
  bool? otherPlatformWork;
  String? panImage;
  int? pincode;
  String? qualification;
  String? maxWaitingTime;

  Astrologer(
      {this.pricing,
        this.wallet,
        this.services,
        this.poojaCommission,
        this.fcmToken,
        this.referralCommission,
        this.sId,
        this.name,
        this.email,
        this.mobile,
        this.status,
        this.isBusy,
        this.profileImage,
        this.about,
        this.language,
        this.experience,
        this.speciality,
        this.commission,
        this.isBlock,
        this.bankName,
        this.ifscCode,
        this.accountNumber,
        this.gstNumber,
        this.state,
        this.city,
        this.address,
        // this.documentImage,
        this.isVerify,
        this.createdAt,
        this.iV,
        this.adharBackImage,
        this.adharFrontImage,
        this.bankPassbookImage,
        this.cancelChecqueImage,
        this.isExpert,
        this.otherPlatformWork,
        this.panImage,
        this.pincode,
        this.qualification,
        this.maxWaitingTime});

  Astrologer.fromJson(Map<String, dynamic> json) {
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    poojaCommission = json['poojaCommission'];
    fcmToken = json['fcmToken'];
    referralCommission = json['referralCommission'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    status = json['status'];
    isBusy = json['isBusy'];
    profileImage = json['profileImage'];
    about = json['about'];
    language = json['language'].cast<String>();
    experience = json['experience'];
    speciality = json['speciality'].cast<String>();
    commission = json['commission'];
    isBlock = json['isBlock'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountNumber = json['accountNumber'];
    gstNumber = json['gstNumber'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    // documentImage = json['documentImage'].cast<String>();
    isVerify = json['isVerify'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    adharBackImage = json['adharBackImage'];
    adharFrontImage = json['adharFrontImage'];
    bankPassbookImage = json['bankPassbookImage'];
    cancelChecqueImage = json['cancelChecqueImage'];
    isExpert = json['isExpert'];
    otherPlatformWork = json['otherPlatformWork'];
    panImage = json['panImage'];
    pincode = json['pincode'];
    qualification = json['qualification'];
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
    data['poojaCommission'] = this.poojaCommission;
    data['fcmToken'] = this.fcmToken;
    data['referralCommission'] = this.referralCommission;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['status'] = this.status;
    data['isBusy'] = this.isBusy;
    data['profileImage'] = this.profileImage;
    data['about'] = this.about;
    data['language'] = this.language;
    data['experience'] = this.experience;
    data['speciality'] = this.speciality;
    data['commission'] = this.commission;
    data['isBlock'] = this.isBlock;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountNumber'] = this.accountNumber;
    data['gstNumber'] = this.gstNumber;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    // data['documentImage'] =
    //     this.documentImage;
    data['isVerify'] = this.isVerify;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['adharBackImage'] = this.adharBackImage;
    data['adharFrontImage'] = this.adharFrontImage;
    data['bankPassbookImage'] = this.bankPassbookImage;
    data['cancelChecqueImage'] = this.cancelChecqueImage;
    data['isExpert'] = this.isExpert;
    data['otherPlatformWork'] = this.otherPlatformWork;
    data['panImage'] = this.panImage;
    data['pincode'] = this.pincode;
    data['qualification'] = this.qualification;
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
