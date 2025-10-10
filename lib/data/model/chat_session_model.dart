class ChatSessionListModel {
  bool? status;
  String? message;
  List<ChatSessionListData>? data;

  ChatSessionListModel({this.status, this.message, this.data});

  ChatSessionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatSessionListData>[];
      json['data'].forEach((v) {
        data!.add(new ChatSessionListData.fromJson(v));
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

class ChatSessionListData {
  String? sId;
  User? user;
  ChatAstrologer? astrologer;
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

  ChatSessionListData(
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

  ChatSessionListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    astrologer = json['astrologer'] != null
        ? new ChatAstrologer.fromJson(json['astrologer'])
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

class ChatAstrologer {
  String? sId;
  String? name;
  String? profileImage;

  ChatAstrologer({this.sId, this.name, this.profileImage});

  ChatAstrologer.fromJson(Map<String, dynamic> json) {
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


// class ChatSessionListModel {
//   bool? status;
//   String? message;
//   List<ChatSessionListData>? data;
//
//   ChatSessionListModel({this.status, this.message, this.data});
//
//   ChatSessionListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <ChatSessionListData>[];
//       json['data'].forEach((v) {
//         data!.add(new ChatSessionListData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ChatSessionListData {
//   String? sId;
//   User? user;
//   ChatAstrologer? astrologer;
//   String? chatRequest;
//   String? status;
//   String? startedAt;
//   int? iV;
//   String? endedAt;
//
//   ChatSessionListData(
//       {this.sId,
//         this.user,
//         this.astrologer,
//         this.chatRequest,
//         this.status,
//         this.startedAt,
//         this.iV,
//         this.endedAt});
//
//   ChatSessionListData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     astrologer = json['astrologer'] != null
//         ? new ChatAstrologer.fromJson(json['astrologer'])
//         : null;
//     chatRequest = json['chatRequest'];
//     status = json['status'];
//     startedAt = json['startedAt'];
//     iV = json['__v'];
//     endedAt = json['endedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     if (this.astrologer != null) {
//       data['astrologer'] = this.astrologer!.toJson();
//     }
//     data['chatRequest'] = this.chatRequest;
//     data['status'] = this.status;
//     data['startedAt'] = this.startedAt;
//     data['__v'] = this.iV;
//     data['endedAt'] = this.endedAt;
//     return data;
//   }
// }
//
// class User {
//   String? sId;
//   String? name;
//
//   User({this.sId, this.name});
//
//   User.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     return data;
//   }
// }
//
// class ChatAstrologer {
//   String? sId;
//   String? name;
//   String? profileImage;
//
//   ChatAstrologer({this.sId, this.name, this.profileImage});
//
//   ChatAstrologer.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     profileImage = json['profileImage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['profileImage'] = this.profileImage;
//     return data;
//   }}
