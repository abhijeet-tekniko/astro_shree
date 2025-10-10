// main_response.dart
class KundliMatchingResponse {
  final bool status;
  final String message;
  final KundliData data;

  KundliMatchingResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KundliMatchingResponse.fromJson(Map<String, dynamic> json) {
    return KundliMatchingResponse(
      status: json['status'],
      message: json['message'],
      data: KundliData.fromJson(json['data']),
    );
  }
}

class KundliData {
  final PersonDetails maleDetails;
  final PersonDetails femaleDetails;
  final MatchResult matchResult;

  KundliData({
    required this.maleDetails,
    required this.femaleDetails,
    required this.matchResult,
  });

  factory KundliData.fromJson(Map<String, dynamic> json) {
    return KundliData(
      maleDetails: PersonDetails.fromJson(json['maleDetails']),
      femaleDetails: PersonDetails.fromJson(json['femaleDetails']),
      matchResult: MatchResult.fromJson(json['matchResult']),
    );
  }
}

class PersonDetails {
  final String name;
  final int day;
  final int month;
  final int year;
  final int hour;
  final int min;
  final double lat;
  final double lon;
  final double tzone;
  final String language;
  final String rashi;

  PersonDetails({
    required this.name,
    required this.day,
    required this.month,
    required this.year,
    required this.hour,
    required this.min,
    required this.lat,
    required this.lon,
    required this.tzone,
    required this.language,
    required this.rashi,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      name: json['name'],
      day: json['day'],
      month: json['month'],
      year: json['year'],
      hour: json['hour'],
      min: json['min'],
      lat: json['lat'],
      lon: json['lon'],
      tzone: json['tzone'],
      language: json['language'],
      rashi: json['rashi'],
    );
  }
}

class MatchResult {
  final GunaMilan gunaMilan;
  final DoshaAnalysis doshaAnalysis;
  final Compatibility compatibility;
  final List<String> remedies;
  final Chart charts;
  final String overallConclusion;

  MatchResult({
    required this.gunaMilan,
    required this.doshaAnalysis,
    required this.compatibility,
    required this.remedies,
    required this.charts,
    required this.overallConclusion,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      gunaMilan: GunaMilan.fromJson(json['gunaMilan']),
      doshaAnalysis: DoshaAnalysis.fromJson(json['doshaAnalysis']),
      compatibility: Compatibility.fromJson(json['compatibility']),
      remedies: List<String>.from(json['remedies']),
      charts: Chart.fromJson(json['charts']),
      overallConclusion: json['overallConclusion'],
    );
  }
}
class GunaMilan {
  final double score;
  final int maxScore;
  final int minimumRequired;
  final GunaDetails details;
  final String conclusion;

  GunaMilan({
    required this.score,
    required this.maxScore,
    required this.minimumRequired,
    required this.details,
    required this.conclusion,
  });

  factory GunaMilan.fromJson(Map<String, dynamic> json) {
    return GunaMilan(
      score: json['score'].toDouble(),
      maxScore: json['maxScore'],
      minimumRequired: json['minimumRequired'],
      details: GunaDetails.fromJson(json['details']),
      conclusion: json['conclusion'],
    );
  }
}

class GunaDetails {
  final GunaAttribute varna;
  final GunaAttribute vashya;
  final GunaAttribute tara;
  final GunaAttribute yoni;
  final GunaAttribute maitri;
  final GunaAttribute gan;
  final GunaAttribute bhakut;
  final GunaAttribute nadi;

  GunaDetails({
    required this.varna,
    required this.vashya,
    required this.tara,
    required this.yoni,
    required this.maitri,
    required this.gan,
    required this.bhakut,
    required this.nadi,
  });

  factory GunaDetails.fromJson(Map<String, dynamic> json) {
    return GunaDetails(
      varna: GunaAttribute.fromJson(json['varna']),
      vashya: GunaAttribute.fromJson(json['vashya']),
      tara: GunaAttribute.fromJson(json['tara']),
      yoni: GunaAttribute.fromJson(json['yoni']),
      maitri: GunaAttribute.fromJson(json['maitri']),
      gan: GunaAttribute.fromJson(json['gan']),
      bhakut: GunaAttribute.fromJson(json['bhakut']),
      nadi: GunaAttribute.fromJson(json['nadi']),
    );
  }
}

class GunaAttribute {
  final double points;
  final int max;
  final String description;
  final String maleAttribute;
  final String femaleAttribute;

  GunaAttribute({
    required this.points,
    required this.max,
    required this.description,
    required this.maleAttribute,
    required this.femaleAttribute,
  });

  factory GunaAttribute.fromJson(Map<String, dynamic> json) {
    return GunaAttribute(
      points: json['points'].toDouble(),
      max: json['max'],
      description: json['description'],
      maleAttribute: json['maleAttribute'],
      femaleAttribute: json['femaleAttribute'],
    );
  }
}

class DoshaAnalysis {
  final Manglik manglik;
  final Dosha nadi;
  final Dosha bhakut;
  final Dosha rajju;
  final Dosha vedha;

  DoshaAnalysis({
    required this.manglik,
    required this.nadi,
    required this.bhakut,
    required this.rajju,
    required this.vedha,
  });

  factory DoshaAnalysis.fromJson(Map<String, dynamic> json) {
    return DoshaAnalysis(
      manglik: Manglik.fromJson(json['manglik']),
      nadi: Dosha.fromJson(json['nadi']),
      bhakut: Dosha.fromJson(json['bhakut']),
      rajju: Dosha.fromJson(json['rajju']),
      vedha: Dosha.fromJson(json['vedha']),
    );
  }
}

class Manglik {
  final double malePercentage;
  final double femalePercentage;
  final String compatibility;

  Manglik({
    required this.malePercentage,
    required this.femalePercentage,
    required this.compatibility,
  });

  factory Manglik.fromJson(Map<String, dynamic> json) {
    return Manglik(
      malePercentage: json['malePercentage'].toDouble(),
      femalePercentage: json['femalePercentage'].toDouble(),
      compatibility: json['compatibility'],
    );
  }
}

class Dosha {
  final bool present;
  final String impact;
  final String remedy;

  Dosha({
    required this.present,
    required this.impact,
    required this.remedy,
  });

  factory Dosha.fromJson(Map<String, dynamic> json) {
    return Dosha(
      present: json['present'],
      impact: json['impact'],
      remedy: json['remedy'],
    );
  }
}

class Compatibility {
  final String mental;
  final String emotional;
  final String financial;
  final String physical;
  final String overall;

  Compatibility({
    required this.mental,
    required this.emotional,
    required this.financial,
    required this.physical,
    required this.overall,
  });

  factory Compatibility.fromJson(Map<String, dynamic> json) {
    return Compatibility(
      mental: json['mental'],
      emotional: json['emotional'],
      financial: json['financial'],
      physical: json['physical'],
      overall: json['overall'],
    );
  }
}
class Chart {
  final ChartDetail male;
  final ChartDetail female;

  Chart({
    required this.male,
    required this.female,
  });

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
      male: ChartDetail.fromJson(json['male']),
      female: ChartDetail.fromJson(json['female']),
    );
  }
}

class ChartDetail {
  final List<ChartD1> d1;
  final ChartImage d1Image;

  ChartDetail({
    required this.d1,
    required this.d1Image,
  });

  factory ChartDetail.fromJson(Map<String, dynamic> json) {
    return ChartDetail(
      d1: List<ChartD1>.from(json['d1'].map((x) => ChartD1.fromJson(x))),
      d1Image: ChartImage.fromJson(json['d1Image']),
    );
  }
}

class ChartD1 {
  final int sign;
  final String signName;
  final List<String> planet;
  final List<String> planetSmall;
  final List<dynamic> planetDegree;

  ChartD1({
    required this.sign,
    required this.signName,
    required this.planet,
    required this.planetSmall,
    required this.planetDegree,
  });

  factory ChartD1.fromJson(Map<String, dynamic> json) {
    return ChartD1(
      sign: json['sign'],
      signName: json['sign_name'],
      planet: List<String>.from(json['planet']),
      planetSmall: List<String>.from(json['planet_small']),
      planetDegree: List<dynamic>.from(json['planet_degree']),
    );
  }
}

class ChartImage {
  final String svg;

  ChartImage({required this.svg});

  factory ChartImage.fromJson(Map<String, dynamic> json) {
    return ChartImage(svg: json['svg']);
  }
}
