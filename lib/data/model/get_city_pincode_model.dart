class GetAddressPincodeDetailModel {
  bool? status;
  String? message;
  Data? data;

  GetAddressPincodeDetailModel({this.status, this.message, this.data});

  GetAddressPincodeDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? country;
  String? state;
  String? city;
  String? countryIso;
  String? stateIso;
  String? address;

  Data(
      {this.country,
        this.state,
        this.city,
        this.countryIso,
        this.stateIso,
        this.address});

  Data.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    state = json['state'];
    city = json['city'];
    countryIso = json['countryIso'];
    stateIso = json['stateIso'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['countryIso'] = this.countryIso;
    data['stateIso'] = this.stateIso;
    data['address'] = this.address;
    return data;
  }
}
