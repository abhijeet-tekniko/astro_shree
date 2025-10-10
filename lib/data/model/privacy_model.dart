class GetPrivacyPolicyModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<PrivacyPolicyData>? data;

  GetPrivacyPolicyModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetPrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PrivacyPolicyData>[];
      json['data'].forEach((v) {
        data!.add(new PrivacyPolicyData.fromJson(v));
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

class PrivacyPolicyData {
  String? sId;
  String? privacyPolicy;
  String? type;
  String? createdAt;
  int? iV;

  PrivacyPolicyData({this.sId, this.privacyPolicy, this.type, this.createdAt, this.iV});

  PrivacyPolicyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    privacyPolicy = json['privacyPolicy'];
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['privacyPolicy'] = this.privacyPolicy;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}


///aboutUs
class GetAboutUsModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<GetAboutUsData>? data;

  GetAboutUsModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetAboutUsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetAboutUsData>[];
      json['data'].forEach((v) {
        data!.add(new GetAboutUsData.fromJson(v));
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

class GetAboutUsData {
  String? sId;
  String? aboutUs;
  String? type;
  String? createdAt;
  int? iV;

  GetAboutUsData({this.sId, this.aboutUs, this.type, this.createdAt, this.iV});

  GetAboutUsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    aboutUs = json['aboutUs'];
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['aboutUs'] = this.aboutUs;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}


///terms
class GetTermsConditionModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<TermsData>? data;

  GetTermsConditionModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetTermsConditionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TermsData>[];
      json['data'].forEach((v) {
        data!.add(new TermsData.fromJson(v));
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

class TermsData {
  String? sId;
  String? termCondition;
  String? type;
  String? createdAt;
  int? iV;

  TermsData({this.sId, this.termCondition, this.type, this.createdAt, this.iV});

  TermsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    termCondition = json['termCondition'];
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['termCondition'] = this.termCondition;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

