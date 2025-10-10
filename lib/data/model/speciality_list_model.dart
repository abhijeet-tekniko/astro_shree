class SpecialityListModel {
  bool? status;
  String? message;
  List<SpecialityListData>? data;

  SpecialityListModel({this.status, this.message, this.data});

  SpecialityListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SpecialityListData>[];
      json['data'].forEach((v) {
        data!.add(new SpecialityListData.fromJson(v));
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

class SpecialityListData {
  String? sId;
  String? name;
  bool? status;
  String? createdAt;
  int? iV;

  SpecialityListData({this.sId, this.name, this.status, this.createdAt, this.iV});

  SpecialityListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
