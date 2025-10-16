

class AstrologerResponse {
  final bool status;
  final String message;
  final List<Astrologer> data;

  AstrologerResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AstrologerResponse.fromJson(Map<String, dynamic> json) {
    return AstrologerResponse(
      status: json['status'],
      message: json['message'],
      data: List<Astrologer>.from(json['data'].map((x) => Astrologer.fromJson(x))),
    );
  }
}

class Astrologer {
  final String id;
  final String name;
  final String email;
  final String mobile;
   String status;
   bool isBusy;
  final bool isExpert;
  final bool isBlock;
  final bool isVerify;
  final bool otherPlatformWork;
  final String? fcmToken;
  final String? profileImage;
  final String? about;
  final String? qualification;
  final int? experience;
  final Pricing pricing;
  final Wallet wallet;
  final Services services;
  final List<String> language;
  final List<Speciality> speciality;
  final String? bankName;
  final String? ifscCode;
  final String? accountNumber;
  final String? gstNumber;
  final String? state;
  final String? city;
  final String? address;
  final int? pincode;
  final int? commission;
  // final List<String> documentImage;
  final String? adharFrontImage;
  final String? adharBackImage;
  final String? panImage;
  final String? bankPassbookImage;
  final String? cancelChecqueImage;
  final DateTime createdAt;

  var poojaCommission;
  var referralCommission;
  String? maxWaitingTime;
  var chatDuration;
  var callDuration;
  var videoCallDuration;
  var ratingAverage;
  var ratingCount;

  Astrologer({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.status,
    required this.isBusy,
    required this.isExpert,
    required this.isBlock,
    required this.isVerify,
    required this.otherPlatformWork,
    required this.pricing,
    required this.wallet,
    required this.services,
    required this.language,
    required this.speciality,
    required this.createdAt,
    this.profileImage,
    this.about,
    this.qualification,
    this.experience,
    this.fcmToken,
    this.bankName,
    this.ifscCode,
    this.accountNumber,
    this.gstNumber,
    this.state,
    this.city,
    this.address,
    this.pincode,
    this.commission,
    // this.documentImage = const [],
    this.adharFrontImage,
    this.adharBackImage,
    this.panImage,
    this.bankPassbookImage,
    this.cancelChecqueImage,
    this.poojaCommission,
    this.referralCommission,
    this.maxWaitingTime,
    this.chatDuration,
    this.callDuration,
    this.videoCallDuration,
    this.ratingAverage,
    this.ratingCount,
  });

  Astrologer copyWith({
    String? status,
    bool? isBusy,
  }) {
    return Astrologer(
      id: id,
      name: name,
      email: email,
      mobile: mobile,
      status: status ?? this.status,
      isBusy: isBusy ?? this.isBusy,
      isExpert: isExpert,
      isBlock: isBlock,
      isVerify: isVerify,
      otherPlatformWork: otherPlatformWork,
      profileImage: profileImage,
      about: about,
      qualification: qualification,
      experience: experience,
      fcmToken: fcmToken,
      pricing: pricing,
      wallet: wallet,
      services: services,
      language: language,
      speciality: speciality,
      bankName: bankName,
      ifscCode: ifscCode,
      accountNumber: accountNumber,
      gstNumber: gstNumber,
      state: state,
      city: city,
      address: address,
      pincode: pincode,
      commission: commission,
      adharFrontImage: adharFrontImage,
      adharBackImage: adharBackImage,
      panImage: panImage,
      bankPassbookImage: bankPassbookImage,
      cancelChecqueImage: cancelChecqueImage,
      createdAt: createdAt,
      poojaCommission: poojaCommission,
      referralCommission: referralCommission,
      maxWaitingTime: maxWaitingTime,
      chatDuration: chatDuration,
      callDuration: callDuration,
      videoCallDuration: videoCallDuration,
      ratingAverage: ratingAverage,
      ratingCount: ratingCount,
    );
  }

  factory Astrologer.fromJson(Map<String, dynamic> json) {
    return Astrologer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      status: json['status'],
      isBusy: json['isBusy'] ?? false,
      isExpert: json['isExpert'] ?? false,
      isBlock: json['isBlock'] ?? false,
      isVerify: json['isVerify'] ?? false,
      otherPlatformWork: json['otherPlatformWork'] ?? false,
      profileImage: json['profileImage'],
      about: json['about'],
      qualification: json['qualification'],
      experience: json['experience'],
      fcmToken: json['fcmToken'] == "" ? null : json['fcmToken'],
      pricing: Pricing.fromJson(json['pricing']),
      wallet: Wallet.fromJson(json['wallet']),
      services: Services.fromJson(json['services']),
      language: List<String>.from(json['language']),
      speciality: List<Speciality>.from(json['speciality'].map((x) => Speciality.fromJson(x))),
      bankName: json['bankName'],
      ifscCode: json['ifscCode'],
      accountNumber: json['accountNumber'],
      gstNumber: json['gstNumber'],
      state: json['state'],
      city: json['city'],
      address: json['address'],
      pincode: json['pincode'],
      commission: json['commission'],
      // documentImage: List<String>.from(json['documentImage'] ?? []),
      adharFrontImage: json['adharFrontImage'],
      adharBackImage: json['adharBackImage'],
      panImage: json['panImage'],
      bankPassbookImage: json['bankPassbookImage'],
      cancelChecqueImage: json['cancelChecqueImage'],
      createdAt: DateTime.parse(json['createdAt']),
      poojaCommission : json['poojaCommission'],
        referralCommission :json['referralCommission'],
        maxWaitingTime : json['maxWaitingTime'],
    chatDuration :json['chatDuration'],
    callDuration : json['callDuration'],
    videoCallDuration : json['videoCallDuration'],
    ratingAverage : json['ratingAverage'],
    ratingCount : json['ratingCount'],
    );
  }
}

class Pricing {
  final int chat;
  final int voice;
  final int video;

  Pricing({
    required this.chat,
    required this.voice,
    required this.video,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      chat: json['chat'],
      voice: json['voice'],
      video: json['video'],
    );
  }
}

class Wallet {
  final double balance;
  final double lockedBalance;

  Wallet({
    required this.balance,
    required this.lockedBalance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] as num).toDouble(),
      lockedBalance: (json['lockedBalance'] as num).toDouble(),
    );
  }
}

class Services {
  final bool chat;
  final bool voice;
  final bool video;

  Services({
    required this.chat,
    required this.voice,
    required this.video,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      chat: json['chat'],
      voice: json['voice'],
      video: json['video'],
    );
  }
}

class Speciality {
  final String id;
  final String name;
  final bool status;
  final DateTime createdAt;

  Speciality({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      id: json['_id'],
      name: json['name'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
