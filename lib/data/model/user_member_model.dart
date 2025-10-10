class GetMemberListModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<Data>? data;

  GetMemberListModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetMemberListModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? gender;
  String? dob;
  String? birthTime;
  String? placeOfBirth;
  String? createdAt;
  int? iV;

  Data(
      {this.sId,
        this.name,
        this.gender,
        this.dob,
        this.birthTime,
        this.placeOfBirth,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    gender = json['gender'];
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
    data['dob'] = this.dob;
    data['birthTime'] = this.birthTime;
    data['placeOfBirth'] = this.placeOfBirth;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
