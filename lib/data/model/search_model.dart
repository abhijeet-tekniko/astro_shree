class GetGlobalSearchModel {
  bool? status;
  String? message;
  Data? data;

  GetGlobalSearchModel({this.status, this.message, this.data});

  GetGlobalSearchModel.fromJson(Map<String, dynamic> json) {
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
  Astrologers? astrologers;
  Poojas? poojas;
  Products? products;

  Data({this.astrologers, this.poojas, this.products});

  Data.fromJson(Map<String, dynamic> json) {
    astrologers = json['astrologers'] != null
        ? new Astrologers.fromJson(json['astrologers'])
        : null;
    poojas =
    json['poojas'] != null ? new Poojas.fromJson(json['poojas']) : null;
    products =
    json['products'] != null ? new Products.fromJson(json['products']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.astrologers != null) {
      data['astrologers'] = this.astrologers!.toJson();
    }
    if (this.poojas != null) {
      data['poojas'] = this.poojas!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class Astrologers {
  List<Results>? results;
  int? totalResult;
  int? totalPage;

  Astrologers({this.results, this.totalResult, this.totalPage});

  Astrologers.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    return data;
  }
}

class Results {
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
  List<Speciality>? speciality;
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

  Results(
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
        // this.documentImage,
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
        this.maxWaitingTime});

  Results.fromJson(Map<String, dynamic> json) {
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
    if (json['speciality'] != null) {
      speciality = <Speciality>[];
      json['speciality'].forEach((v) {
        speciality!.add(new Speciality.fromJson(v));
      });
    }
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
    if (this.speciality != null) {
      data['speciality'] = this.speciality!.map((v) => v.toJson()).toList();
    }
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

class Speciality {
  String? sId;
  String? name;
  bool? status;
  String? createdAt;
  int? iV;

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

///poojaSearch
class Poojas {
  List<PoojaData>? results;
  int? totalResult;
  int? totalPage;

  Poojas({this.results, this.totalResult, this.totalPage});

  Poojas.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <PoojaData>[];
      json['results'].forEach((v) {
        results!.add(new PoojaData.fromJson(v));
      });
    }
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    return data;
  }
}

class PoojaData {
  String? sId;
  String? name;
  String? shortDescription;
  String? about;
  String? image;
  String? purpose;
  List<String>? benefits;
  List<AssignAstrologer>? assignAstrologer;
  bool? status;
  String? createdAt;
  int? iV;

  PoojaData(
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

  PoojaData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    about = json['about'];
    image = json['image'];
    purpose = json['purpose'];
    benefits = json['benefits'].cast<String>();
    if (json['assignAstrologer'] != null) {
      assignAstrologer = <AssignAstrologer>[];
      json['assignAstrologer'].forEach((v) {
        assignAstrologer!.add(new AssignAstrologer.fromJson(v));
      });
    }
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
    if (this.assignAstrologer != null) {
      data['assignAstrologer'] =
          this.assignAstrologer!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class AssignAstrologer {
  String? sId;
  String? astrologer;
  String? pooja;
  int? price;
  int? sellPrice;
  String? assignedAt;
  int? iV;

  AssignAstrologer(
      {this.sId,
        this.astrologer,
        this.pooja,
        this.price,
        this.sellPrice,
        this.assignedAt,
        this.iV});

  AssignAstrologer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    astrologer = json['astrologer'];
    pooja = json['pooja'];
    price = json['price'];
    sellPrice = json['sellPrice'];
    assignedAt = json['assignedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['astrologer'] = this.astrologer;
    data['pooja'] = this.pooja;
    data['price'] = this.price;
    data['sellPrice'] = this.sellPrice;
    data['assignedAt'] = this.assignedAt;
    data['__v'] = this.iV;
    return data;
  }
}


///productSearch
class Products {
  List<ProductsSearchData>? results;
  int? totalResult;
  int? totalPage;

  Products({this.results, this.totalResult, this.totalPage});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ProductsSearchData>[];
      json['results'].forEach((v) {
        results!.add(new ProductsSearchData.fromJson(v));
      });
    }
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['totalResult'] = this.totalResult;
    data['totalPage'] = this.totalPage;
    return data;
  }
}

class ProductsSearchData {
  String? sId;
  String? name;
  int? price;
  int? sellPrice;
  String? benefits;
  String? description;
  String? thumbImage;
  List<String>? image;
  Category? category;
  bool? status;
  String? createdAt;
  int? iV;

  ProductsSearchData(
      {this.sId,
        this.name,
        this.price,
        this.sellPrice,
        this.benefits,
        this.description,
        this.thumbImage,
        this.image,
        this.category,
        this.status,
        this.createdAt,
        this.iV});

  ProductsSearchData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    sellPrice = json['sellPrice'];
    benefits = json['benefits'];
    description = json['description'];
    thumbImage = json['thumbImage'];
    image = json['image'].cast<String>();
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['sellPrice'] = this.sellPrice;
    data['benefits'] = this.benefits;
    data['description'] = this.description;
    data['thumbImage'] = this.thumbImage;
    data['image'] = this.image;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Category {
  String? sId;
  String? name;
  String? image;
  String? description;
  bool? status;
  String? createdAt;
  int? iV;

  Category(
      {this.sId,
        this.name,
        this.image,
        this.description,
        this.status,
        this.createdAt,
        this.iV});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}