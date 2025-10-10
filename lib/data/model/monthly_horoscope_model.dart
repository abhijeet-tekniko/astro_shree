class GetMonthlyHoroscopeModel {
  bool? status;
  String? message;
  List<Data>? data;

  GetMonthlyHoroscopeModel({this.status, this.message, this.data});

  GetMonthlyHoroscopeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? zodiacName;
  Prediction? prediction;

  Data({this.zodiacName, this.prediction});

  Data.fromJson(Map<String, dynamic> json) {
    zodiacName = json['zodiacName'];
    prediction = json['prediction'] != null
        ? new Prediction.fromJson(json['prediction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zodiacName'] = this.zodiacName;
    if (this.prediction != null) {
      data['prediction'] = this.prediction!.toJson();
    }
    return data;
  }
}

class Prediction {
  bool? status;
  String? sunSign;
  String? predictionMonth;
  List<String>? prediction;

  Prediction(
      {this.status, this.sunSign, this.predictionMonth, this.prediction});

  Prediction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sunSign = json['sun_sign'];
    predictionMonth = json['prediction_month'];
    prediction = json['prediction'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['sun_sign'] = this.sunSign;
    data['prediction_month'] = this.predictionMonth;
    data['prediction'] = this.prediction;
    return data;
  }
}
