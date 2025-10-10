import 'dart:convert';

class KundliModel {
  bool status;
  String message;
  Data data;

  KundliModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KundliModel.fromJson(Map<String, dynamic> json) {
    return KundliModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  BasicDetails basicDetails;
  AstroDetails astroDetails;
  List<PlanetaryPosition> planetaryPositions;
  Lalkitab lalkitab;
  // Varshaphal varshaphal;
  KpSystem kpSystem;
  Panchang panchang;
  Ashtakvarga ashtakvarga;
  Dosha dosha;
  DataRemedies remedies;
  Suggestions suggestions;
  Numero numero;
  DataNakshatra nakshatra;
  Dasha dasha;
  Reports reports;
  Charts charts;
  GhatChakra ghatChakra;

  Data({
    required this.basicDetails,
    required this.astroDetails,
    required this.planetaryPositions,
    required this.lalkitab,
    // required this.varshaphal,
    required this.kpSystem,
    required this.panchang,
    required this.ashtakvarga,
    required this.dosha,
    required this.remedies,
    required this.suggestions,
    required this.numero,
    required this.nakshatra,
    required this.dasha,
    required this.reports,
    required this.charts,
    required this.ghatChakra,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      basicDetails: BasicDetails.fromJson(json['basicDetails'] as Map<String, dynamic>),
      astroDetails: AstroDetails.fromJson(json['astroDetails'] as Map<String, dynamic>),
      planetaryPositions: (json['planetaryPositions'] as List<dynamic>? ?? [])
          .map((e) => PlanetaryPosition.fromJson(e as Map<String, dynamic>))
          .toList(),
      lalkitab: Lalkitab.fromJson(json['lalkitab'] as Map<String, dynamic>),
      // varshaphal: Varshaphal.fromJson(json['varshaphal'] as Map<String, dynamic>),
      kpSystem: KpSystem.fromJson(json['kpSystem'] as Map<String, dynamic>),
      panchang: Panchang.fromJson(json['panchang'] as Map<String, dynamic>),
      ashtakvarga: Ashtakvarga.fromJson(json['ashtakvarga'] as Map<String, dynamic>),
      dosha: Dosha.fromJson(json['dosha'] as Map<String, dynamic>),
      remedies: DataRemedies.fromJson(json['remedies'] as Map<String, dynamic>),
      suggestions: Suggestions.fromJson(json['suggestions'] as Map<String, dynamic>),
      numero: Numero.fromJson(json['numero'] as Map<String, dynamic>),
      nakshatra: DataNakshatra.fromJson(json['nakshatra'] as Map<String, dynamic>),
      dasha: Dasha.fromJson(json['dasha'] as Map<String, dynamic>),
      reports: Reports.fromJson(json['reports'] as Map<String, dynamic>),
      charts: Charts.fromJson(json['charts'] as Map<String, dynamic>),
      ghatChakra: GhatChakra.fromJson(json['ghatChakra'] as Map<String, dynamic>),
    );
  }
}

class Ashtakvarga {
  PlanetAshtak planetAshtak;
  Sarvashtak sarvashtak;

  Ashtakvarga({
    required this.planetAshtak,
    required this.sarvashtak,
  });

  factory Ashtakvarga.fromJson(Map<String, dynamic> json) {
    return Ashtakvarga(
      planetAshtak: PlanetAshtak.fromJson(json['planetAshtak'] as Map<String, dynamic>),
      sarvashtak: Sarvashtak.fromJson(json['sarvashtak'] as Map<String, dynamic>),
    );
  }
}

class PlanetAshtak {
  Sarvashtak sun;
  Sarvashtak moon;
  Sarvashtak mars;
  Sarvashtak mercury;
  Sarvashtak jupiter;
  Sarvashtak venus;
  Sarvashtak saturn;

  PlanetAshtak({
    required this.sun,
    required this.moon,
    required this.mars,
    required this.mercury,
    required this.jupiter,
    required this.venus,
    required this.saturn,
  });

  factory PlanetAshtak.fromJson(Map<String, dynamic> json) {
    return PlanetAshtak(
      sun: Sarvashtak.fromJson(json['sun'] as Map<String, dynamic>),
      moon: Sarvashtak.fromJson(json['moon'] as Map<String, dynamic>),
      mars: Sarvashtak.fromJson(json['mars'] as Map<String, dynamic>),
      mercury: Sarvashtak.fromJson(json['mercury'] as Map<String, dynamic>),
      jupiter: Sarvashtak.fromJson(json['jupiter'] as Map<String, dynamic>),
      venus: Sarvashtak.fromJson(json['venus'] as Map<String, dynamic>),
      saturn: Sarvashtak.fromJson(json['saturn'] as Map<String, dynamic>),
    );
  }
}

class Sarvashtak {
  AshtakVarga ashtakVarga;
  Map<String, AshtakPoint> ashtakPoints;

  Sarvashtak({
    required this.ashtakVarga,
    required this.ashtakPoints,
  });

  factory Sarvashtak.fromJson(Map<String, dynamic> json) {
    return Sarvashtak(
      ashtakVarga: AshtakVarga.fromJson(json['ashtakVarga'] as Map<String, dynamic>),
      ashtakPoints: (json['ashtakPoints'] as Map<String, dynamic>? ?? {}).map(
            (key, value) => MapEntry(key, AshtakPoint.fromJson(value as Map<String, dynamic>)),
      ),
    );
  }
}

class AshtakPoint {
  int sun;
  int moon;
  int mars;
  int mercury;
  int jupiter;
  int venus;
  int saturn;
  int ascendant;
  int total;

  AshtakPoint({
    required this.sun,
    required this.moon,
    required this.mars,
    required this.mercury,
    required this.jupiter,
    required this.venus,
    required this.saturn,
    required this.ascendant,
    required this.total,
  });

  factory AshtakPoint.fromJson(Map<String, dynamic> json) {
    return AshtakPoint(
      sun: json['sun'] as int? ?? 0,
      moon: json['moon'] as int? ?? 0,
      mars: json['mars'] as int? ?? 0,
      mercury: json['mercury'] as int? ?? 0,
      jupiter: json['jupiter'] as int? ?? 0,
      venus: json['venus'] as int? ?? 0,
      saturn: json['saturn'] as int? ?? 0,
      ascendant: json['ascendant'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class AshtakVarga {
  String type;
  String? planet;
  AscendantEnum sign;
  int signId;

  AshtakVarga({
    required this.type,
    this.planet,
    required this.sign,
    required this.signId,
  });

  factory AshtakVarga.fromJson(Map<String, dynamic> json) {
    return AshtakVarga(
      type: json['type'] as String? ?? '',
      planet: json['planet'] as String?,
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signId: json['signId'] as int? ?? 0,
    );
  }
}

enum AscendantEnum {
  AQUARIUS,
  ARIES,
  CANCER,
  CAPRICORN,
  GEMINI,
  LEO,
  LIBRA,
  PISCES,
  SAGITTARIUS,
  SCORPIO,
  TAURUS,
  VIRGO
}

class AstroDetails {
  AscendantEnum ascendant;
  String ascendantLord;
  String varna;
  String vashya;
  String yoni;
  String gan;
  String nadi;
  String signLord;
  AscendantEnum sign;
  String naksahtra;
  String naksahtraLord;
  int charan;
  String yog;
  String karan;
  String tithi;
  String yunja;
  String tatva;
  String nameAlphabet;
  String paya;

  AstroDetails({
    required this.ascendant,
    required this.ascendantLord,
    required this.varna,
    required this.vashya,
    required this.yoni,
    required this.gan,
    required this.nadi,
    required this.signLord,
    required this.sign,
    required this.naksahtra,
    required this.naksahtraLord,
    required this.charan,
    required this.yog,
    required this.karan,
    required this.tithi,
    required this.yunja,
    required this.tatva,
    required this.nameAlphabet,
    required this.paya,
  });

  factory AstroDetails.fromJson(Map<String, dynamic> json) {
    return AstroDetails(
      ascendant: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['ascendant'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      ascendantLord: json['ascendantLord'] as String? ?? '',
      varna: json['varna'] as String? ?? '',
      vashya: json['vashya'] as String? ?? '',
      yoni: json['yoni'] as String? ?? '',
      gan: json['gan'] as String? ?? '',
      nadi: json['nadi'] as String? ?? '',
      signLord: json['signLord'] as String? ?? '',
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      naksahtra: json['naksahtra'] as String? ?? '',
      naksahtraLord: json['naksahtraLord'] as String? ?? '',
      charan: json['charan'] as int? ?? 0,
      yog: json['yog'] as String? ?? '',
      karan: json['karan'] as String? ?? '',
      tithi: json['tithi'] as String? ?? '',
      yunja: json['yunja'] as String? ?? '',
      tatva: json['tatva'] as String? ?? '',
      nameAlphabet: json['nameAlphabet'] as String? ?? '',
      paya: json['paya'] as String? ?? '',
    );
  }
}

class BasicDetails {
  String name;
  DateTime dob;
  String tob;
  String place;
  double latitude;
  double longitude;
  double timezone;
  String gender;
  AscendantEnum ascendant;
  AscendantEnum moonSign;
  AscendantEnum sunSign;
  String sunrise;
  String sunset;
  String ayanamsha;

  BasicDetails({
    required this.name,
    required this.dob,
    required this.tob,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.gender,
    required this.ascendant,
    required this.moonSign,
    required this.sunSign,
    required this.sunrise,
    required this.sunset,
    required this.ayanamsha,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      name: json['name'] as String? ?? '',
      dob: DateTime.parse(json['dob'] as String? ?? '1970-01-01T00:00:00Z'),
      tob: json['tob'] as String? ?? '',
      place: json['place'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: (json['timezone'] as num?)?.toDouble() ?? 0.0,
      gender: json['gender'] as String? ?? '',
      ascendant: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['ascendant'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      moonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['moonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      sunSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sunSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      sunrise: json['sunrise'] as String? ?? '',
      sunset: json['sunset'] as String? ?? '',
      ayanamsha: json['ayanamsha'] as String? ?? '',
    );
  }
}

class Charts {
  List<Chalit> chalit;
  String imageChalit;
  String chalitImage;
  List<Chalit> sun;
  D10Image imageSun;
  D10Image sunImage;
  List<Chalit> moon;
  D10Image imageMoon;
  D10Image moonImage;
  List<Chalit> d1;
  D10Image imageD1;
  D10Image d1Image;
  List<Chalit> d2;
  D10Image imageD2;
  D10Image d2Image;
  List<Chalit> d3;
  D10Image imageD3;
  D10Image d3Image;
  List<Chalit> d4;
  D10Image imageD4;
  D10Image d4Image;
  List<Chalit> d5;
  D10Image imageD5;
  D10Image d5Image;
  List<Chalit> d7;
  D10Image imageD7;
  D10Image d7Image;
  List<Chalit> d8;
  D10Image imageD8;
  D10Image d8Image;
  List<Chalit> d9;
  D10Image imageD9;
  D10Image d9Image;
  List<Chalit> d10;
  D10Image imageD10;
  D10Image d10Image;
  List<Chalit> d12;
  D10Image imageD12;
  D10Image d12Image;
  List<Chalit> d16;
  D10Image imageD16;
  D10Image d16Image;
  List<Chalit> d20;
  D10Image imageD20;
  D10Image d20Image;
  List<Chalit> d24;
  D10Image imageD24;
  D10Image d24Image;
  List<Chalit> d27;
  D10Image imageD27;
  D10Image d27Image;
  List<Chalit> d30;
  D10Image imageD30;
  D10Image d30Image;
  List<Chalit> d40;
  D10Image imageD40;
  D10Image d40Image;
  List<Chalit> d45;
  D10Image imageD45;
  D10Image d45Image;
  List<Chalit> d60;
  D10Image imageD60;
  D10Image d60Image;

  Charts({
    required this.chalit,
    required this.imageChalit,
    required this.chalitImage,
    required this.sun,
    required this.imageSun,
    required this.sunImage,
    required this.moon,
    required this.imageMoon,
    required this.moonImage,
    required this.d1,
    required this.imageD1,
    required this.d1Image,
    required this.d2,
    required this.imageD2,
    required this.d2Image,
    required this.d3,
    required this.imageD3,
    required this.d3Image,
    required this.d4,
    required this.imageD4,
    required this.d4Image,
    required this.d5,
    required this.imageD5,
    required this.d5Image,
    required this.d7,
    required this.imageD7,
    required this.d7Image,
    required this.d8,
    required this.imageD8,
    required this.d8Image,
    required this.d9,
    required this.imageD9,
    required this.d9Image,
    required this.d10,
    required this.imageD10,
    required this.d10Image,
    required this.d12,
    required this.imageD12,
    required this.d12Image,
    required this.d16,
    required this.imageD16,
    required this.d16Image,
    required this.d20,
    required this.imageD20,
    required this.d20Image,
    required this.d24,
    required this.imageD24,
    required this.d24Image,
    required this.d27,
    required this.imageD27,
    required this.d27Image,
    required this.d30,
    required this.imageD30,
    required this.d30Image,
    required this.d40,
    required this.imageD40,
    required this.d40Image,
    required this.d45,
    required this.imageD45,
    required this.d45Image,
    required this.d60,
    required this.imageD60,
    required this.d60Image,
  });

  factory Charts.fromJson(Map<String, dynamic> json) {
    return Charts(
      chalit: (json['chalit'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageChalit: json['imageChalit'] as String? ?? '',
      chalitImage: json['chalitImage'] as String? ?? '',
      sun: (json['sun'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageSun: D10Image.fromJson(json['imageSun'] as Map<String, dynamic>),
      sunImage: D10Image.fromJson(json['sunImage'] as Map<String, dynamic>),
      moon: (json['moon'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageMoon: D10Image.fromJson(json['imageMoon'] as Map<String, dynamic>),
      moonImage: D10Image.fromJson(json['moonImage'] as Map<String, dynamic>),
      d1: (json['d1'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD1: D10Image.fromJson(json['imageD1'] as Map<String, dynamic>),
      d1Image: D10Image.fromJson(json['d1Image'] as Map<String, dynamic>),
      d2: (json['d2'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD2: D10Image.fromJson(json['imageD2'] as Map<String, dynamic>),
      d2Image: D10Image.fromJson(json['d2Image'] as Map<String, dynamic>),
      d3: (json['d3'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD3: D10Image.fromJson(json['imageD3'] as Map<String, dynamic>),
      d3Image: D10Image.fromJson(json['d3Image'] as Map<String, dynamic>),
      d4: (json['d4'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD4: D10Image.fromJson(json['imageD4'] as Map<String, dynamic>),
      d4Image: D10Image.fromJson(json['d4Image'] as Map<String, dynamic>),
      d5: (json['d5'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD5: D10Image.fromJson(json['imageD5'] as Map<String, dynamic>),
      d5Image: D10Image.fromJson(json['d5Image'] as Map<String, dynamic>),
      d7: (json['d7'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD7: D10Image.fromJson(json['imageD7'] as Map<String, dynamic>),
      d7Image: D10Image.fromJson(json['d7Image'] as Map<String, dynamic>),
      d8: (json['d8'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD8: D10Image.fromJson(json['imageD8'] as Map<String, dynamic>),
      d8Image: D10Image.fromJson(json['d8Image'] as Map<String, dynamic>),
      d9: (json['d9'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD9: D10Image.fromJson(json['imageD9'] as Map<String, dynamic>),
      d9Image: D10Image.fromJson(json['d9Image'] as Map<String, dynamic>),
      d10: (json['d10'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD10: D10Image.fromJson(json['imageD10'] as Map<String, dynamic>),
      d10Image: D10Image.fromJson(json['d10Image'] as Map<String, dynamic>),
      d12: (json['d12'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD12: D10Image.fromJson(json['imageD12'] as Map<String, dynamic>),
      d12Image: D10Image.fromJson(json['d12Image'] as Map<String, dynamic>),
      d16: (json['d16'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD16: D10Image.fromJson(json['imageD16'] as Map<String, dynamic>),
      d16Image: D10Image.fromJson(json['d16Image'] as Map<String, dynamic>),
      d20: (json['d20'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD20: D10Image.fromJson(json['imageD20'] as Map<String, dynamic>),
      d20Image: D10Image.fromJson(json['d20Image'] as Map<String, dynamic>),
      d24: (json['d24'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD24: D10Image.fromJson(json['imageD24'] as Map<String, dynamic>),
      d24Image: D10Image.fromJson(json['d24Image'] as Map<String, dynamic>),
      d27: (json['d27'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD27: D10Image.fromJson(json['imageD27'] as Map<String, dynamic>),
      d27Image: D10Image.fromJson(json['d27Image'] as Map<String, dynamic>),
      d30: (json['d30'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD30: D10Image.fromJson(json['imageD30'] as Map<String, dynamic>),
      d30Image: D10Image.fromJson(json['d30Image'] as Map<String, dynamic>),
      d40: (json['d40'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD40: D10Image.fromJson(json['imageD40'] as Map<String, dynamic>),
      d40Image: D10Image.fromJson(json['d40Image'] as Map<String, dynamic>),
      d45: (json['d45'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD45: D10Image.fromJson(json['imageD45'] as Map<String, dynamic>),
      d45Image: D10Image.fromJson(json['d45Image'] as Map<String, dynamic>),
      d60: (json['d60'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      imageD60: D10Image.fromJson(json['imageD60'] as Map<String, dynamic>),
      d60Image: D10Image.fromJson(json['d60Image'] as Map<String, dynamic>),
    );
  }
}

class Chalit {
  int sign;
  AscendantEnum signName;
  List<VarshaphalaYearLord> planet;
  List<PlanetSmall> planetSmall;
  List<dynamic> planetDegree;

  Chalit({
    required this.sign,
    required this.signName,
    required this.planet,
    required this.planetSmall,
    required this.planetDegree,
  });

  factory Chalit.fromJson(Map<String, dynamic> json) {
    return Chalit(
      sign: json['sign'] as int? ?? 0,
      signName: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['signName'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      planet: (json['planet'] as List<dynamic>? ?? [])
          .map((e) => VarshaphalaYearLord.values.firstWhere(
            (v) => v.toString().split('.').last == (e as String? ?? 'SUN'),
        orElse: () => VarshaphalaYearLord.SUN,
      ))
          .toList(),
      planetSmall: (json['planetSmall'] as List<dynamic>? ?? [])
          .map((e) => PlanetSmall.values.firstWhere(
            (v) => v.toString().split('.').last == (e as String? ?? 'SU'),
        orElse: () => PlanetSmall.SU,
      ))
          .toList(),
      planetDegree: json['planetDegree'] as List<dynamic>? ?? [],
    );
  }
}

enum VarshaphalaYearLord {
  JUPITER,
  KETU,
  MARS,
  MERCURY,
  MOON,
  RAHU,
  SATURN,
  SUN,
  VENUS
}

enum PlanetSmall {
  JU,
  KE,
  MA,
  ME,
  MO,
  RA,
  SA,
  SU,
  VE
}

class D10Image {
  String svg;

  D10Image({
    required this.svg,
  });

  factory D10Image.fromJson(Map<String, dynamic> json) {
    return D10Image(
      svg: json['svg'] as String? ?? '',
    );
  }
}

class Dasha {
  Vimshottari vimshottari;
  Char charDasha;
  Yogini yogini;

  Dasha({
    required this.vimshottari,
    required this.charDasha,
    required this.yogini,
  });

  factory Dasha.fromJson(Map<String, dynamic> json) {
    return Dasha(
      vimshottari: Vimshottari.fromJson(json['vimshottari'] as Map<String, dynamic>),
      charDasha: Char.fromJson(json['char'] as Map<String, dynamic>),
      yogini: Yogini.fromJson(json['yogini'] as Map<String, dynamic>),
    );
  }
}

class Char {
  CharCurrent current;

  Char({
    required this.current,
  });

  factory Char.fromJson(Map<String, dynamic> json) {
    return Char(
      current: CharCurrent.fromJson(json['current'] as Map<String, dynamic>),
    );
  }
}

class CharCurrent {
  String dashaDate;
  PurpleDasha majorDasha;
  PurpleDasha subDasha;
  PurpleDasha subSubDasha;

  CharCurrent({
    required this.dashaDate,
    required this.majorDasha,
    required this.subDasha,
    required this.subSubDasha,
  });

  factory CharCurrent.fromJson(Map<String, dynamic> json) {
    return CharCurrent(
      dashaDate: json['dashaDate'] as String? ?? '',
      majorDasha: PurpleDasha.fromJson(json['majorDasha'] as Map<String, dynamic>),
      subDasha: PurpleDasha.fromJson(json['subDasha'] as Map<String, dynamic>),
      subSubDasha: PurpleDasha.fromJson(json['subSubDasha'] as Map<String, dynamic>),
    );
  }
}

class PurpleDasha {
  int signId;
  AscendantEnum signName;
  String? duration;
  String startDate;
  String endDate;

  PurpleDasha({
    required this.signId,
    required this.signName,
    this.duration,
    required this.startDate,
    required this.endDate,
  });

  factory PurpleDasha.fromJson(Map<String, dynamic> json) {
    return PurpleDasha(
      signId: json['signId'] as int? ?? 0,
      signName: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['signName'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      duration: json['duration'] as String?,
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}

class Vimshottari {
  VimshottariCurrent current;

  Vimshottari({
    required this.current,
  });

  factory Vimshottari.fromJson(Map<String, dynamic> json) {
    return Vimshottari(
      current: VimshottariCurrent.fromJson(json['current'] as Map<String, dynamic>),
    );
  }
}

class VimshottariCurrent {
  Major major;
  Major minor;
  Major subMinor;
  Major subSubMinor;
  Major subSubSubMinor;

  VimshottariCurrent({
    required this.major,
    required this.minor,
    required this.subMinor,
    required this.subSubMinor,
    required this.subSubSubMinor,
  });

  factory VimshottariCurrent.fromJson(Map<String, dynamic> json) {
    return VimshottariCurrent(
      major: Major.fromJson(json['major'] as Map<String, dynamic>),
      minor: Major.fromJson(json['minor'] as Map<String, dynamic>),
      subMinor: Major.fromJson(json['subMinor'] as Map<String, dynamic>),
      subSubMinor: Major.fromJson(json['subSubMinor'] as Map<String, dynamic>),
      subSubSubMinor: Major.fromJson(json['subSubSubMinor'] as Map<String, dynamic>),
    );
  }
}

class Major {
  String planet;
  int planetId;
  String start;
  String end;

  Major({
    required this.planet,
    required this.planetId,
    required this.start,
    required this.end,
  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      planet: json['planet'] as String? ?? '',
      planetId: json['planetId'] as int? ?? 0,
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

class Yogini {
  YoginiCurrent current;

  Yogini({
    required this.current,
  });

  factory Yogini.fromJson(Map<String, dynamic> json) {
    return Yogini(
      current: YoginiCurrent.fromJson(json['current'] as Map<String, dynamic>),
    );
  }
}

class YoginiCurrent {
  FluffyDasha majorDasha;
  FluffyDasha subDasha;
  FluffyDasha subSubDasha;

  YoginiCurrent({
    required this.majorDasha,
    required this.subDasha,
    required this.subSubDasha,
  });

  factory YoginiCurrent.fromJson(Map<String, dynamic> json) {
    return YoginiCurrent(
      majorDasha: FluffyDasha.fromJson(json['majorDasha'] as Map<String, dynamic>),
      subDasha: FluffyDasha.fromJson(json['subDasha'] as Map<String, dynamic>),
      subSubDasha: FluffyDasha.fromJson(json['subSubDasha'] as Map<String, dynamic>),
    );
  }
}

class FluffyDasha {
  int dashaId;
  String dashaName;
  String? duration;
  String startDate;
  String endDate;

  FluffyDasha({
    required this.dashaId,
    required this.dashaName,
    this.duration,
    required this.startDate,
    required this.endDate,
  });

  factory FluffyDasha.fromJson(Map<String, dynamic> json) {
    return FluffyDasha(
      dashaId: json['dashaId'] as int? ?? 0,
      dashaName: json['dashaName'] as String? ?? '',
      duration: json['duration'] as String?,
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
    );
  }
}

class Dosha {
  Kalsarpa kalsarpa;
  Manglik manglik;
  Sadhesati sadhesati;
  PitraDosha pitraDosha;

  Dosha({
    required this.kalsarpa,
    required this.manglik,
    required this.sadhesati,
    required this.pitraDosha,
  });

  factory Dosha.fromJson(Map<String, dynamic> json) {
    return Dosha(
      kalsarpa: Kalsarpa.fromJson(json['kalsarpa'] as Map<String, dynamic>),
      manglik: Manglik.fromJson(json['manglik'] as Map<String, dynamic>),
      sadhesati: Sadhesati.fromJson(json['sadhesati'] as Map<String, dynamic>),
      pitraDosha: PitraDosha.fromJson(json['pitraDosha'] as Map<String, dynamic>),
    );
  }
}

class Kalsarpa {
  bool present;
  String type;
  String oneLine;
  String name;
  KalsarpaReport report;

  Kalsarpa({
    required this.present,
    required this.type,
    required this.oneLine,
    required this.name,
    required this.report,
  });

  factory Kalsarpa.fromJson(Map<String, dynamic> json) {
    return Kalsarpa(
      present: json['present'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      oneLine: json['oneLine'] as String? ?? '',
      name: json['name'] as String? ?? '',
      report: KalsarpaReport.fromJson(json['report'] as Map<String, dynamic>),
    );
  }
}

class KalsarpaReport {
  int houseId;
  String report;

  KalsarpaReport({
    required this.houseId,
    required this.report,
  });

  factory KalsarpaReport.fromJson(Map<String, dynamic> json) {
    return KalsarpaReport(
      houseId: json['houseId'] as int? ?? 0,
      report: json['report'] as String? ?? '',
    );
  }
}

class Manglik {
  ManglikPresentRule manglikPresentRule;
  List<String> manglikCancelRule;
  bool isMarsManglikCancelled;
  String manglikStatus;
  int percentageManglikPresent;
  int percentageManglikAfterCancellation;
  String manglikReport;
  bool isPresent;

  Manglik({
    required this.manglikPresentRule,
    required this.manglikCancelRule,
    required this.isMarsManglikCancelled,
    required this.manglikStatus,
    required this.percentageManglikPresent,
    required this.percentageManglikAfterCancellation,
    required this.manglikReport,
    required this.isPresent,
  });

  factory Manglik.fromJson(Map<String, dynamic> json) {
    return Manglik(
      manglikPresentRule: ManglikPresentRule.fromJson(json['manglikPresentRule'] as Map<String, dynamic>),
      manglikCancelRule: (json['manglikCancelRule'] as List<dynamic>? ?? []).cast<String>(),
      isMarsManglikCancelled: json['isMarsManglikCancelled'] as bool? ?? false,
      manglikStatus: json['manglikStatus'] as String? ?? '',
      percentageManglikPresent: json['percentageManglikPresent'] as int? ?? 0,
      percentageManglikAfterCancellation: json['percentageManglikAfterCancellation'] as int? ?? 0,
      manglikReport: json['manglikReport'] as String? ?? '',
      isPresent: json['isPresent'] as bool? ?? false,
    );
  }
}

class ManglikPresentRule {
  List<String> basedOnAspect;
  List<String> basedOnHouse;

  ManglikPresentRule({
    required this.basedOnAspect,
    required this.basedOnHouse,
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) {
    return ManglikPresentRule(
      basedOnAspect: (json['basedOnAspect'] as List<dynamic>? ?? []).cast<String>(),
      basedOnHouse: (json['basedOnHouse'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

class PitraDosha {
  String whatIsPitriDosha;
  bool isPitriDoshaPresent;
  List<dynamic> rulesMatched;
  String conclusion;
  dynamic remedies;
  dynamic effects;

  PitraDosha({
    required this.whatIsPitriDosha,
    required this.isPitriDoshaPresent,
    required this.rulesMatched,
    required this.conclusion,
    required this.remedies,
    required this.effects,
  });

  factory PitraDosha.fromJson(Map<String, dynamic> json) {
    return PitraDosha(
      whatIsPitriDosha: json['whatIsPitriDosha'] as String? ?? '',
      isPitriDoshaPresent: json['isPitriDoshaPresent'] as bool? ?? false,
      rulesMatched: json['rulesMatched'] as List<dynamic>? ?? [],
      conclusion: json['conclusion'] as String? ?? '',
      remedies: json['remedies'],
      effects: json['effects'],
    );
  }
}

class Sadhesati {
  CurrentStatus currentStatus;
  List<LifeDetail> lifeDetails;

  Sadhesati({
    required this.currentStatus,
    required this.lifeDetails,
  });

  factory Sadhesati.fromJson(Map<String, dynamic> json) {
    return Sadhesati(
      currentStatus: CurrentStatus.fromJson(json['currentStatus'] as Map<String, dynamic>),
      lifeDetails: (json['lifeDetails'] as List<dynamic>? ?? [])
          .map((e) => LifeDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class CurrentStatus {
  String considerationDate;
  bool isSaturnRetrograde;
  AscendantEnum moonSign;
  AscendantEnum saturnSign;
  String isUndergoingSadhesati;
  bool sadhesatiStatus;
  String whatIsSadhesati;

  CurrentStatus({
    required this.considerationDate,
    required this.isSaturnRetrograde,
    required this.moonSign,
    required this.saturnSign,
    required this.isUndergoingSadhesati,
    required this.sadhesatiStatus,
    required this.whatIsSadhesati,
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) {
    return CurrentStatus(
      considerationDate: json['considerationDate'] as String? ?? '',
      isSaturnRetrograde: json['isSaturnRetrograde'] as bool? ?? false,
      moonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['moonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      saturnSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['saturnSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      isUndergoingSadhesati: json['isUndergoingSadhesati'] as String? ?? '',
      sadhesatiStatus: json['sadhesatiStatus'] as bool? ?? false,
      whatIsSadhesati: json['whatIsSadhesati'] as String? ?? '',
    );
  }
}

class LifeDetail {
  AscendantEnum moonSign;
  AscendantEnum saturnSign;
  bool isSaturnRetrograde;
  Type type;
  String millisecond;
  String date;
  String summary;

  LifeDetail({
    required this.moonSign,
    required this.saturnSign,
    required this.isSaturnRetrograde,
    required this.type,
    required this.millisecond,
    required this.date,
    required this.summary,
  });

  factory LifeDetail.fromJson(Map<String, dynamic> json) {
    return LifeDetail(
      moonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['moonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      saturnSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['saturnSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      isSaturnRetrograde: json['isSaturnRetrograde'] as bool? ?? false,
      type: Type.values.firstWhere(
            (e) => e.toString().split('.').last == (json['type'] as String? ?? 'PEAK_START'),
        orElse: () => Type.PEAK_START,
      ),
      millisecond: json['millisecond'] as String? ?? '',
      date: json['date'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }
}

enum Type {
  PEAK_START,
  RISING_END,
  RISING_START,
  SETTING_END,
  SETTING_START
}

class GhatChakra {
  String month;
  String tithi;
  String day;
  String nakshatra;
  String yog;
  String karan;
  String pahar;
  String moon;

  GhatChakra({
    required this.month,
    required this.tithi,
    required this.day,
    required this.nakshatra,
    required this.yog,
    required this.karan,
    required this.pahar,
    required this.moon,
  });

  factory GhatChakra.fromJson(Map<String, dynamic> json) {
    return GhatChakra(
      month: json['month'] as String? ?? '',
      tithi: json['tithi'] as String? ?? '',
      day: json['day'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      yog: json['yog'] as String? ?? '',
      karan: json['karan'] as String? ?? '',
      pahar: json['pahar'] as String? ?? '',
      moon: json['moon'] as String? ?? '',
    );
  }
}

class KpSystem {
  List<KpSystemPlanet> planets;
  List<HouseCusp> houseCusps;
  List<BirthChart> birthChart;
  List<HouseSignificator> houseSignificator;
  List<PlanetSignificator> planetSignificator;

  KpSystem({
    required this.planets,
    required this.houseCusps,
    required this.birthChart,
    required this.houseSignificator,
    required this.planetSignificator,
  });

  factory KpSystem.fromJson(Map<String, dynamic> json) {
    return KpSystem(
      planets: (json['planets'] as List<dynamic>? ?? [])
          .map((e) => KpSystemPlanet.fromJson(e as Map<String, dynamic>))
          .toList(),
      houseCusps: (json['houseCusps'] as List<dynamic>? ?? [])
          .map((e) => HouseCusp.fromJson(e as Map<String, dynamic>))
          .toList(),
      birthChart: (json['birthChart'] as List<dynamic>? ?? [])
          .map((e) => BirthChart.fromJson(e as Map<String, dynamic>))
          .toList(),
      houseSignificator: (json['houseSignificator'] as List<dynamic>? ?? [])
          .map((e) => HouseSignificator.fromJson(e as Map<String, dynamic>))
          .toList(),
      planetSignificator: (json['planetSignificator'] as List<dynamic>? ?? [])
          .map((e) => PlanetSignificator.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BirthChart {
  List<int> signs;
  List<String> planets;
  List<PlanetSmall> planetsSmall;
  List<int> planetSigns;

  BirthChart({
    required this.signs,
    required this.planets,
    required this.planetsSmall,
    required this.planetSigns,
  });

  factory BirthChart.fromJson(Map<String, dynamic> json) {
    return BirthChart(
      signs: (json['signs'] as List<dynamic>? ?? []).cast<int>(),
      planets: (json['planets'] as List<dynamic>? ?? []).cast<String>(),
      planetsSmall: (json['planetsSmall'] as List<dynamic>? ?? [])
          .map((e) => PlanetSmall.values.firstWhere(
            (v) => v.toString().split('.').last == (e as String? ?? 'SU'),
        orElse: () => PlanetSmall.SU,
      ))
          .toList(),
      planetSigns: (json['planetSigns'] as List<dynamic>? ?? []).cast<int>(),
    );
  }
}

class HouseCusp {
  int houseId;
  double cuspFullDegree;
  String formattedDegree;
  int signId;
  AscendantEnum sign;
  String signLord;
  String nakshatra;
  String nakshatraLord;
  String subLord;
  String subSubLord;

  HouseCusp({
    required this.houseId,
    required this.cuspFullDegree,
    required this.formattedDegree,
    required this.signId,
    required this.sign,
    required this.signLord,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.subLord,
    required this.subSubLord,
  });

  factory HouseCusp.fromJson(Map<String, dynamic> json) {
    return HouseCusp(
      houseId: json['houseId'] as int? ?? 0,
      cuspFullDegree: (json['cuspFullDegree'] as num?)?.toDouble() ?? 0.0,
      formattedDegree: json['formattedDegree'] as String? ?? '',
      signId: json['signId'] as int? ?? 0,
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signLord: json['signLord'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      nakshatraLord: json['nakshatraLord'] as String? ?? '',
      subLord: json['subLord'] as String? ?? '',
      subSubLord: json['subSubLord'] as String? ?? '',
    );
  }
}

class HouseSignificator {
  int houseId;
  List<String> significators;

  HouseSignificator({
    required this.houseId,
    required this.significators,
  });

  factory HouseSignificator.fromJson(Map<String, dynamic> json) {
    return HouseSignificator(
      houseId: json['houseId'] as int? ?? 0,
      significators: (json['significators'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

class PlanetSignificator {
  int planetId;
  String planetName;
  List<int> significators;

  PlanetSignificator({
    required this.planetId,
    required this.planetName,
    required this.significators,
  });

  factory PlanetSignificator.fromJson(Map<String, dynamic> json) {
    return PlanetSignificator(
      planetId: json['planetId'] as int? ?? 0,
      planetName: json['planetName'] as String? ?? '',
      significators: (json['significators'] as List<dynamic>? ?? []).cast<int>(),
    );
  }
}

class KpSystemPlanet {
  int planetId;
  String planetName;
  double degree;
  String formattedDegree;
  bool isRetro;
  double normDegree;
  String formattedNormDegree;
  int house;
  AscendantEnum sign;
  String signLord;
  String nakshatra;
  String nakshatraLord;
  int charan;
  String subLord;
  String subSubLord;

  KpSystemPlanet({
    required this.planetId,
    required this.planetName,
    required this.degree,
    required this.formattedDegree,
    required this.isRetro,
    required this.normDegree,
    required this.formattedNormDegree,
    required this.house,
    required this.sign,
    required this.signLord,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.charan,
    required this.subLord,
    required this.subSubLord,
  });

  factory KpSystemPlanet.fromJson(Map<String, dynamic> json) {
    return KpSystemPlanet(
      planetId: json['planetId'] as int? ?? 0,
      planetName: json['planetName'] as String? ?? '',
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      formattedDegree: json['formattedDegree'] as String? ?? '',
      isRetro: json['isRetro'] as bool? ?? false,
      normDegree: (json['normDegree'] as num?)?.toDouble() ?? 0.0,
      formattedNormDegree: json['formattedNormDegree'] as String? ?? '',
      house: json['house'] as int? ?? 0,
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signLord: json['signLord'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      nakshatraLord: json['nakshatraLord'] as String? ?? '',
      charan: json['charan'] as int? ?? 0,
      subLord: json['subLord'] as String? ?? '',
      subSubLord: json['subSubLord'] as String? ?? '',
    );
  }
}

class Lalkitab {
  List<Chalit> horoscope;
  List<Debt> debts;
  List<HouseElement> houses;
  List<LalkitabPlanet> planets;
  LalkitabClass remedies;

  Lalkitab({
    required this.horoscope,
    required this.debts,
    required this.houses,
    required this.planets,
    required this.remedies,
  });

  factory Lalkitab.fromJson(Map<String, dynamic> json) {
    return Lalkitab(
      horoscope: (json['horoscope'] as List<dynamic>? ?? [])
          .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
          .toList(),
      debts: (json['debts'] as List<dynamic>? ?? [])
          .map((e) => Debt.fromJson(e as Map<String, dynamic>))
          .toList(),
      houses: (json['houses'] as List<dynamic>? ?? [])
          .map((e) => HouseElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      planets: (json['planets'] as List<dynamic>? ?? [])
          .map((e) => LalkitabPlanet.fromJson(e as Map<String, dynamic>))
          .toList(),
      remedies: LalkitabClass.fromJson(json['remedies'] as Map<String, dynamic>),
    );
  }
}

class Debt {
  String debtName;
  String indications;
  String events;

  Debt({
    required this.debtName,
    required this.indications,
    required this.events,
  });

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      debtName: json['debtName'] as String? ?? '',
      indications: json['indications'] as String? ?? '',
      events: json['events'] as String? ?? '',
    );
  }
}

class HouseElement {
  int khanaNumber;
  String maalik;
  String pakkaGhar;
  String kismat;
  bool soya;
  dynamic exalt;
  dynamic debilitated;

  HouseElement({
    required this.khanaNumber,
    required this.maalik,
    required this.pakkaGhar,
    required this.kismat,
    required this.soya,
    required this.exalt,
    required this.debilitated,
  });

  factory HouseElement.fromJson(Map<String, dynamic> json) {
    return HouseElement(
      khanaNumber: json['khanaNumber'] as int? ?? 0,
      maalik: json['maalik'] as String? ?? '',
      pakkaGhar: json['pakkaGhar'] as String? ?? '',
      kismat: json['kismat'] as String? ?? '',
      soya: json['soya'] as bool? ?? false,
      exalt: json['exalt'],
      debilitated: json['debilitated'],
    );
  }
}

class LalkitabPlanet {
  String planet;
  AscendantEnum sign;
  bool isSignificator;
  String position;
  String nature;

  LalkitabPlanet({
    required this.planet,
    required this.sign,
    required this.isSignificator,
    required this.position,
    required this.nature,
  });

  factory LalkitabPlanet.fromJson(Map<String, dynamic> json) {
    return LalkitabPlanet(
      planet: json['planet'] as String? ?? '',
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      isSignificator: json['isSignificator'] as bool? ?? false,
      position: json['position'] as String? ?? '',
      nature: json['nature'] as String? ?? '',
    );
  }
}

class LalkitabClass {
  RemediesJupiter sun;
  RemediesJupiter moon;
  RemediesJupiter mars;
  RemediesJupiter mercury;
  RemediesJupiter jupiter;
  RemediesJupiter venus;
  RemediesJupiter saturn;

  LalkitabClass({
    required this.sun,
    required this.moon,
    required this.mars,
    required this.mercury,
    required this.jupiter,
    required this.venus,
    required this.saturn,
  });

  factory LalkitabClass.fromJson(Map<String, dynamic> json) {
    return LalkitabClass(
      sun: RemediesJupiter.fromJson(json['sun'] as Map<String, dynamic>),
      moon: RemediesJupiter.fromJson(json['moon'] as Map<String, dynamic>),
      mars: RemediesJupiter.fromJson(json['mars'] as Map<String, dynamic>),
      mercury: RemediesJupiter.fromJson(json['mercury'] as Map<String, dynamic>),
      jupiter: RemediesJupiter.fromJson(json['jupiter'] as Map<String, dynamic>),
      venus: RemediesJupiter.fromJson(json['venus'] as Map<String, dynamic>),
      saturn: RemediesJupiter.fromJson(json['saturn'] as Map<String, dynamic>),
    );
  }
}

class RemediesJupiter {
  String planet;
  HouseEnum house;
  String lalKitabDesc;
  List<String> lalKitabRemedies;

  RemediesJupiter({
    required this.planet,
    required this.house,
    required this.lalKitabDesc,
    required this.lalKitabRemedies,
  });

  factory RemediesJupiter.fromJson(Map<String, dynamic> json) {
    return RemediesJupiter(
      planet: json['planet'] as String? ?? '',
      house: HouseEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['house'] as String? ?? 'FIRST'),
        orElse: () => HouseEnum.FIRST,
      ),
      lalKitabDesc: json['lalKitabDesc'] as String? ?? '',
      lalKitabRemedies: (json['lalKitabRemedies'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

enum HouseEnum {
  ELEVENTH,
  FIRST,
  TENTH
}

class DataNakshatra {
  NakshatraDailyPrediction dailyPrediction;

  DataNakshatra({
    required this.dailyPrediction,
  });

  factory DataNakshatra.fromJson(Map<String, dynamic> json) {
    return DataNakshatra(
      dailyPrediction: NakshatraDailyPrediction.fromJson(json['dailyPrediction'] as Map<String, dynamic>),
    );
  }
}

class NakshatraDailyPrediction {
  AscendantEnum birthMoonSign;
  String birthMoonNakshatra;
  Prediction prediction;
  String predictionDate;

  NakshatraDailyPrediction({
    required this.birthMoonSign,
    required this.birthMoonNakshatra,
    required this.prediction,
    required this.predictionDate,
  });

  factory NakshatraDailyPrediction.fromJson(Map<String, dynamic> json) {
    return NakshatraDailyPrediction(
      birthMoonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['birthMoonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      birthMoonNakshatra: json['birthMoonNakshatra'] as String? ?? '',
      prediction: Prediction.fromJson(json['prediction'] as Map<String, dynamic>),
      predictionDate: json['predictionDate'] as String? ?? '',
    );
  }
}

class Prediction {
  String health;
  String emotions;
  String profession;
  String luck;
  String personalLife;
  String travel;

  Prediction({
    required this.health,
    required this.emotions,
    required this.profession,
    required this.luck,
    required this.personalLife,
    required this.travel,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      health: json['health'] as String? ?? '',
      emotions: json['emotions'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      luck: json['luck'] as String? ?? '',
      personalLife: json['personalLife'] as String? ?? '',
      travel: json['travel'] as String? ?? '',
    );
  }
}

class Numero {
  Table table;
  NumeroReport report;
  NumeroDailyPrediction dailyPrediction;

  Numero({
    required this.table,
    required this.report,
    required this.dailyPrediction,
  });

  factory Numero.fromJson(Map<String, dynamic> json) {
    return Numero(
      table: Table.fromJson(json['table'] as Map<String, dynamic>),
      report: NumeroReport.fromJson(json['report'] as Map<String, dynamic>),
      dailyPrediction: NumeroDailyPrediction.fromJson(json['dailyPrediction'] as Map<String, dynamic>),
    );
  }
}

class NumeroDailyPrediction {
  String prediction;
  String luckyColor;
  String luckyNumber;
  String predictionDate;

  NumeroDailyPrediction({
    required this.prediction,
    required this.luckyColor,
    required this.luckyNumber,
    required this.predictionDate,
  });

  factory NumeroDailyPrediction.fromJson(Map<String, dynamic> json) {
    return NumeroDailyPrediction(
      prediction: json['prediction'] as String? ?? '',
      luckyColor: json['luckyColor'] as String? ?? '',
      luckyNumber: json['luckyNumber'] as String? ?? '',
      predictionDate: json['predictionDate'] as String? ?? '',
    );
  }
}

class NumeroReport {
  String title;
  String description;

  NumeroReport({
    required this.title,
    required this.description,
  });

  factory NumeroReport.fromJson(Map<String, dynamic> json) {
    return NumeroReport(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class Table {
  String name;
  String date;
  int destinyNumber;
  int radicalNumber;
  int nameNumber;
  String evilNum;
  String favColor;
  String favDay;
  String favGod;
  String favMantra;
  String favMetal;
  String favStone;
  String favSubstone;
  String friendlyNum;
  String neutralNum;
  String radicalNum;
  String radicalRuler;

  Table({
    required this.name,
    required this.date,
    required this.destinyNumber,
    required this.radicalNumber,
    required this.nameNumber,
    required this.evilNum,
    required this.favColor,
    required this.favDay,
    required this.favGod,
    required this.favMantra,
    required this.favMetal,
    required this.favStone,
    required this.favSubstone,
    required this.friendlyNum,
    required this.neutralNum,
    required this.radicalNum,
    required this.radicalRuler,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      destinyNumber: json['destinyNumber'] as int? ?? 0,
      radicalNumber: json['radicalNumber'] as int? ?? 0,
      nameNumber: json['nameNumber'] as int? ?? 0,
      evilNum: json['evilNum'] as String? ?? '',
      favColor: json['favColor'] as String? ?? '',
      favDay: json['favDay'] as String? ?? '',
      favGod: json['favGod'] as String? ?? '',
      favMantra: json['favMantra'] as String? ?? '',
      favMetal: json['favMetal'] as String? ?? '',
      favStone: json['favStone'] as String? ?? '',
      favSubstone: json['favSubstone'] as String? ?? '',
      friendlyNum: json['friendlyNum'] as String? ?? '',
      neutralNum: json['neutralNum'] as String? ?? '',
      radicalNum: json['radicalNum'] as String? ?? '',
      radicalRuler: json['radicalRuler'] as String? ?? '',
    );
  }
}

class Panchang {
  Basic basic;
  Advanced advanced;
  HoraMuhurta horaMuhurta;
  PanchangChaughadiya chaughadiya;

  Panchang({
    required this.basic,
    required this.advanced,
    required this.horaMuhurta,
    required this.chaughadiya,
  });

  factory Panchang.fromJson(Map<String, dynamic> json) {
    return Panchang(
      basic: Basic.fromJson(json['basic'] as Map<String, dynamic>),
      advanced: Advanced.fromJson(json['advanced'] as Map<String, dynamic>),
      horaMuhurta: HoraMuhurta.fromJson(json['horaMuhurta'] as Map<String, dynamic>),
      chaughadiya: PanchangChaughadiya.fromJson(json['chaughadiya'] as Map<String, dynamic>),
    );
  }
}

class Advanced {
  String day;
  String sunrise;
  String sunset;
  String moonrise;
  String moonset;
  String vedicSunrise;
  String vedicSunset;
  // Tithi tithi;
  // AdvancedNakshatra nakshatra;
  Yog yog;
  Karan karan;
  HinduMaah hinduMaah;
  String paksha;
  String ritu;
  AscendantEnum sunSign;
  AscendantEnum moonSign;
  String ayana;
  String panchangYog;
  int vikramSamvat;
  int shakaSamvat;
  String vkramSamvatName;
  String shakaSamvatName;
  String dishaShool;
  String dishaShoolRemedies;
  NakShool nakShool;
  String moonNivas;
  AbhijitMuhurta abhijitMuhurta;
  AbhijitMuhurta rahukaal;
  AbhijitMuhurta guliKaal;
  AbhijitMuhurta yamghantKaal;

  Advanced({
    required this.day,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.vedicSunrise,
    required this.vedicSunset,
    // required this.tithi,
    // required this.nakshatra,
    required this.yog,
    required this.karan,
    required this.hinduMaah,
    required this.paksha,
    required this.ritu,
    required this.sunSign,
    required this.moonSign,
    required this.ayana,
    required this.panchangYog,
    required this.vikramSamvat,
    required this.shakaSamvat,
    required this.vkramSamvatName,
    required this.shakaSamvatName,
    required this.dishaShool,
    required this.dishaShoolRemedies,
    required this.nakShool,
    required this.moonNivas,
    required this.abhijitMuhurta,
    required this.rahukaal,
    required this.guliKaal,
    required this.yamghantKaal,
  });

  factory Advanced.fromJson(Map<String, dynamic> json) {
    return Advanced(
      day: json['day'] as String? ?? '',
      sunrise: json['sunrise'] as String? ?? '',
      sunset: json['sunset'] as String? ?? '',
      moonrise: json['moonrise'] as String? ?? '',
      moonset: json['moonset'] as String? ?? '',
      vedicSunrise: json['vedicSunrise'] as String? ?? '',
      vedicSunset: json['vedicSunset'] as String? ?? '',
      // tithi: Tithi.fromJson(json['tithi'] as Map<String, dynamic>),
      // nakshatra: AdvancedNakshatra.fromJson(json['nakshatra'] as Map<String, dynamic>),
      yog: Yog.fromJson(json['yog'] as Map<String, dynamic>),
      karan: Karan.fromJson(json['karan'] as Map<String, dynamic>),
      hinduMaah: HinduMaah.fromJson(json['hinduMaah'] as Map<String, dynamic>),
      paksha: json['paksha'] as String? ?? '',
      ritu: json['ritu'] as String? ?? '',
      sunSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sunSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      moonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['moonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      ayana: json['ayana'] as String? ?? '',
      panchangYog: json['panchangYog'] as String? ?? '',
      vikramSamvat: json['vikramSamvat'] as int? ?? 0,
      shakaSamvat: json['shakaSamvat'] as int? ?? 0,
      vkramSamvatName: json['vkramSamvatName'] as String? ?? '',
      shakaSamvatName: json['shakaSamvatName'] as String? ?? '',
      dishaShool: json['dishaShool'] as String? ?? '',
      dishaShoolRemedies: json['dishaShoolRemedies'] as String? ?? '',
      nakShool: NakShool.fromJson(json['nakShool'] as Map<String, dynamic>),
      moonNivas: json['moonNivas'] as String? ?? '',
      abhijitMuhurta: AbhijitMuhurta.fromJson(json['abhijitMuhurta'] as Map<String, dynamic>),
      rahukaal: AbhijitMuhurta.fromJson(json['rahukaal'] as Map<String, dynamic>),
      guliKaal: AbhijitMuhurta.fromJson(json['guliKaal'] as Map<String, dynamic>),
      yamghantKaal: AbhijitMuhurta.fromJson(json['yamghantKaal'] as Map<String, dynamic>),
    );
  }
}

class AbhijitMuhurta {
  String start;
  String end;

  AbhijitMuhurta({
    required this.start,
    required this.end,
  });

  factory AbhijitMuhurta.fromJson(Map<String, dynamic> json) {
    return AbhijitMuhurta(
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

class HinduMaah {
  bool adhikStatus;
  String purnimanta;
  String amanta;
  int amantaId;
  int purnimantaId;

  HinduMaah({
    required this.adhikStatus,
    required this.purnimanta,
    required this.amanta,
    required this.amantaId,
    required this.purnimantaId,
  });

  factory HinduMaah.fromJson(Map<String, dynamic> json) {
    return HinduMaah(
      adhikStatus: json['adhikStatus'] as bool? ?? false,
      purnimanta: json['purnimanta'] as String? ?? '',
      amanta: json['amanta'] as String? ?? '',
      amantaId: json['amantaId'] as int? ?? 0,
      purnimantaId: json['purnimantaId'] as int? ?? 0,
    );
  }
}

class Karan {
  KaranDetails details;
  EndTime endTime;
  int endTimeMs;

  Karan({
    required this.details,
    required this.endTime,
    required this.endTimeMs,
  });

  factory Karan.fromJson(Map<String, dynamic> json) {
    return Karan(
      details: KaranDetails.fromJson(json['details'] as Map<String, dynamic>),
      endTime: EndTime.fromJson(json['endTime'] as Map<String, dynamic>),
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class KaranDetails {
  int karanNumber;
  String karanName;
  String special;
  String deity;

  KaranDetails({
    required this.karanNumber,
    required this.karanName,
    required this.special,
    required this.deity,
  });

  factory KaranDetails.fromJson(Map<String, dynamic> json) {
    return KaranDetails(
      karanNumber: json['karanNumber'] as int? ?? 0,
      karanName: json['karanName'] as String? ?? '',
      special: json['special'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
    );
  }
}

class EndTime {
  int hour;
  int minute;
  int second;

  EndTime({
    required this.hour,
    required this.minute,
    required this.second,
  });

  factory EndTime.fromJson(Map<String, dynamic> json) {
    return EndTime(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
    );
  }
}

class NakShool {
  String direction;
  String remedies;

  NakShool({
    required this.direction,
    required this.remedies,
  });

  factory NakShool.fromJson(Map<String, dynamic> json) {
    return NakShool(
      direction: json['direction'] as String? ?? '',
      remedies: json['remedies'] as String? ?? '',
    );
  }
}

class AdvancedNakshatra {
  NakshatraDetails details;
  EndTime endTime;
  int endTimeMs;

  AdvancedNakshatra({
    required this.details,
    required this.endTime,
    required this.endTimeMs,
  });

  factory AdvancedNakshatra.fromJson(Map<String, dynamic> json) {
    return AdvancedNakshatra(
        details: NakshatraDetails.fromJson(json['details'] as Map<String, dynamic>),
      endTime: EndTime.fromJson(json['endTime'] as Map<String, dynamic>),
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class NakshatraDetails {
  int nakshatraNumber;
  String nakshatraName;
  String ruler;
  String deity;
  String symbol;
  String temperament;

  NakshatraDetails({
    required this.nakshatraNumber,
    required this.nakshatraName,
    required this.ruler,
    required this.deity,
    required this.symbol,
    required this.temperament,
  });

  factory NakshatraDetails.fromJson(Map<String, dynamic> json) {
    return NakshatraDetails(
      nakshatraNumber: json['nakshatraNumber'] as int? ?? 0,
      nakshatraName: json['nakshatraName'] as String? ?? '',
      ruler: json['ruler'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      temperament: json['temperament'] as String? ?? '',
    );
  }
}

class Tithi {
  TithiDetails details;
  EndTime endTime;
  int endTimeMs;

  Tithi({
    required this.details,
    required this.endTime,
    required this.endTimeMs,
  });

  factory Tithi.fromJson(Map<String, dynamic> json) {
    return Tithi(
      details: TithiDetails.fromJson(json['details'] as Map<String, dynamic>),
      endTime: EndTime.fromJson(json['endTime'] as Map<String, dynamic>),
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class TithiDetails {
  int tithiNumber;
  String tithiName;
  String special;
  String deity;

  TithiDetails({
    required this.tithiNumber,
    required this.tithiName,
    required this.special,
    required this.deity,
  });

  factory TithiDetails.fromJson(Map<String, dynamic> json) {
    return TithiDetails(
      tithiNumber: json['tithiNumber'] as int? ?? 0,
      tithiName: json['tithiName'] as String? ?? '',
      special: json['special'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
    );
  }
}

class Yog {
  YogDetails details;
  EndTime endTime;
  int endTimeMs;

  Yog({
    required this.details,
    required this.endTime,
    required this.endTimeMs,
  });

  factory Yog.fromJson(Map<String, dynamic> json) {
    return Yog(
      details: YogDetails.fromJson(json['details'] as Map<String, dynamic>),
      endTime: EndTime.fromJson(json['endTime'] as Map<String, dynamic>),
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class YogDetails {
  int yogNumber;
  String yogName;
  String special;
  String meaning;

  YogDetails({
    required this.yogNumber,
    required this.yogName,
    required this.special,
    required this.meaning,
  });

  factory YogDetails.fromJson(Map<String, dynamic> json) {
    return YogDetails(
      yogNumber: json['yogNumber'] as int? ?? 0,
      yogName: json['yogName'] as String? ?? '',
      special: json['special'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
    );
  }
}

class Basic {
  String date;
  String day;
  String sunrise;
  String sunset;
  AscendantEnum sunSign;
  AscendantEnum moonSign;
  String tithi;
  String nakshatra;
  String yog;
  String karan;

  Basic({
    required this.date,
    required this.day,
    required this.sunrise,
    required this.sunset,
    required this.sunSign,
    required this.moonSign,
    required this.tithi,
    required this.nakshatra,
    required this.yog,
    required this.karan,
  });

  factory Basic.fromJson(Map<String, dynamic> json) {
    return Basic(
      date: json['date'] as String? ?? '',
      day: json['day'] as String? ?? '',
      sunrise: json['sunrise'] as String? ?? '',
      sunset: json['sunset'] as String? ?? '',
      sunSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sunSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      moonSign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['moonSign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      tithi: json['tithi'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      yog: json['yog'] as String? ?? '',
      karan: json['karan'] as String? ?? '',
    );
  }
}

class HoraMuhurta {
  List<Hora> dayHora;
  List<Hora> nightHora;

  HoraMuhurta({
    required this.dayHora,
    required this.nightHora,
  });

  factory HoraMuhurta.fromJson(Map<String, dynamic> json) {
    return HoraMuhurta(
      dayHora: (json['dayHora'] as List<dynamic>? ?? [])
          .map((e) => Hora.fromJson(e as Map<String, dynamic>))
          .toList(),
      nightHora: (json['nightHora'] as List<dynamic>? ?? [])
          .map((e) => Hora.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Hora {
  String planet;
  String start;
  String end;

  Hora({
    required this.planet,
    required this.start,
    required this.end,
  });

  factory Hora.fromJson(Map<String, dynamic> json) {
    return Hora(
      planet: json['planet'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

class PanchangChaughadiya {
  List<Chaughadiya> dayChaughadiya;
  List<Chaughadiya> nightChaughadiya;

  PanchangChaughadiya({
    required this.dayChaughadiya,
    required this.nightChaughadiya,
  });

  factory PanchangChaughadiya.fromJson(Map<String, dynamic> json) {
    return PanchangChaughadiya(
      dayChaughadiya: (json['dayChaughadiya'] as List<dynamic>? ?? [])
          .map((e) => Chaughadiya.fromJson(e as Map<String, dynamic>))
          .toList(),
      nightChaughadiya: (json['nightChaughadiya'] as List<dynamic>? ?? [])
          .map((e) => Chaughadiya.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Chaughadiya {
  String name;
  String start;
  String end;
  String nature;

  Chaughadiya({
    required this.name,
    required this.start,
    required this.end,
    required this.nature,
  });

  factory Chaughadiya.fromJson(Map<String, dynamic> json) {
    return Chaughadiya(
      name: json['name'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      nature: json['nature'] as String? ?? '',
    );
  }
}

class PlanetaryPosition {
  String planet;
  AscendantEnum sign;
  int signId;
  String nakshatra;
  int nakshatraId;
  String nakshatraLord;
  int house;
  double degree;
  String formattedDegree;
  String isRetro;
  String motion;
  double normDegree;
  String formattedNormDegree;

  PlanetaryPosition({
    required this.planet,
    required this.sign,
    required this.signId,
    required this.nakshatra,
    required this.nakshatraId,
    required this.nakshatraLord,
    required this.house,
    required this.degree,
    required this.formattedDegree,
    required this.isRetro,
    required this.motion,
    required this.normDegree,
    required this.formattedNormDegree,
  });

  factory PlanetaryPosition.fromJson(Map<String, dynamic> json) {
    return PlanetaryPosition(
      planet: json['planet'] as String? ?? '',
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signId: json['signId'] as int? ?? 0,
      nakshatra: json['nakshatra'] as String? ?? '',
      nakshatraId: json['nakshatraId'] as int? ?? 0,
      nakshatraLord: json['nakshatraLord'] as String? ?? '',
      house: json['house'] as int? ?? 0,
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      formattedDegree: json['formattedDegree'] as String? ?? '',
      isRetro: json['isRetro'] as String? ?? '',
      motion: json['motion'] as String? ?? '',
      normDegree: (json['normDegree'] as num?)?.toDouble() ?? 0.0,
      formattedNormDegree: json['formattedNormDegree'] as String? ?? '',
    );
  }
}

class DataRemedies {
  Gemstone gemstone;
  Rudraksha rudraksha;

  DataRemedies({
    required this.gemstone,
    required this.rudraksha,
  });

  factory DataRemedies.fromJson(Map<String, dynamic> json) {
    return DataRemedies(
      gemstone: Gemstone.fromJson(json['gemstone'] as Map<String, dynamic>),
      rudraksha: Rudraksha.fromJson(json['rudraksha'] as Map<String, dynamic>),
    );
  }
}

class Gemstone {
  List<GemstoneDetails> primary;
  List<GemstoneDetails> secondary;
  String wearMode;

  Gemstone({
    required this.primary,
    required this.secondary,
    required this.wearMode,
  });

  factory Gemstone.fromJson(Map<String, dynamic> json) {
    return Gemstone(
      primary: (json['primary'] as List<dynamic>? ?? [])
          .map((e) => GemstoneDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      secondary: (json['secondary'] as List<dynamic>? ?? [])
          .map((e) => GemstoneDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      wearMode: json['wearMode'] as String? ?? '',
    );
  }
}

class GemstoneDetails {
  String name;
  String planet;
  String purpose;

  GemstoneDetails({
    required this.name,
    required this.planet,
    required this.purpose,
  });

  factory GemstoneDetails.fromJson(Map<String, dynamic> json) {
    return GemstoneDetails(
      name: json['name'] as String? ?? '',
      planet: json['planet'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
    );
  }
}

class Rudraksha {
  String name;
  int faces;
  String mantra;
  String wearMode;

  Rudraksha({
    required this.name,
    required this.faces,
    required this.mantra,
    required this.wearMode,
  });

  factory Rudraksha.fromJson(Map<String, dynamic> json) {
    return Rudraksha(
      name: json['name'] as String? ?? '',
      faces: json['faces'] as int? ?? 0,
      mantra: json['mantra'] as String? ?? '',
      wearMode: json['wearMode'] as String? ?? '',
    );
  }
}

class Reports {
  GeneralReport generalReport;
  HouseReport houseReport;

  Reports({
    required this.generalReport,
    required this.houseReport,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      generalReport: GeneralReport.fromJson(json['generalReport'] as Map<String, dynamic>),
      houseReport: HouseReport.fromJson(json['houseReport'] as Map<String, dynamic>),
    );
  }
}

class GeneralReport {
  String ascendant;
  String ascendantLord;
  String moonSign;
  String sunSign;
  String nakshatra;
  String charan;
  String tithi;
  String karan;
  String yog;
  String nameAlphabet;

  GeneralReport({
    required this.ascendant,
    required this.ascendantLord,
    required this.moonSign,
    required this.sunSign,
    required this.nakshatra,
    required this.charan,
    required this.tithi,
    required this.karan,
    required this.yog,
    required this.nameAlphabet,
  });

  factory GeneralReport.fromJson(Map<String, dynamic> json) {
    return GeneralReport(
      ascendant: json['ascendant'] as String? ?? '',
      ascendantLord: json['ascendantLord'] as String? ?? '',
      moonSign: json['moonSign'] as String? ?? '',
      sunSign: json['sunSign'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      charan: json['charan'] as String? ?? '',
      tithi: json['tithi'] as String? ?? '',
      karan: json['karan'] as String? ?? '',
      yog: json['yog'] as String? ?? '',
      nameAlphabet: json['nameAlphabet'] as String? ?? '',
    );
  }
}

class HouseReport {
  List<HouseDetail> houses;

  HouseReport({
    required this.houses,
  });

  factory HouseReport.fromJson(Map<String, dynamic> json) {
    return HouseReport(
      houses: (json['houses'] as List<dynamic>? ?? [])
          .map((e) => HouseDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HouseDetail {
  int houseId;
  AscendantEnum sign;
  String signLord;
  List<String> planets;
  String report;

  HouseDetail({
    required this.houseId,
    required this.sign,
    required this.signLord,
    required this.planets,
    required this.report,
  });

  factory HouseDetail.fromJson(Map<String, dynamic> json) {
    return HouseDetail(
      houseId: json['houseId'] as int? ?? 0,
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signLord: json['signLord'] as String? ?? '',
      planets: (json['planets'] as List<dynamic>? ?? []).cast<String>(),
      report: json['report'] as String? ?? '',
    );
  }
}

class Suggestions {
  List<Suggestion> favorable;
  List<Suggestion> unfavorable;

  Suggestions({
    required this.favorable,
    required this.unfavorable,
  });

  factory Suggestions.fromJson(Map<String, dynamic> json) {
    return Suggestions(
      favorable: (json['favorable'] as List<dynamic>? ?? [])
          .map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
      unfavorable: (json['unfavorable'] as List<dynamic>? ?? [])
          .map((e) => Suggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Suggestion {
  String category;
  List<String> items;

  Suggestion({
    required this.category,
    required this.items,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      category: json['category'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}

// class Varshaphal {
//   VarshaphalaYear varshaphalaYear;
//   List<Muntha> muntha;
//   List<Chalit> varshaphalaChart;
//   List<VarshaphalaPlanet> planets;
//
//   Varshaphal({
//     required this.varshaphalaYear,
//     required this.muntha,
//     required this.varshaphalaChart,
//     required this.planets,
//   });
//
//   factory Varshaphal.fromJson(Map<String, dynamic> json) {
//     return Varshaphal(
//       varshaphalaYear: VarshaphalaYear.fromJson(json['varshaphalaYear'] as Map<String, dynamic>),
//       muntha: (json['muntha'] as List<dynamic>? ?? [])
//           .map((e) => Muntha.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       varshaphalaChart: (json['varshaphalaChart'] as List<dynamic>? ?? [])
//           .map((e) => Chalit.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       planets: (json['planets'] as List<dynamic>? ?? [])
//           .map((e) => VarshaphalaPlanet.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

class Muntha {
  int house;
  AscendantEnum sign;
  String signLord;
  String nakshatra;
  String nakshatraLord;

  Muntha({
    required this.house,
    required this.sign,
    required this.signLord,
    required this.nakshatra,
    required this.nakshatraLord,
  });

  factory Muntha.fromJson(Map<String, dynamic> json) {
    return Muntha(
      house: json['house'] as int? ?? 0,
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      signLord: json['signLord'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      nakshatraLord: json['nakshatraLord'] as String? ?? '',
    );
  }
}

class VarshaphalaPlanet {
  String planet;
  AscendantEnum sign;
  int house;
  double degree;
  String formattedDegree;
  String isRetro;
  String nakshatra;
  String nakshatraLord;

  VarshaphalaPlanet({
    required this.planet,
    required this.sign,
    required this.house,
    required this.degree,
    required this.formattedDegree,
    required this.isRetro,
    required this.nakshatra,
    required this.nakshatraLord,
  });

  factory VarshaphalaPlanet.fromJson(Map<String, dynamic> json) {
    return VarshaphalaPlanet(
      planet: json['planet'] as String? ?? '',
      sign: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['sign'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      house: json['house'] as int? ?? 0,
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      formattedDegree: json['formattedDegree'] as String? ?? '',
      isRetro: json['isRetro'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      nakshatraLord: json['nakshatraLord'] as String? ?? '',
    );
  }
}

class VarshaphalaYear {
  int year;
  VarshaphalaYearLord yearLord;
  String munthaSign;
  AscendantEnum munthaSignName;
  int munthaHouse;

  VarshaphalaYear({
    required this.year,
    required this.yearLord,
    required this.munthaSign,
    required this.munthaSignName,
    required this.munthaHouse,
  });

  factory VarshaphalaYear.fromJson(Map<String, dynamic> json) {
    return VarshaphalaYear(
      year: json['year'] as int? ?? 0,
      yearLord: VarshaphalaYearLord.values.firstWhere(
            (e) => e.toString().split('.').last == (json['yearLord'] as String? ?? 'SUN'),
        orElse: () => VarshaphalaYearLord.SUN,
      ),
      munthaSign: json['munthaSign'] as String? ?? '',
      munthaSignName: AscendantEnum.values.firstWhere(
            (e) => e.toString().split('.').last == (json['munthaSignName'] as String? ?? 'ARIES'),
        orElse: () => AscendantEnum.ARIES,
      ),
      munthaHouse: json['munthaHouse'] as int? ?? 0,
    );
  }
}