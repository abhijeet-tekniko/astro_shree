class NotRespondChatModel {
  bool? status;
  String? message;
  Data? data;

  NotRespondChatModel({this.status, this.message, this.data});

  NotRespondChatModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? user;
  String? astrologer;
  String? status;
  String? createdAt;
  int? iV;
  String? respondedAt;

  Data(
      {this.sId,
        this.user,
        this.astrologer,
        this.status,
        this.createdAt,
        this.iV,
        this.respondedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    astrologer = json['astrologer'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    respondedAt = json['respondedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['astrologer'] = this.astrologer;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['respondedAt'] = this.respondedAt;
    return data;
  }
}
