class ActiveSessionModel {
  bool? status;
  bool? active;
  String? message;
  ActiveSessionData? data;

  ActiveSessionModel({this.status, this.active, this.message, this.data});

  ActiveSessionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    active = json['active'];
    message = json['message'];
    data = json['data'] != null ? new ActiveSessionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['active'] = this.active;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ActiveSessionData {
  String? chatSessionId;
  User? user;
  User? astrologer;
  String? type;
  String? startedAt;
  int? durationMinutes;
  int? remainingTime;

  ActiveSessionData(
      {this.chatSessionId,
        this.user,
        this.astrologer,
        this.type,
        this.startedAt,
        this.durationMinutes,
        this.remainingTime});

  ActiveSessionData.fromJson(Map<String, dynamic> json) {
    chatSessionId = json['chatSessionId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    astrologer = json['astrologer'] != null
        ? new User.fromJson(json['astrologer'])
        : null;
    type = json['type'];
    startedAt = json['startedAt'];
    durationMinutes = json['durationMinutes'];
    remainingTime = json['remainingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatSessionId'] = this.chatSessionId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.astrologer != null) {
      data['astrologer'] = this.astrologer!.toJson();
    }
    data['type'] = this.type;
    data['startedAt'] = this.startedAt;
    data['durationMinutes'] = this.durationMinutes;
    data['remainingTime'] = this.remainingTime;
    return data;
  }
}

class User {
  String? sId;
  String? name;
  String? profileImage;

  User({this.sId, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    return data;
  }
}
