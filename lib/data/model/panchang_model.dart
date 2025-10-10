// models/advanced_panchang_model.dart

class AdvancedPanchangResponse {
  final bool status;
  final String message;
  final AdvancedPanchangData data;

  AdvancedPanchangResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AdvancedPanchangResponse.fromJson(Map<String, dynamic> json) {
    return AdvancedPanchangResponse(
      status: json['status'],
      message: json['message'],
      data: AdvancedPanchangData.fromJson(json['data']),
    );
  }
}

class AdvancedPanchangData {
  final AdvancedPanchang advancedPanchang;

  AdvancedPanchangData({required this.advancedPanchang});

  factory AdvancedPanchangData.fromJson(Map<String, dynamic> json) {
    return AdvancedPanchangData(
      advancedPanchang:
      AdvancedPanchang.fromJson(json['advancedPanchang']),
    );
  }
}

class AdvancedPanchang {
  final String day;
  final Tithi tithi;
  final Nakshatra nakshatra;
  final Karana karana;
  final Yoga yoga;
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  final String vedicSunrise;
  final String vedicSunset;
  final String paksha;
  final String ayana;
  final String ritu;
  final String sunSign;
  final String moonSign;
  final String panchangYog;
  final int vikramSamvat;
  final int shakaSamvat;
  final String vikramSamvatName;
  final String shakaSamvatName;
  final AbhijitMuhurta abhijitMuhurta;
  final Rahukaal rahukaal;
  final Rahukaal guliKaal;
  final Rahukaal yamghantKaal;

  AdvancedPanchang({
    required this.day,
    required this.tithi,
    required this.nakshatra,
    required this.karana,
    required this.yoga,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.vedicSunrise,
    required this.vedicSunset,
    required this.paksha,
    required this.ayana,
    required this.ritu,
    required this.sunSign,
    required this.moonSign,
    required this.panchangYog,
    required this.vikramSamvat,
    required this.shakaSamvat,
    required this.vikramSamvatName,
    required this.shakaSamvatName,
    required this.abhijitMuhurta,
    required this.rahukaal,
    required this.guliKaal,
    required this.yamghantKaal,
  });

  factory AdvancedPanchang.fromJson(Map<String, dynamic> json) {
    return AdvancedPanchang(
      day: json['day'],
      tithi: Tithi.fromJson(json['tithi']),
      nakshatra: Nakshatra.fromJson(json['nakshatra']),
      karana: Karana.fromJson(json['karana']),
      yoga: Yoga.fromJson(json['yoga']),
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      vedicSunrise: json['vedic_sunrise'],
      vedicSunset: json['vedic_sunset'],
      paksha: json['paksha'],
      ayana: json['ayana'],
      ritu: json['ritu'],
      sunSign: json['sun_sign'],
      moonSign: json['moon_sign'],
      panchangYog: json['panchang_yog'],
      vikramSamvat: json['vikram_samvat'],
      shakaSamvat: json['shaka_samvat'],
      vikramSamvatName: json['vikram_samvat_name'],
      shakaSamvatName: json['shaka_samvat_name'],
      abhijitMuhurta: AbhijitMuhurta.fromJson(json['abhijit_muhurta']),
      rahukaal: Rahukaal.fromJson(json['rahukaal']),
      guliKaal: Rahukaal.fromJson(json['guliKaal']),
      yamghantKaal: Rahukaal.fromJson(json['yamghant_kaal']),
    );
  }
}

class Tithi {
  final String name;
  final String deity;
  final String summary;
  final String special;
  final String endTime;

  Tithi({
    required this.name,
    required this.deity,
    required this.summary,
    required this.special,
    required this.endTime,
  });

  factory Tithi.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    final endTime = json['end_time'];
    return Tithi(
      name: details['tithi_name'],
      deity: details['deity'],
      summary: details['summary'],
      special: details['special'],
      endTime:
      "${endTime['hour'].toString().padLeft(2, '0')}:${endTime['minute'].toString().padLeft(2, '0')}:${endTime['second'].toString().padLeft(2, '0')}",
    );
  }
}

class Nakshatra {
  final String name;
  final String deity;
  final String ruler;
  final String summary;
  final String endTime;

  Nakshatra({
    required this.name,
    required this.deity,
    required this.ruler,
    required this.summary,
    required this.endTime,
  });

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    final endTime = json['end_time'];
    return Nakshatra(
      name: details['nak_name'],
      deity: details['deity'],
      ruler: details['ruler'],
      summary: details['summary'],
      endTime:
      "${endTime['hour'].toString().padLeft(2, '0')}:${endTime['minute'].toString().padLeft(2, '0')}:${endTime['second'].toString().padLeft(2, '0')}",
    );
  }
}

class Karana {
  final String name;
  final String deity;
  final String special;
  final String endTime;

  Karana({
    required this.name,
    required this.deity,
    required this.special,
    required this.endTime,
  });

  factory Karana.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    final endTime = json['end_time'];
    return Karana(
      name: details['karan_name'],
      deity: details['deity'],
      special: details['special'],
      endTime:
      "${endTime['hour'].toString().padLeft(2, '0')}:${endTime['minute'].toString().padLeft(2, '0')}:${endTime['second'].toString().padLeft(2, '0')}",
    );
  }
}

class Yoga {
  final String name;
  final String meaning;
  final String special;
  final String endTime;

  Yoga({
    required this.name,
    required this.meaning,
    required this.special,
    required this.endTime,
  });

  factory Yoga.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    final endTime = json['end_time'];
    return Yoga(
      name: details['yog_name'],
      meaning: details['meaning'],
      special: details['special'],
      endTime:
      "${endTime['hour'].toString().padLeft(2, '0')}:${endTime['minute'].toString().padLeft(2, '0')}:${endTime['second'].toString().padLeft(2, '0')}",
    );
  }
}

class AbhijitMuhurta {
  final String start;
  final String end;

  AbhijitMuhurta({required this.start, required this.end});

  factory AbhijitMuhurta.fromJson(Map<String, dynamic> json) {
    return AbhijitMuhurta(start: json['start'], end: json['end']);
  }
}

class Rahukaal {
  final String start;
  final String end;

  Rahukaal({required this.start, required this.end});

  factory Rahukaal.fromJson(Map<String, dynamic> json) {
    return Rahukaal(start: json['start'], end: json['end']);
  }
}
