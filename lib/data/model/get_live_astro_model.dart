class LiveAstrologerListModel {
  bool? status;
  int? results;
  List<LiveAstrologerListData>? data;

  LiveAstrologerListModel({this.status, this.results, this.data});

  LiveAstrologerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    results = json['results'];
    if (json['data'] != null) {
      data = <LiveAstrologerListData>[];
      json['data'].forEach((v) {
        data!.add(new LiveAstrologerListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['results'] = this.results;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiveAstrologerListData {
  String? astrologerId;
  String? name;
  String? profileImage;
  Pricing? pricing;
  String? status;
  bool? isLive;
  List<Specialities>? specialities;
  LiveSession? liveSession;

  LiveAstrologerListData(
      {this.astrologerId,
        this.name,
        this.profileImage,
        this.pricing,
        this.status,
        this.isLive,
        this.specialities,
        this.liveSession});

  LiveAstrologerListData.fromJson(Map<String, dynamic> json) {
    astrologerId = json['astrologerId'];
    name = json['name'];
    profileImage = json['profileImage'];
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    status = json['status'];
    isLive = json['isLive'];
    if (json['specialities'] != null) {
      specialities = <Specialities>[];
      json['specialities'].forEach((v) {
        specialities!.add(new Specialities.fromJson(v));
      });
    }
    liveSession = json['liveSession'] != null
        ? new LiveSession.fromJson(json['liveSession'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['astrologerId'] = this.astrologerId;
    data['name'] = this.name;
    data['profileImage'] = this.profileImage;
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    data['status'] = this.status;
    data['isLive'] = this.isLive;
    if (this.specialities != null) {
      data['specialities'] = this.specialities!.map((v) => v.toJson()).toList();
    }
    if (this.liveSession != null) {
      data['liveSession'] = this.liveSession!.toJson();
    }
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

class Specialities {
  String? specialityId;
  String? name;

  Specialities({this.specialityId, this.name});

  Specialities.fromJson(Map<String, dynamic> json) {
    specialityId = json['specialityId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['specialityId'] = this.specialityId;
    data['name'] = this.name;
    return data;
  }
}


class LiveSession {
  String? liveSessionId;
  String? title;
  String? description;
  String? startTime;
  String? startTimeIST;
  String? channelName;
  int? viewerCount;

  LiveSession(
      {this.liveSessionId,
        this.title,
        this.description,
        this.startTime,
        this.startTimeIST,
        this.channelName,
        this.viewerCount});

  LiveSession.fromJson(Map<String, dynamic> json) {
    liveSessionId = json['liveSessionId'];
    title = json['title'];
    description = json['description'];
    startTime = json['startTime'];
    startTimeIST = json['startTimeIST'];
    channelName = json['channelName'];
    viewerCount = json['viewerCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liveSessionId'] = this.liveSessionId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startTime'] = this.startTime;
    data['startTimeIST'] = this.startTimeIST;
    data['channelName'] = this.channelName;
    data['viewerCount'] = this.viewerCount;
    return data;
  }
}
