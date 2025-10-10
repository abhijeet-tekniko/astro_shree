class GetMySessionModel {
  bool? status;
  String? message;
  List<MySessionData>? data;

  GetMySessionModel({this.status, this.message, this.data});

  GetMySessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MySessionData>[];
      json['data'].forEach((v) {
        data!.add(new MySessionData.fromJson(v));
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

class MySessionData {
  String? sId;
  User? user;
  Astrologer? astrologer;
  String? chatRequest;
  String? type;
  int? maxWaitingTime;
  String? startedAt;
  String? status;
  int? totalActiveDuration;
  List<PauseEvents>? pauseEvents;
  int? iV;
  String? endedAt;
  String? startedAtIST;
  String? endedAtIST;
  String? id;

  MySessionData(
      {this.sId,
        this.user,
        this.astrologer,
        this.chatRequest,
        this.type,
        this.maxWaitingTime,
        this.startedAt,
        this.status,
        this.totalActiveDuration,
        this.pauseEvents,
        this.iV,
        this.endedAt,
        this.startedAtIST,
        this.endedAtIST,
        this.id});

  MySessionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    astrologer = json['astrologer'] != null
        ? new Astrologer.fromJson(json['astrologer'])
        : null;
    chatRequest = json['chatRequest'];
    type = json['type'];
    maxWaitingTime = json['maxWaitingTime'];
    startedAt = json['startedAt'];
    status = json['status'];
    totalActiveDuration = json['totalActiveDuration'];
    if (json['pauseEvents'] != null) {
      pauseEvents = <PauseEvents>[];
      json['pauseEvents'].forEach((v) {
        pauseEvents!.add(new PauseEvents.fromJson(v));
      });
    }
    iV = json['__v'];
    endedAt = json['endedAt'];
    startedAtIST = json['startedAtIST'];
    endedAtIST = json['endedAtIST'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.toJson();
    }
    data['chatRequest'] = this.chatRequest;
    data['type'] = this.type;
    data['maxWaitingTime'] = this.maxWaitingTime;
    data['startedAt'] = this.startedAt;
    data['status'] = this.status;
    data['totalActiveDuration'] = this.totalActiveDuration;
    if (this.pauseEvents != null) {
      data['pauseEvents'] = this.pauseEvents!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    data['endedAt'] = this.endedAt;
    data['startedAtIST'] = this.startedAtIST;
    data['endedAtIST'] = this.endedAtIST;
    data['id'] = this.id;
    return data;
  }
}

class User {
  String? sId;
  String? name;

  User({this.sId, this.name});

  User.fromJson(Map<String, dynamic> json) {
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
class Astrologer {
  Pricing? pricing;
  Wallet? wallet;
  Services? services;
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? status;
  String? profileImage;
  String? about;
  List<String>? language;
  int? experience;
  List<String>? speciality;
  bool? isBlock;
  String? bankName;
  String? ifscCode;
  String? accountNumber;
  String? gstNumber;
  String? state;
  String? city;
  String? address;
  bool? isVerify;
  String? createdAt;
  int? iV;
  int? commission;
  bool? isBusy;
  String? adharBackImage;
  String? adharFrontImage;
  String? bankPassbookImage;
  String? cancelChecqueImage;
  String? fcmToken;
  bool? isExpert;
  bool? otherPlatformWork;
  String? panImage;
  int? poojaCommission;
  int? referralCommission;
  String? maxWaitingTime;
  String? referralCode;
  int? pincode;
  String? qualification;
  String? otp;
  String? otpExpiry;
  bool? isLive;
  String? currentLiveSession;

  Astrologer(
      {this.pricing,
        this.wallet,
        this.services,
        this.sId,
        this.name,
        this.email,
        this.mobile,
        this.status,
        this.profileImage,
        this.about,
        this.language,
        this.experience,
        this.speciality,
        this.isBlock,
        this.bankName,
        this.ifscCode,
        this.accountNumber,
        this.gstNumber,
        this.state,
        this.city,
        this.address,
        this.isVerify,
        this.createdAt,
        this.iV,
        this.commission,
        this.isBusy,
        this.adharBackImage,
        this.adharFrontImage,
        this.bankPassbookImage,
        this.cancelChecqueImage,
        this.fcmToken,
        this.isExpert,
        this.otherPlatformWork,
        this.panImage,
        this.poojaCommission,
        this.referralCommission,
        this.maxWaitingTime,
        this.referralCode,
        this.pincode,
        this.qualification,
        this.otp,
        this.otpExpiry,
        this.isLive,
        this.currentLiveSession});

  Astrologer.fromJson(Map<String, dynamic> json) {
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    wallet =
    json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    services = json['services'] != null
        ? new Services.fromJson(json['services'])
        : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    status = json['status'];
    profileImage = json['profileImage'];
    about = json['about'];
    language = json['language'].cast<String>();
    experience = json['experience'];
    speciality = json['speciality'].cast<String>();
    isBlock = json['isBlock'];
    bankName = json['bankName'];
    ifscCode = json['ifscCode'];
    accountNumber = json['accountNumber'];
    gstNumber = json['gstNumber'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    isVerify = json['isVerify'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    commission = json['commission'];
    isBusy = json['isBusy'];
    adharBackImage = json['adharBackImage'];
    adharFrontImage = json['adharFrontImage'];
    bankPassbookImage = json['bankPassbookImage'];
    cancelChecqueImage = json['cancelChecqueImage'];
    fcmToken = json['fcmToken'];
    isExpert = json['isExpert'];
    otherPlatformWork = json['otherPlatformWork'];
    panImage = json['panImage'];
    poojaCommission = json['poojaCommission'];
    referralCommission = json['referralCommission'];
    maxWaitingTime = json['maxWaitingTime'];
    referralCode = json['referralCode'];
    pincode = json['pincode'];
    qualification = json['qualification'];
    otp = json['otp'];
    otpExpiry = json['otpExpiry'];
    isLive = json['isLive'];
    currentLiveSession = json['currentLiveSession'];
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
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['status'] = this.status;
    data['profileImage'] = this.profileImage;
    data['about'] = this.about;
    data['language'] = this.language;
    data['experience'] = this.experience;
    data['speciality'] = this.speciality;
    data['isBlock'] = this.isBlock;
    data['bankName'] = this.bankName;
    data['ifscCode'] = this.ifscCode;
    data['accountNumber'] = this.accountNumber;
    data['gstNumber'] = this.gstNumber;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['isVerify'] = this.isVerify;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['commission'] = this.commission;
    data['isBusy'] = this.isBusy;
    data['adharBackImage'] = this.adharBackImage;
    data['adharFrontImage'] = this.adharFrontImage;
    data['bankPassbookImage'] = this.bankPassbookImage;
    data['cancelChecqueImage'] = this.cancelChecqueImage;
    data['fcmToken'] = this.fcmToken;
    data['isExpert'] = this.isExpert;
    data['otherPlatformWork'] = this.otherPlatformWork;
    data['panImage'] = this.panImage;
    data['poojaCommission'] = this.poojaCommission;
    data['referralCommission'] = this.referralCommission;
    data['maxWaitingTime'] = this.maxWaitingTime;
    data['referralCode'] = this.referralCode;
    data['pincode'] = this.pincode;
    data['qualification'] = this.qualification;
    data['otp'] = this.otp;
    data['otpExpiry'] = this.otpExpiry;
    data['isLive'] = this.isLive;
    data['currentLiveSession'] = this.currentLiveSession;
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

class PauseEvents {
  String? pausedAt;
  int? durationPaused;
  String? sId;
  String? resumedAt;
  String? id;

  PauseEvents(
      {this.pausedAt, this.durationPaused, this.sId, this.resumedAt, this.id});

  PauseEvents.fromJson(Map<String, dynamic> json) {
    pausedAt = json['pausedAt'];
    durationPaused = json['durationPaused'];
    sId = json['_id'];
    resumedAt = json['resumedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pausedAt'] = this.pausedAt;
    data['durationPaused'] = this.durationPaused;
    data['_id'] = this.sId;
    data['resumedAt'] = this.resumedAt;
    data['id'] = this.id;
    return data;
  }
}
