class HoroscopeModel {
  bool? status;
  String? message;
  List<HoroscopeData>? data;

  HoroscopeModel({this.status, this.message, this.data});

  HoroscopeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <HoroscopeData>[];
      json['data'].forEach((v) {
        data!.add(new HoroscopeData.fromJson(v));
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

class HoroscopeData {
  String? zodiacName;
  Prediction? prediction;

  HoroscopeData({this.zodiacName, this.prediction});

  HoroscopeData.fromJson(Map<String, dynamic> json) {
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
  String? predictionDate;
  PersonalPrediction? prediction;

  Prediction({this.status, this.sunSign, this.predictionDate, this.prediction});

  Prediction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    sunSign = json['sun_sign'];
    predictionDate = json['prediction_date'];
    prediction = json['prediction'] != null
        ? new PersonalPrediction.fromJson(json['prediction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['sun_sign'] = this.sunSign;
    data['prediction_date'] = this.predictionDate;
    if (this.prediction != null) {
      data['prediction'] = this.prediction!.toJson();
    }
    return data;
  }
}

class PersonalPrediction {
  String? personalLife;
  String? profession;
  String? health;
  String? emotions;
  String? travel;
  String? luck;

  PersonalPrediction(
      {this.personalLife,
        this.profession,
        this.health,
        this.emotions,
        this.travel,
        this.luck});

  PersonalPrediction.fromJson(Map<String, dynamic> json) {
    personalLife = json['personal_life'];
    profession = json['profession'];
    health = json['health'];
    emotions = json['emotions'];
    travel = json['travel'];
    luck = json['luck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personal_life'] = this.personalLife;
    data['profession'] = this.profession;
    data['health'] = this.health;
    data['emotions'] = this.emotions;
    data['travel'] = this.travel;
    data['luck'] = this.luck;
    return data;
  }
}
