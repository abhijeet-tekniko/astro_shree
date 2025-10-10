class NotifyAstroModel {
  bool? status;
  String? message;
  Data? data;

  NotifyAstroModel({this.status, this.message, this.data});

  NotifyAstroModel.fromJson(Map<String, dynamic> json) {
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
  String? user;
  String? astrologer;
  String? title;
  String? message;
  String? type;
  String? sId;
  String? createdAt;
  int? iV;

  Data(
      {this.user,
        this.astrologer,
        this.title,
        this.message,
        this.type,
        this.sId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    astrologer = json['astrologer'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['astrologer'] = this.astrologer;
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
