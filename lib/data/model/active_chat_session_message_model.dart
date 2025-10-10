class ActiveSessionMessageModel {
  bool? status;
  String? message;
  List<ActiveSessionMessageData>? data;

  ActiveSessionMessageModel({this.status, this.message, this.data});

  ActiveSessionMessageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ActiveSessionMessageData>[];
      json['data'].forEach((v) {
        data!.add(new ActiveSessionMessageData.fromJson(v));
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

class ActiveSessionMessageData {
  String? sId;
  Sender? sender;
  Sender? recipient;
  String? senderModel;
  String? recipientModel;
  String? message;
  String? timestamp;
  bool? isRead;
  bool? edited;
  bool? deletedForSender;
  bool? deletedForRecipient;
  bool? deletedForEveryone;
  String? chatSession;
  int? iV;

  ActiveSessionMessageData(
      {this.sId,
        this.sender,
        this.recipient,
        this.senderModel,
        this.recipientModel,
        this.message,
        this.timestamp,
        this.isRead,
        this.edited,
        this.deletedForSender,
        this.deletedForRecipient,
        this.deletedForEveryone,
        this.chatSession,
        this.iV});

  ActiveSessionMessageData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    recipient = json['recipient'] != null
        ? new Sender.fromJson(json['recipient'])
        : null;
    senderModel = json['senderModel'];
    recipientModel = json['recipientModel'];
    message = json['message'];
    timestamp = json['timestamp'];
    isRead = json['isRead'];
    edited = json['edited'];
    deletedForSender = json['deletedForSender'];
    deletedForRecipient = json['deletedForRecipient'];
    deletedForEveryone = json['deletedForEveryone'];
    chatSession = json['chatSession'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }
    data['senderModel'] = this.senderModel;
    data['recipientModel'] = this.recipientModel;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    data['isRead'] = this.isRead;
    data['edited'] = this.edited;
    data['deletedForSender'] = this.deletedForSender;
    data['deletedForRecipient'] = this.deletedForRecipient;
    data['deletedForEveryone'] = this.deletedForEveryone;
    data['chatSession'] = this.chatSession;
    data['__v'] = this.iV;
    return data;
  }
}

class Sender {
  String? sId;
  String? profileImage;
  String? name;

  Sender({this.sId, this.profileImage, this.name});

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profileImage'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profileImage'] = this.profileImage;
    data['name'] = this.name;
    return data;
  }
}
