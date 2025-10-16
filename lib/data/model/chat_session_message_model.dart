class ChatSessionMessagesModel {
  bool? status;
  String? message;
  List<ChatSessionData>? data;

  ChatSessionMessagesModel({this.status, this.message, this.data});

  ChatSessionMessagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatSessionData>[];
      json['data'].forEach((v) {
        data!.add(ChatSessionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatSessionData {
  String? sId;
  String? id;
  Sender? sender;
  Sender? recipient;
  String? senderModel;
  String? recipientModel;
  String? message;
  String? timestamp;
  String? createdAtIST;
  bool? isRead;
  bool? edited;
  bool? deletedForSender;
  bool? deletedForRecipient;
  bool? deletedForEveryone;
  String? chatSession;
  int? iV;
  List<Media>? media;

  ChatSessionData({
    this.sId,
    this.id,
    this.sender,
    this.recipient,
    this.senderModel,
    this.recipientModel,
    this.message,
    this.timestamp,
    this.createdAtIST,
    this.isRead,
    this.edited,
    this.deletedForSender,
    this.deletedForRecipient,
    this.deletedForEveryone,
    this.chatSession,
    this.iV,
    this.media,
  });

  ChatSessionData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    sender = json['sender'] != null ? Sender.fromJson(json['sender']) : null;
    recipient = json['recipient'] != null ? Sender.fromJson(json['recipient']) : null;
    senderModel = json['senderModel'];
    recipientModel = json['recipientModel'];
    message = json['message'];
    timestamp = json['timestamp'];
    createdAtIST = json['createdAtIST'];
    isRead = json['isRead'];
    edited = json['edited'];
    deletedForSender = json['deletedForSender'];
    deletedForRecipient = json['deletedForRecipient'];
    deletedForEveryone = json['deletedForEveryone'];
    chatSession = json['chatSession'];
    iV = json['__v'];

    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['id'] = id;
    if (sender != null) data['sender'] = sender!.toJson();
    if (recipient != null) data['recipient'] = recipient!.toJson();
    data['senderModel'] = senderModel;
    data['recipientModel'] = recipientModel;
    data['message'] = message;
    data['timestamp'] = timestamp;
    data['createdAtIST'] = createdAtIST;
    data['isRead'] = isRead;
    data['edited'] = edited;
    data['deletedForSender'] = deletedForSender;
    data['deletedForRecipient'] = deletedForRecipient;
    data['deletedForEveryone'] = deletedForEveryone;
    data['chatSession'] = chatSession;
    data['__v'] = iV;
    if (media != null) {
      data['media'] = media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sender {
  String? sId;
  String? id;
  String? name;
  String? profileImage;
  String? updatedAtIST;

  Sender({this.sId, this.id, this.name, this.profileImage, this.updatedAtIST});

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    updatedAtIST = json['updatedAtIST'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['updatedAtIST'] = updatedAtIST;
    return data;
  }
}

class Media {
  String? url;
  String? type;
  String? mimeType;
  String? fileName;
  int? fileSize;
  String? sId;
  String? id;

  Media({
    this.url,
    this.type,
    this.mimeType,
    this.fileName,
    this.fileSize,
    this.sId,
    this.id,
  });

  Media.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
    mimeType = json['mimeType'];
    fileName = json['fileName'];
    fileSize = json['fileSize'];
    sId = json['_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['type'] = type;
    data['mimeType'] = mimeType;
    data['fileName'] = fileName;
    data['fileSize'] = fileSize;
    data['_id'] = sId;
    data['id'] = id;
    return data;
  }
}
