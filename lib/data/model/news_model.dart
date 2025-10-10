class GetNewsModel {
  bool? status;
  int? totalResult;
  int? totalPage;
  String? message;
  List<NewsData>? data;

  GetNewsModel(
      {this.status, this.totalResult, this.totalPage, this.message, this.data});

  GetNewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResult = json['totalResult'];
    totalPage = json['totalPage'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewsData>[];
      json['data'].forEach((v) {
        data!.add(new NewsData.fromJson(v));
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

class NewsData {
  String? sId;
  String? title;
  String? description;
  String? image;
  String? link;
  String? source;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? iV;

  NewsData(
      {this.sId,
        this.title,
        this.description,
        this.image,
        this.link,
        this.source,
        this.date,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NewsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    source = json['source'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['link'] = this.link;
    data['source'] = this.source;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
