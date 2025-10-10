// Base response model
class KundliResponse {
  final bool status;
  final String message;
  final KundliData? data;

  KundliResponse({required this.status, required this.message, this.data});

  factory KundliResponse.fromJson(Map<String, dynamic> json) {
    return KundliResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? 'No message',
      data: json['data'] != null
          ? KundliData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Data container for Kundli details
class KundliData {
  final BasicDetails? basicDetails;
  final AstroDetails? astroDetails;
  final List<PlanetaryPosition>? planetaryPositions;
  final Lalkitab? lalkitab;
  final Varshaphal? varshaphal;
  final KpSystem? kpSystem;
  final Panchang? panchang;
  final Ashtakvarga? ashtakvarga;
  final Dosha? dosha;
  final Remedies? remedies;
  final Dasha? dasha;
  final Reports? reports;
  final Charts? charts;

  KundliData({
    this.basicDetails,
    this.astroDetails,
    this.planetaryPositions,
    this.lalkitab,
    this.varshaphal,
    this.kpSystem,
    this.panchang,
    this.ashtakvarga,
    this.dosha,
    this.remedies,
    this.dasha,
    this.reports,
    this.charts,
  });

  factory KundliData.fromJson(Map<String, dynamic> json) {
    return KundliData(
      basicDetails: json['basicDetails'] != null
          ? BasicDetails.fromJson(json['basicDetails'] as Map<String, dynamic>)
          : null,
      astroDetails: json['astroDetails'] != null
          ? AstroDetails.fromJson(json['astroDetails'] as Map<String, dynamic>)
          : null,
      planetaryPositions: json['planetaryPositions'] != null
          ? (json['planetaryPositions'] as List)
          .map(
            (e) => PlanetaryPosition.fromJson(e as Map<String, dynamic>),
      )
          .toList()
          : null,
      lalkitab: json['lalkitab'] != null
          ? Lalkitab.fromJson(json['lalkitab'] as Map<String, dynamic>)
          : null,
      varshaphal: json['varshaphal'] != null
          ? Varshaphal.fromJson(json['varshaphal'] as Map<String, dynamic>)
          : null,
      kpSystem: KpSystem.fromJson(
        json['kpSystem'] != null
            ? json['kpSystem'] as Map<String, dynamic>
            : {},
      ),
      panchang: Panchang.fromJson(
        json['panchang'] != null
            ? json['panchang'] as Map<String, dynamic>
            : {},
      ),
      ashtakvarga: Ashtakvarga.fromJson(
        json['ashtakvarga'] != null
            ? json['ashtakvarga'] as Map<String, dynamic>
            : {},
      ),
      dosha: Dosha.fromJson(
        json['dosha'] != null ? json['dosha'] as Map<String, dynamic> : {},
      ),
      remedies: Remedies.fromJson(
        json['remedies'] != null
            ? json['remedies'] as Map<String, dynamic>
            : {},
      ),
      dasha: Dasha.fromJson(
        json['dasha'] != null ? json['dasha'] as Map<String, dynamic> : {},
      ),
      reports: Reports.fromJson(
        json['reports'] != null ? json['reports'] as Map<String, dynamic> : {},
      ),
      charts: Charts.fromJson(
        json['charts'] != null ? json['charts'] as Map<String, dynamic> : {},
      ),
    );
  }
}

// basic_details.dart
class BasicDetails {
  final String? name;
  final String? dob;
  final String? tob;
  final String? place;
  final double? latitude;
  final double? longitude;
  final double? timezone;
  final String? gender;
  final String? ascendant;
  final String? moonSign;
  final String? sunSign;
  final String? sunrise;
  final String? sunset;
  final String? ayanamsha;

  BasicDetails({
    this.name,
    this.dob,
    this.tob,
    this.place,
    this.latitude,
    this.longitude,
    this.timezone,
    this.gender,
    this.ascendant,
    this.moonSign,
    this.sunSign,
    this.sunrise,
    this.sunset,
    this.ayanamsha,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
      name: json['name'] as String?,
      dob: json['dob'] as String?,
      tob: json['tob'] as String?,
      place: json['place'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      timezone: (json['timezone'] as num?)?.toDouble(),
      gender: json['gender'] as String?,
      ascendant: json['ascendant'] as String?,
      moonSign: json['moonSign'] as String?,
      sunSign: json['sunSign'] as String?,
      sunrise: json['sunrise'] as String?,
      sunset: json['sunset'] as String?,
      ayanamsha: json['ayanamsha'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'tob': tob,
      'place': place,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'gender': gender,
      'ascendant': ascendant,
      'moonSign': moonSign,
      'sunSign': sunSign,
      'sunrise': sunrise,
      'sunset': sunset,
      'ayanamsha': ayanamsha,
    };
  }
}

// astro_details.dart
class AstroDetails {
  final String? ascendant;
  final String? ascendantLord;
  final String? varna;
  final String? vashya;
  final String? yoni;
  final String? gan;
  final String? nadi;
  final String? signLord;
  final String? sign;
  final String? naksahtra;
  final String? naksahtraLord;
  final int? charan;
  final String? yog;
  final String? karan;
  final String? tithi;
  final String? yunja;
  final String? tatva;
  final String? nameAlphabet;
  final String? paya;

  AstroDetails({
    this.ascendant,
    this.ascendantLord,
    this.varna,
    this.vashya,
    this.yoni,
    this.gan,
    this.nadi,
    this.signLord,
    this.sign,
    this.naksahtra,
    this.naksahtraLord,
    this.charan,
    this.yog,
    this.karan,
    this.tithi,
    this.yunja,
    this.tatva,
    this.nameAlphabet,
    this.paya,
  });

  factory AstroDetails.fromJson(Map<String, dynamic> json) {
    return AstroDetails(
      ascendant: json['ascendant'] as String?,
      ascendantLord: json['ascendant_lord'] as String?,
      varna: json['Varna'] as String?,
      vashya: json['Vashya'] as String?,
      yoni: json['Yoni'] as String?,
      gan: json['Gan'] as String?,
      nadi: json['Nadi'] as String?,
      signLord: json['SignLord'] as String?,
      sign: json['sign'] as String?,
      naksahtra: json['Naksahtra'] as String?,
      naksahtraLord: json['NaksahtraLord'] as String?,
      charan: json['Charan'] as int?,
      yog: json['Yog'] as String?,
      karan: json['Karan'] as String?,
      tithi: json['Tithi'] as String?,
      yunja: json['yunja'] as String?,
      tatva: json['tatva'] as String?,
      nameAlphabet: json['name_alphabet'] as String?,
      paya: json['paya'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ascendant': ascendant,
      'ascendant_lord': ascendantLord,
      'Varna': varna,
      'Vashya': vashya,
      'Yoni': yoni,
      'Gan': gan,
      'Nadi': nadi,
      'SignLord': signLord,
      'sign': sign,
      'Naksahtra': naksahtra,
      'NaksahtraLord': naksahtraLord,
      'Charan': charan,
      'Yog': yog,
      'Karan': karan,
      'Tithi': tithi,
      'yunja': yunja,
      'tatva': tatva,
      'name_alphabet': nameAlphabet,
      'paya': paya,
    };
  }
}

// planetary_position.dart
class PlanetaryPosition {
  final String? name;
  final String? sign;
  final double? degree;
  final int? house;
  final String? nakshatra;
  final String? nakshatraLord;
  final bool? isRetro;

  PlanetaryPosition({
    this.name,
    this.sign,
    this.degree,
    this.house,
    this.nakshatra,
    this.nakshatraLord,
    this.isRetro,
  });

  factory PlanetaryPosition.fromJson(Map<String, dynamic> json) {
    return PlanetaryPosition(
      name: json['name'] as String?,
      sign: json['sign'] as String?,
      degree: (json['degree'] as num?)?.toDouble(),
      house: json['house'] as int?,
      nakshatra: json['nakshatra'] as String?,
      nakshatraLord: json['nakshatraLord'] as String?,
      isRetro: json['isRetro'] is String
          ? (json['isRetro'] as String).toLowerCase() == 'true'
          : json['isRetro'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sign': sign,
      'degree': degree,
      'house': house,
      'nakshatra': nakshatra,
      'nakshatraLord': nakshatraLord,
      'isRetro': isRetro?.toString(), // Convert back to string if needed
    };
  }
}

// lalkitab.dart
class Lalkitab {
  final List<LalkitabHoroscope>? horoscope;
  final List<Debt>? debts;
  final List<LalkitabHouse>? houses;
  final List<LalkitabPlanet>? planets;
  final Remedies? remedies;

  Lalkitab({
    this.horoscope,
    this.debts,
    this.houses,
    this.planets,
    this.remedies,
  });

  factory Lalkitab.fromJson(Map<String, dynamic> json) {
    return Lalkitab(
      horoscope: (json['horoscope'] as List<dynamic>?)
          ?.map((e) => LalkitabHoroscope.fromJson(e as Map<String, dynamic>))
          .toList(),
      debts: (json['debts'] as List<dynamic>?)
          ?.map((e) => Debt.fromJson(e as Map<String, dynamic>))
          .toList(),
      houses: (json['houses'] as List<dynamic>?)
          ?.map((e) => LalkitabHouse.fromJson(e as Map<String, dynamic>))
          .toList(),
      planets: (json['planets'] as List<dynamic>?)
          ?.map((e) => LalkitabPlanet.fromJson(e as Map<String, dynamic>))
          .toList(),
      remedies: json['remedies'] != null
          ? Remedies.fromJson(json['remedies'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'horoscope': horoscope?.map((e) => e.toJson()).toList(),
      'debts': debts?.map((e) => e.toJson()).toList(),
      'houses': houses?.map((e) => e.toJson()).toList(),
      'planets': planets?.map((e) => e.toJson()).toList(),
      'remedies': remedies?.toJson(),
    };
  }
}

class Remedies {
  final LalKitabRemedy? sun;
  final LalKitabRemedy? moon;
  final LalKitabRemedy? mars;
  final LalKitabRemedy? mercury;
  final LalKitabRemedy? jupiter;
  final LalKitabRemedy? venus;
  final LalKitabRemedy? saturn;

  Remedies({
    this.sun,
    this.moon,
    this.mars,
    this.mercury,
    this.jupiter,
    this.venus,
    this.saturn,
  });

  factory Remedies.fromJson(Map<String, dynamic> json) {
    return Remedies(
      sun: json['sun'] != null
          ? LalKitabRemedy.fromJson(json['sun'] as Map<String, dynamic>)
          : null,
      moon: json['moon'] != null
          ? LalKitabRemedy.fromJson(json['moon'] as Map<String, dynamic>)
          : null,
      mars: json['mars'] != null
          ? LalKitabRemedy.fromJson(json['mars'] as Map<String, dynamic>)
          : null,
      mercury: json['mercury'] != null
          ? LalKitabRemedy.fromJson(json['mercury'] as Map<String, dynamic>)
          : null,
      jupiter: json['jupiter'] != null
          ? LalKitabRemedy.fromJson(json['jupiter'] as Map<String, dynamic>)
          : null,
      venus: json['venus'] != null
          ? LalKitabRemedy.fromJson(json['venus'] as Map<String, dynamic>)
          : null,
      saturn: json['saturn'] != null
          ? LalKitabRemedy.fromJson(json['saturn'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sun': sun?.toJson(),
      'moon': moon?.toJson(),
      'mars': mars?.toJson(),
      'mercury': mercury?.toJson(),
      'jupiter': jupiter?.toJson(),
      'venus': venus?.toJson(),
      'saturn': saturn?.toJson(),
    };
  }
}

class LalkitabHoroscope {
  final int? sign;
  final String? signName;
  final List<String>? planet;
  final List<String>? planetSmall;
  final List<dynamic>? planetDegree;

  LalkitabHoroscope({
    this.sign,
    this.signName,
    this.planet,
    this.planetSmall,
    this.planetDegree,
  });

  factory LalkitabHoroscope.fromJson(Map<String, dynamic> json) {
    return LalkitabHoroscope(
      sign: json['sign'] as int?,
      signName: json['sign_name'] as String?,
      planet: (json['planet'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      planetSmall: (json['planet_small'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      planetDegree: json['planet_degree'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sign': sign,
      'sign_name': signName,
      'planet': planet,
      'planet_small': planetSmall,
      'planet_degree': planetDegree,
    };
  }
}

class Debt {
  final String? debtName;
  final String? indications;
  final String? events;

  Debt({this.debtName, this.indications, this.events});

  factory Debt.fromJson(Map<String, dynamic> json) {
    return Debt(
      debtName: json['debt_name'] as String?,
      indications: json['indications'] as String?,
      events: json['events'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'debt_name': debtName,
      'indications': indications,
      'events': events,
    };
  }
}

class LalkitabHouse {
  final int? khanaNumber;
  final String? maalik;
  final String? pakkaGhar;
  final String? kismat;
  final bool? soya;
  final List<String>? exalt; // Can be a string "-" or a list of strings
  final List<String>? debilitated; // Can be a string "-" or a list of strings

  LalkitabHouse({
    this.khanaNumber,
    this.maalik,
    this.pakkaGhar,
    this.kismat,
    this.soya,
    this.exalt,
    this.debilitated,
  });

  factory LalkitabHouse.fromJson(Map<String, dynamic> json) {
    List<String>? parsedExalt;
    if (json['exalt'] is String && json['exalt'] == '-') {
      parsedExalt = [];
    } else if (json['exalt'] is List) {
      parsedExalt = (json['exalt'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    List<String>? parsedDebilitated;
    if (json['debilitated'] is String && json['debilitated'] == '-') {
      parsedDebilitated = [];
    } else if (json['debilitated'] is List) {
      parsedDebilitated = (json['debilitated'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    return LalkitabHouse(
      khanaNumber: json['khana_number'] as int?,
      maalik: json['maalik'] as String?,
      pakkaGhar: json['pakka_ghar'] as String?,
      kismat: json['kismat'] as String?,
      soya: json['soya'] as bool?,
      exalt: parsedExalt,
      debilitated: parsedDebilitated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'khana_number': khanaNumber,
      'maalik': maalik,
      'pakka_ghar': pakkaGhar,
      'kismat': kismat,
      'soya': soya,
      'exalt': exalt?.isEmpty == true
          ? '-'
          : exalt, // Convert empty list to "-"
      'debilitated': debilitated?.isEmpty == true
          ? '-'
          : debilitated, // Convert empty list to "-"
    };
  }
}

class LalkitabPlanet {
  final String? planet;
  final String? rashi;
  final bool? soya;
  final String? position;
  final String? nature;

  LalkitabPlanet({
    this.planet,
    this.rashi,
    this.soya,
    this.position,
    this.nature,
  });

  factory LalkitabPlanet.fromJson(Map<String, dynamic> json) {
    return LalkitabPlanet(
      planet: json['planet'] as String?,
      rashi: json['rashi'] as String?,
      soya: json['soya'] as bool?,
      position: json['position'] as String?,
      nature: json['nature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planet': planet,
      'rashi': rashi,
      'soya': soya,
      'position': position,
      'nature': nature,
    };
  }
}

class LalKitabRemedy {
  final String? planet;
  final String? house;
  final String? lalKitabDesc;
  final List<String>? lalKitabRemedies;

  LalKitabRemedy({
    this.planet,
    this.house,
    this.lalKitabDesc,
    this.lalKitabRemedies,
  });

  factory LalKitabRemedy.fromJson(Map<String, dynamic> json) {
    return LalKitabRemedy(
      planet: json['planet'] as String?,
      house: json['house'] as String?,
      lalKitabDesc: json['lal_kitab_desc'] as String?,
      lalKitabRemedies: (json['lal_kitab_remedies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planet': planet,
      'house': house,
      'lal_kitab_desc': lalKitabDesc,
      'lal_kitab_remedies': lalKitabRemedies,
    };
  }
}

// varshaphal.dart
class Varshaphal {
  final VarshaphalDetails? details;
  final List<VarshaphalPlanet>? planets;
  final String? muntha;
  final List<MuddaDasha>? muddaDasha;
  final Panchavargeeya? panchavargeeya;
  final HarshaBala? harshaBala;
  final List<SahamPoint>? sahamPoints;
  final List<Yoga>? yoga;
  final YearChart? yearChart;
  final List<MonthChart>? monthChart;

  Varshaphal({
    this.details,
    this.planets,
    this.muntha,
    this.muddaDasha,
    this.panchavargeeya,
    this.harshaBala,
    this.sahamPoints,
    this.yoga,
    this.yearChart,
    this.monthChart,
  });

  factory Varshaphal.fromJson(Map<String, dynamic> json) {
    return Varshaphal(
      details: json['details'] != null
          ? VarshaphalDetails.fromJson(json['details'] as Map<String, dynamic>)
          : null,
      planets: (json['planets'] as List<dynamic>?)
          ?.map((e) => VarshaphalPlanet.fromJson(e as Map<String, dynamic>))
          .toList(),
      muntha: json['muntha'] as String?,
      muddaDasha: (json['muddaDasha'] as List<dynamic>?)
          ?.map((e) => MuddaDasha.fromJson(e as Map<String, dynamic>))
          .toList(),
      panchavargeeya: json['panchavargeeya'] != null
          ? Panchavargeeya.fromJson(
        json['panchavargeeya'] as Map<String, dynamic>,
      )
          : null,
      harshaBala: json['harshaBala'] != null
          ? HarshaBala.fromJson(json['harshaBala'] as Map<String, dynamic>)
          : null,
      sahamPoints: (json['sahamPoints'] as List<dynamic>?)
          ?.map((e) => SahamPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      yoga: (json['yoga'] as List<dynamic>?)
          ?.map((e) => Yoga.fromJson(e as Map<String, dynamic>))
          .toList(),
      yearChart: json['yearChart'] != null
          ? YearChart.fromJson(json['yearChart'] as Map<String, dynamic>)
          : null,
      monthChart: (json['monthChart'] as List<dynamic>?)
          ?.map((e) => MonthChart.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details?.toJson(),
      'planets': planets?.map((e) => e.toJson()).toList(),
      'muntha': muntha,
      'muddaDasha': muddaDasha?.map((e) => e.toJson()).toList(),
      'panchavargeeya': panchavargeeya?.toJson(),
      'harshaBala': harshaBala?.toJson(),
      'sahamPoints': sahamPoints?.map((e) => e.toJson()).toList(),
      'yoga': yoga?.map((e) => e.toJson()).toList(),
      'yearChart': yearChart?.toJson(),
      'monthChart': monthChart?.map((e) => e.toJson()).toList(),
    };
  }
}

class VarshaphalDetails {
  final int? varshaphalaYear;
  final int? ageOfNative;
  final String? ayanamshaName;
  final double? ayanamshaDegree;
  final int? varshaphalaTimestamp;
  final String? nativeBirthDate;
  final String? varshaphalaDate;
  final Panchadhikari? panchadhikari;
  final String? varshaphalaYearLord;
  final VarshaphalMuntha? varshaphalaMuntha;

  VarshaphalDetails({
    this.varshaphalaYear,
    this.ageOfNative,
    this.ayanamshaName,
    this.ayanamshaDegree,
    this.varshaphalaTimestamp,
    this.nativeBirthDate,
    this.varshaphalaDate,
    this.panchadhikari,
    this.varshaphalaYearLord,
    this.varshaphalaMuntha,
  });

  factory VarshaphalDetails.fromJson(Map<String, dynamic> json) {
    return VarshaphalDetails(
      varshaphalaYear: json['varshaphala_year'] as int?,
      ageOfNative: json['age_of_native'] as int?,
      ayanamshaName: json['ayanamsha_name'] as String?,
      ayanamshaDegree: (json['ayanamsha_degree'] as num?)?.toDouble(),
      varshaphalaTimestamp: json['varshaphala_timestamp'] as int?,
      nativeBirthDate: json['native_birth_date'] as String?,
      varshaphalaDate: json['varshaphala_date'] as String?,
      panchadhikari: json['panchadhikari'] != null
          ? Panchadhikari.fromJson(
        json['panchadhikari'] as Map<String, dynamic>,
      )
          : null,
      varshaphalaYearLord: json['varshaphala_year_lord'] as String?,
      varshaphalaMuntha: json['varshaphala_muntha'] != null
          ? VarshaphalMuntha.fromJson(
        json['varshaphala_muntha'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'varshaphala_year': varshaphalaYear,
      'age_of_native': ageOfNative,
      'ayanamsha_name': ayanamshaName,
      'ayanamsha_degree': ayanamshaDegree,
      'varshaphala_timestamp': varshaphalaTimestamp,
      'native_birth_date': nativeBirthDate,
      'varshaphala_date': varshaphalaDate,
      'panchadhikari': panchadhikari?.toJson(),
      'varshaphala_year_lord': varshaphalaYearLord,
      'varshaphala_muntha': varshaphalaMuntha?.toJson(),
    };
  }
}

class Panchadhikari {
  final String? munthaLord;
  final int? munthaLordId;
  final String? birthAscendantLord;
  final int? birthAscendantLordId;
  final String? yearAscendantLord;
  final int? yearAscendantLordId;
  final String? dinratriLord;
  final String? trirashiLord;

  Panchadhikari({
    this.munthaLord,
    this.munthaLordId,
    this.birthAscendantLord,
    this.birthAscendantLordId,
    this.yearAscendantLord,
    this.yearAscendantLordId,
    this.dinratriLord,
    this.trirashiLord,
  });

  factory Panchadhikari.fromJson(Map<String, dynamic> json) {
    return Panchadhikari(
      munthaLord: json['muntha_lord'] as String?,
      munthaLordId: json['muntha_lord_id'] as int?,
      birthAscendantLord: json['birth_ascendant_lord'] as String?,
      birthAscendantLordId: json['birth_ascendant_lord_id'] as int?,
      yearAscendantLord: json['year_ascendant_lord'] as String?,
      yearAscendantLordId: json['year_ascendant_lord_id'] as int?,
      dinratriLord: json['dinratri_lord'] as String?,
      trirashiLord: json['trirashi_lord'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muntha_lord': munthaLord,
      'muntha_lord_id': munthaLordId,
      'birth_ascendant_lord': birthAscendantLord,
      'birth_ascendant_lord_id': birthAscendantLordId,
      'year_ascendant_lord': yearAscendantLord,
      'year_ascendant_lord_id': yearAscendantLordId,
      'dinratri_lord': dinratriLord,
      'trirashi_lord': trirashiLord,
    };
  }
}

class VarshaphalMuntha {
  final String? munthaSign;
  final String? munthaSignLord;

  VarshaphalMuntha({this.munthaSign, this.munthaSignLord});

  factory VarshaphalMuntha.fromJson(Map<String, dynamic> json) {
    return VarshaphalMuntha(
      munthaSign: json['muntha_sign'] as String?,
      munthaSignLord: json['muntha_sign_lord'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'muntha_sign': munthaSign, 'muntha_sign_lord': munthaSignLord};
  }
}

class VarshaphalPlanet {
  final int? id;
  final String? name;
  final double? fullDegree;
  final double? normDegree;
  final double? speed;
  final bool? isRetro; // Converted from string "true"/"false" to bool
  final String? sign;
  final String? signLord;
  final String? nakshatra;
  final String? nakshatraLord;
  final int? nakshatraPad;
  final int? house;
  final bool? isPlanetSet;
  final String? planetAwastha;

  VarshaphalPlanet({
    this.id,
    this.name,
    this.fullDegree,
    this.normDegree,
    this.speed,
    this.isRetro,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.nakshatraPad,
    this.house,
    this.isPlanetSet,
    this.planetAwastha,
  });

  factory VarshaphalPlanet.fromJson(Map<String, dynamic> json) {
    return VarshaphalPlanet(
      id: json['id'] as int?,
      name: json['name'] as String?,
      fullDegree: (json['fullDegree'] as num?)?.toDouble(),
      normDegree: (json['normDegree'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      isRetro: json['isRetro'] is String
          ? (json['isRetro'] as String).toLowerCase() == 'true'
          : json['isRetro'] as bool?,
      sign: json['sign'] as String?,
      signLord: json['signLord'] as String?,
      nakshatra: json['nakshatra'] as String?,
      nakshatraLord: json['nakshatraLord'] as String?,
      nakshatraPad: json['nakshatra_pad'] as int?,
      house: json['house'] as int?,
      isPlanetSet: json['is_planet_set'] as bool?,
      planetAwastha: json['planet_awastha'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fullDegree': fullDegree,
      'normDegree': normDegree,
      'speed': speed,
      'isRetro': isRetro?.toString(), // Convert back to string if needed
      'sign': sign,
      'signLord': signLord,
      'nakshatra': nakshatra,
      'nakshatraLord': nakshatraLord,
      'nakshatra_pad': nakshatraPad,
      'house': house,
      'is_planet_set': isPlanetSet,
      'planet_awastha': planetAwastha,
    };
  }
}

class MuddaDasha {
  final String? planet;
  final int? duration;
  final String? dashaStart;
  final String? dashaEnd;

  MuddaDasha({this.planet, this.duration, this.dashaStart, this.dashaEnd});

  factory MuddaDasha.fromJson(Map<String, dynamic> json) {
    return MuddaDasha(
      planet: json['planet'] as String?,
      duration: json['duration'] as int?,
      dashaStart: json['dasha_start'] as String?,
      dashaEnd: json['dasha_end'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planet': planet,
      'duration': duration,
      'dasha_start': dashaStart,
      'dasha_end': dashaEnd,
    };
  }
}

class Panchavargeeya {
  final List<double>? kshetraBala;
  final List<double>? ucchaBala;
  final List<double>? haddaBala;
  final List<double>? drekkanaBala;
  final List<double>? navmanshaBala;
  final List<double>? totalBala;
  final List<double>? finalBala;

  Panchavargeeya({
    this.kshetraBala,
    this.ucchaBala,
    this.haddaBala,
    this.drekkanaBala,
    this.navmanshaBala,
    this.totalBala,
    this.finalBala,
  });

  factory Panchavargeeya.fromJson(Map<String, dynamic> json) {
    return Panchavargeeya(
      kshetraBala: (json['kshetra_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      ucchaBala: (json['uccha_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      haddaBala: (json['hadda_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      drekkanaBala: (json['drekkana_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      navmanshaBala: (json['navmansha_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      totalBala: (json['total_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      finalBala: (json['final_bala'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kshetra_bala': kshetraBala,
      'uccha_bala': ucchaBala,
      'hadda_bala': haddaBala,
      'drekkana_bala': drekkanaBala,
      'navmansha_bala': navmanshaBala,
      'total_bala': totalBala,
      'final_bala': finalBala,
    };
  }
}

class HarshaBala {
  final List<int>? sthanaBala;
  final List<int>? ucchaswachetriBala;
  final List<int>? genderBala;
  final List<int>? dinratriBala;
  final List<int>? totalBala;

  HarshaBala({
    this.sthanaBala,
    this.ucchaswachetriBala,
    this.genderBala,
    this.dinratriBala,
    this.totalBala,
  });

  factory HarshaBala.fromJson(Map<String, dynamic> json) {
    return HarshaBala(
      sthanaBala: (json['sthana_bala'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      ucchaswachetriBala: (json['ucchaswachetri_bala'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      genderBala: (json['gender_bala'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      dinratriBala: (json['dinratri_bala'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      totalBala: (json['total_bala'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sthana_bala': sthanaBala,
      'ucchaswachetri_bala': ucchaswachetriBala,
      'gender_bala': genderBala,
      'dinratri_bala': dinratriBala,
      'total_bala': totalBala,
    };
  }
}

class SahamPoint {
  final int? sahamId;
  final String? sahamName;
  final double? sahamDegree;

  SahamPoint({this.sahamId, this.sahamName, this.sahamDegree});

  factory SahamPoint.fromJson(Map<String, dynamic> json) {
    return SahamPoint(
      sahamId: json['saham_id'] as int?,
      sahamName: json['saham_name'] as String?,
      sahamDegree: (json['saham_degree'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saham_id': sahamId,
      'saham_name': sahamName,
      'saham_degree': sahamDegree,
    };
  }
}

class Yoga {
  final String? yogName;
  final String? yogDescription;
  final bool? isYogHappening;
  final String? powerfullnessPercentage;
  final String? yogPrediction;
  final List<dynamic>? planets; // Can be List<String>, List<List<String?>>
  final List<YogaType>? yogType;

  Yoga({
    this.yogName,
    this.yogDescription,
    this.isYogHappening,
    this.powerfullnessPercentage,
    this.yogPrediction,
    this.planets,
    this.yogType,
  });

  factory Yoga.fromJson(Map<String, dynamic> json) {
    return Yoga(
      yogName: json['yog_name'] as String?,
      yogDescription: json['yog_description'] as String?,
      isYogHappening: json['is_yog_happening'] as bool?,
      powerfullnessPercentage: json['powerfullness_percentage'] as String?,
      yogPrediction: json['yog_prediction'] as String?,
      planets:
      json['planets']
      as List<dynamic>?, // Keep as dynamic due to varied types
      yogType: (json['yog_type'] as List<dynamic>?)
          ?.map((e) => YogaType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yog_name': yogName,
      'yog_description': yogDescription,
      'is_yog_happening': isYogHappening,
      'powerfullness_percentage': powerfullnessPercentage,
      'yog_prediction': yogPrediction,
      'planets': planets,
      'yog_type': yogType?.map((e) => e.toJson()).toList(),
    };
  }
}

class YogaType {
  final String? yogName;
  final List<String>? planets;
  final List<int>? planetsId;

  YogaType({this.yogName, this.planets, this.planetsId});

  factory YogaType.fromJson(Map<String, dynamic> json) {
    return YogaType(
      yogName: json['yog_name'] as String?,
      planets: (json['planets'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      planetsId: (json['planets_id'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'yog_name': yogName, 'planets': planets, 'planets_id': planetsId};
  }
}

class YearChart {
  final String? yearLord;
  final String? varshaphalDate;
  final List<ChartDetails>? chart;

  YearChart({this.yearLord, this.varshaphalDate, this.chart});

  factory YearChart.fromJson(Map<String, dynamic> json) {
    return YearChart(
      yearLord: json['year_lord'] as String?,
      varshaphalDate: json['varshaphal_date'] as String?,
      chart: (json['chart'] as List<dynamic>?)
          ?.map((e) => ChartDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year_lord': yearLord,
      'varshaphal_date': varshaphalDate,
      'chart': chart?.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthChart {
  final int? monthId;
  final List<ChartDetails>? chart;

  MonthChart({this.monthId, this.chart});

  factory MonthChart.fromJson(Map<String, dynamic> json) {
    return MonthChart(
      monthId: json['month_id'] as int?,
      chart: (json['chart'] as List<dynamic>?)
          ?.map((e) => ChartDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month_id': monthId,
      'chart': chart?.map((e) => e.toJson()).toList(),
    };
  }
}

class ChartDetails {
  final int? sign;
  final String? signName;
  final List<String>? planet;
  final List<String>? planetSmall;
  final List<dynamic>? planetDegree; // Can be empty or contain values

  ChartDetails({
    this.sign,
    this.signName,
    this.planet,
    this.planetSmall,
    this.planetDegree,
  });

  factory ChartDetails.fromJson(Map<String, dynamic> json) {
    return ChartDetails(
      sign: json['sign'] as int?,
      signName: json['sign_name'] as String?,
      planet: (json['planet'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      planetSmall: (json['planet_small'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      planetDegree:
      json['planet_degree']
      as List<dynamic>?, // Keep as dynamic due to varied types
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sign': sign,
      'sign_name': signName,
      'planet': planet,
      'planet_small': planetSmall,
      'planet_degree': planetDegree,
    };
  }
}

/// Charts
class D10Image {
  String svg;

  D10Image({this.svg = ''});

  factory D10Image.fromJson(Map<String, dynamic>? json) {
    if (json == null) return D10Image(svg: '');
    return D10Image(svg: json['svg'] as String? ?? '');
  }
}

class Chalit {
  int sign;
  AscendantEnum signName;
  List<VarshaphalaYearLord> planet;
  List<PlanetSmall> planetSmall;
  List<dynamic> planetDegree;

  Chalit({
    this.sign = 0,
    AscendantEnum? signName,
    List<VarshaphalaYearLord>? planet,
    List<PlanetSmall>? planetSmall,
    List<dynamic>? planetDegree,
  })  : signName = signName ?? AscendantEnum.values.first, // fallback enum value
        planet = planet ?? [],
        planetSmall = planetSmall ?? [],
        planetDegree = planetDegree ?? [];

  factory Chalit.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Chalit();

    return Chalit(
      sign: json['sign'] as int? ?? 0,
      signName: json['signName'] != null
          ? ascendantEnumFromString(json['signName'])
          : AscendantEnum.values.first,
      // planet: (json['planet'] as List<dynamic>?)
      //     ?.map((e) => varshaphalaYearLordFromString(e))
      //     .toList() ??
      //     [],
      planetSmall: (json['planetSmall'] as List<dynamic>?)
          ?.map((e) => planetSmallFromString(e))
          .toList() ??
          [],
      planetDegree: json['planetDegree'] as List<dynamic>? ?? [],
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
    List<Chalit>? chalit,
    this.imageChalit = '',
    this.chalitImage = '',
    List<Chalit>? sun,
    D10Image? imageSun,
    D10Image? sunImage,
    List<Chalit>? moon,
    D10Image? imageMoon,
    D10Image? moonImage,
    List<Chalit>? d1,
    D10Image? imageD1,
    D10Image? d1Image,
    List<Chalit>? d2,
    D10Image? imageD2,
    D10Image? d2Image,
    List<Chalit>? d3,
    D10Image? imageD3,
    D10Image? d3Image,
    List<Chalit>? d4,
    D10Image? imageD4,
    D10Image? d4Image,
    List<Chalit>? d5,
    D10Image? imageD5,
    D10Image? d5Image,
    List<Chalit>? d7,
    D10Image? imageD7,
    D10Image? d7Image,
    List<Chalit>? d8,
    D10Image? imageD8,
    D10Image? d8Image,
    List<Chalit>? d9,
    D10Image? imageD9,
    D10Image? d9Image,
    List<Chalit>? d10,
    D10Image? imageD10,
    D10Image? d10Image,
    List<Chalit>? d12,
    D10Image? imageD12,
    D10Image? d12Image,
    List<Chalit>? d16,
    D10Image? imageD16,
    D10Image? d16Image,
    List<Chalit>? d20,
    D10Image? imageD20,
    D10Image? d20Image,
    List<Chalit>? d24,
    D10Image? imageD24,
    D10Image? d24Image,
    List<Chalit>? d27,
    D10Image? imageD27,
    D10Image? d27Image,
    List<Chalit>? d30,
    D10Image? imageD30,
    D10Image? d30Image,
    List<Chalit>? d40,
    D10Image? imageD40,
    D10Image? d40Image,
    List<Chalit>? d45,
    D10Image? imageD45,
    D10Image? d45Image,
    List<Chalit>? d60,
    D10Image? imageD60,
    D10Image? d60Image,
  }) : chalit = chalit ?? [],
        sun = sun ?? [],
        imageSun = imageSun ?? D10Image(),
        sunImage = sunImage ?? D10Image(),
        moon = moon ?? [],
        imageMoon = imageMoon ?? D10Image(),
        moonImage = moonImage ?? D10Image(),
        d1 = d1 ?? [],
        imageD1 = imageD1 ?? D10Image(),
        d1Image = d1Image ?? D10Image(),
        d2 = d2 ?? [],
        imageD2 = imageD2 ?? D10Image(),
        d2Image = d2Image ?? D10Image(),
        d3 = d3 ?? [],
        imageD3 = imageD3 ?? D10Image(),
        d3Image = d3Image ?? D10Image(),
        d4 = d4 ?? [],
        imageD4 = imageD4 ?? D10Image(),
        d4Image = d4Image ?? D10Image(),
        d5 = d5 ?? [],
        imageD5 = imageD5 ?? D10Image(),
        d5Image = d5Image ?? D10Image(),
        d7 = d7 ?? [],
        imageD7 = imageD7 ?? D10Image(),
        d7Image = d7Image ?? D10Image(),
        d8 = d8 ?? [],
        imageD8 = imageD8 ?? D10Image(),
        d8Image = d8Image ?? D10Image(),
        d9 = d9 ?? [],
        imageD9 = imageD9 ?? D10Image(),
        d9Image = d9Image ?? D10Image(),
        d10 = d10 ?? [],
        imageD10 = imageD10 ?? D10Image(),
        d10Image = d10Image ?? D10Image(),
        d12 = d12 ?? [],
        imageD12 = imageD12 ?? D10Image(),
        d12Image = d12Image ?? D10Image(),
        d16 = d16 ?? [],
        imageD16 = imageD16 ?? D10Image(),
        d16Image = d16Image ?? D10Image(),
        d20 = d20 ?? [],
        imageD20 = imageD20 ?? D10Image(),
        d20Image = d20Image ?? D10Image(),
        d24 = d24 ?? [],
        imageD24 = imageD24 ?? D10Image(),
        d24Image = d24Image ?? D10Image(),
        d27 = d27 ?? [],
        imageD27 = imageD27 ?? D10Image(),
        d27Image = d27Image ?? D10Image(),
        d30 = d30 ?? [],
        imageD30 = imageD30 ?? D10Image(),
        d30Image = d30Image ?? D10Image(),
        d40 = d40 ?? [],
        imageD40 = imageD40 ?? D10Image(),
        d40Image = d40Image ?? D10Image(),
        d45 = d45 ?? [],
        imageD45 = imageD45 ?? D10Image(),
        d45Image = d45Image ?? D10Image(),
        d60 = d60 ?? [],
        imageD60 = imageD60 ?? D10Image(),
        d60Image = d60Image ?? D10Image();

  factory Charts.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Charts();

    List<Chalit> parseChalitList(String key) =>
        (json[key] as List<dynamic>?)
            ?.map((e) => Chalit.fromJson(e))
            .toList() ??
            [];

    D10Image parseImage(String key) =>
        json[key] != null ? D10Image.fromJson(json[key]) : D10Image();

    return Charts(
      chalit: parseChalitList('chalit'),
      imageChalit: json['imageChalit'] as String? ?? '',
      chalitImage: json['chalitImage'] as String? ?? '',
      sun: parseChalitList('sun'),
      imageSun: parseImage('imageSun'),
      sunImage: parseImage('sunImage'),
      moon: parseChalitList('moon'),
      imageMoon: parseImage('imageMoon'),
      moonImage: parseImage('moonImage'),
      d1: parseChalitList('d1'),
      imageD1: parseImage('imageD1'),
      d1Image: parseImage('d1Image'),
      d2: parseChalitList('d2'),
      imageD2: parseImage('imageD2'),
      d2Image: parseImage('d2Image'),
      d3: parseChalitList('d3'),
      imageD3: parseImage('imageD3'),
      d3Image: parseImage('d3Image'),
      d4: parseChalitList('d4'),
      imageD4: parseImage('imageD4'),
      d4Image: parseImage('d4Image'),
      d5: parseChalitList('d5'),
      imageD5: parseImage('imageD5'),
      d5Image: parseImage('d5Image'),
      d7: parseChalitList('d7'),
      imageD7: parseImage('imageD7'),
      d7Image: parseImage('d7Image'),
      d8: parseChalitList('d8'),
      imageD8: parseImage('imageD8'),
      d8Image: parseImage('d8Image'),
      d9: parseChalitList('d9'),
      imageD9: parseImage('imageD9'),
      d9Image: parseImage('d9Image'),
      d10: parseChalitList('d10'),
      imageD10: parseImage('imageD10'),
      d10Image: parseImage('d10Image'),
      d12: parseChalitList('d12'),
      imageD12: parseImage('imageD12'),
      d12Image: parseImage('d12Image'),
      d16: parseChalitList('d16'),
      imageD16: parseImage('imageD16'),
      d16Image: parseImage('d16Image'),
      d20: parseChalitList('d20'),
      imageD20: parseImage('imageD20'),
      d20Image: parseImage('d20Image'),
      d24: parseChalitList('d24'),
      imageD24: parseImage('imageD24'),
      d24Image: parseImage('d24Image'),
      d27: parseChalitList('d27'),
      imageD27: parseImage('imageD27'),
      d27Image: parseImage('d27Image'),
      d30: parseChalitList('d30'),
      imageD30: parseImage('imageD30'),
      d30Image: parseImage('d30Image'),
      d40: parseChalitList('d40'),
      imageD40: parseImage('imageD40'),
      d40Image: parseImage('d40Image'),
      d45: parseChalitList('d45'),
      imageD45: parseImage('imageD45'),
      d45Image: parseImage('d45Image'),
      d60: parseChalitList('d60'),
      imageD60: parseImage('imageD60'),
      d60Image: parseImage('d60Image'),
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
  VENUS,
}

enum PlanetSmall { JU, KE, MA, ME, MO, RA, SA, SU, VE }

enum AscendantEnum {
  Aries,
  Taurus,
  Gemini,
  Cancer,
  Leo,
  Virgo,
  Libra,
  Scorpio,
  Sagittarius,
  Capricorn,
  Aquarius,
  Pisces,
}

AscendantEnum? parseAscendantEnum(String? sign) {
  if (sign == null) return null;

  final hindiToEnumMap = {
    'मेष': AscendantEnum.Aries,
    'वृषभ': AscendantEnum.Taurus,
    'मिथुन': AscendantEnum.Gemini,
    'कर्क': AscendantEnum.Cancer,
    'सिंह': AscendantEnum.Leo,
    'कन्या': AscendantEnum.Virgo,
    'तुला': AscendantEnum.Libra,
    'वृश्चिक': AscendantEnum.Scorpio,
    'धनु': AscendantEnum.Sagittarius,
    'मकर': AscendantEnum.Capricorn,
    'कुंभ': AscendantEnum.Aquarius,
    'मीन': AscendantEnum.Pisces,
  };

  return hindiToEnumMap[sign.trim()];
}


VarshaphalaYearLord varshaphalaYearLordFromString(String value) =>
    VarshaphalaYearLord.values.firstWhere((e) => e.name == value);

PlanetSmall planetSmallFromString(String value) =>
    PlanetSmall.values.firstWhere((e) => e.name == value);

AscendantEnum ascendantEnumFromString(String value) =>
    AscendantEnum.values.firstWhere((e) => e.name == value);

/// KP SYStem
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
      planets: (json['planets'] as List)
          .map((e) => KpSystemPlanet.fromJson(e))
          .toList(),
      houseCusps: (json['houseCusps'] as List)
          .map((e) => HouseCusp.fromJson(e))
          .toList(),
      birthChart: (json['birthChart'] as List)
          .map((e) => BirthChart.fromJson(e))
          .toList(),
      houseSignificator: (json['houseSignificator'] as List)
          .map((e) => HouseSignificator.fromJson(e))
          .toList(),
      planetSignificator: (json['planetSignificator'] as List)
          .map((e) => PlanetSignificator.fromJson(e))
          .toList(),
    );
  }
}

class BirthChart {
  List<int>? signs;
  List<String>? planets;
  List<PlanetSmall>? planetsSmall;
  List<int>? planetSigns;

  BirthChart({this.signs, this.planets, this.planetsSmall, this.planetSigns});

  factory BirthChart.fromJson(Map<String, dynamic> json) {
    List<int>? parseIntList(dynamic list) {
      if (list is List) {
        return list.whereType<int>().toList();
      }
      return null;
    }

    List<String>? parseStringList(dynamic list) {
      if (list is List) {
        return list.whereType<String>().toList();
      }
      return null;
    }

    List<PlanetSmall>? parsePlanetSmallList(dynamic list) {
      if (list is List) {
        return list
            .map((e) {
          if (e is String) {
            try {
              return PlanetSmall.values.byName(e);
            } catch (_) {
              return null;
            }
          }
          return null;
        })
            .whereType<PlanetSmall>()
            .toList();
      }
      return null;
    }

    return BirthChart(
      signs: parseIntList(json['signs']),
      planets: parseStringList(json['planets']),
      planetsSmall: parsePlanetSmallList(json['planets_small']),
      planetSigns: parseIntList(json['planet_signs']),
    );
  }
}

class HouseCusp {
  int? houseId;
  double? cuspFullDegree;
  String? formattedDegree;
  int? signId;
  AscendantEnum? sign;
  String? signLord;
  String? nakshatra;
  String? nakshatraLord;
  String? subLord;
  String? subSubLord;

  HouseCusp({
    this.houseId,
    this.cuspFullDegree,
    this.formattedDegree,
    this.signId,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.subLord,
    this.subSubLord,
  });

  factory HouseCusp.fromJson(Map<String, dynamic> json) {
    return HouseCusp(
      houseId: json['house_id'] as int?,
      cuspFullDegree: (json['cusp_full_degree'] != null)
          ? (json['cusp_full_degree'] as num).toDouble()
          : null,
      formattedDegree: json['formatted_degree'] as String?,
      signId: json['sign_id'] as int?,
      sign: _parseEnum<AscendantEnum>(json['sign'], AscendantEnum.values),
      signLord: json['sign_lord'] as String?,
      nakshatra: json['nakshatra'] as String?,
      nakshatraLord: json['nakshatra_lord'] as String?,
      subLord: json['sub_lord'] as String?,
      subSubLord: json['sub_sub_lord'] as String?,
    );
  }

  static T? _parseEnum<T>(String? name, List<T> values) {
    if (name == null) return null;
    try {
      return values.firstWhere((e) => e.toString().split('.').last == name);
    } catch (_) {
      return null;
    }
  }
}

class HouseSignificator {
  int? houseId;
  List<String>? significators;

  HouseSignificator({this.houseId, this.significators});

  factory HouseSignificator.fromJson(Map<String, dynamic> json) {
    List<String>? parseStringList(dynamic list) {
      if (list is List) {
        return list.whereType<String>().toList();
      }
      return null;
    }

    return HouseSignificator(
      houseId: json['house_id'] as int?,
      significators: parseStringList(json['significators']),
    );
  }
}

class PlanetSignificator {
  int? planetId;
  String? planetName;
  List<int>? significators;

  PlanetSignificator({this.planetId, this.planetName, this.significators});

  factory PlanetSignificator.fromJson(Map<String, dynamic> json) {
    List<int>? parseIntList(dynamic list) {
      if (list is List) {
        return list.whereType<int>().toList();
      }
      return null;
    }

    return PlanetSignificator(
      planetId: json['planet_id'] as int?,
      planetName: json['planet_name'] as String?,
      significators: parseIntList(json['significators']),
    );
  }
}

class KpSystemPlanet {
  String? planetId;
  String? planetName;
  double? degree;
  String? formattedDegree;
  bool? isRetro;
  double? normDegree;
  String? formattedNormDegree;
  int? house;
  AscendantEnum? sign;
  String? signLord;
  String? nakshatra;
  String? nakshatraLord;
  int? charan;
  String? subLord;
  String? subSubLord;

  KpSystemPlanet({
    this.planetId,
    this.planetName,
    this.degree,
    this.formattedDegree,
    this.isRetro,
    this.normDegree,
    this.formattedNormDegree,
    this.house,
    this.sign,
    this.signLord,
    this.nakshatra,
    this.nakshatraLord,
    this.charan,
    this.subLord,
    this.subSubLord,
  });

  factory KpSystemPlanet.fromJson(Map<String, dynamic> json) {
    return KpSystemPlanet(
      planetId: json['planetId'] as String?,
      planetName: json['planet_name'] as String?,
      degree: (json['degree'] != null)
          ? (json['degree'] as num).toDouble()
          : null,
      formattedDegree: json['formatted_degree'] as String?,
      isRetro: json['is_retro'] as bool?,
      normDegree: (json['normDegree'] != null)
          ? (json['normDegree'] as num).toDouble()
          : null,
      formattedNormDegree: json['formattedNormDegree'] as String?,
      house: json['house'] as int?,
      sign: _parseEnum<AscendantEnum>(json['sign'], AscendantEnum.values),
      signLord: json['sign_lord'] as String?,
      nakshatra: json['nakshatra'] as String?,
      nakshatraLord: json['nakshatra_lord'] as String?,
      charan: json['charan'] as int?,
      subLord: json['sub_lord'] as String?,
      subSubLord: json['sub_sub_lord'] as String?,
    );
  }

  static T? _parseEnum<T>(String? name, List<T> values) {
    if (name == null) return null;
    try {
      return values.firstWhere((e) => e.toString().split('.').last == name);
    } catch (_) {
      return null;
    }
  }
}

/// Astakvarga
class Ashtakvarga {
  PlanetAshtak? planetAshtak;
  Sarvashtak? sarvashtak;

  Ashtakvarga({this.planetAshtak, this.sarvashtak});

  factory Ashtakvarga.fromJson(Map<String, dynamic> json) {
    return Ashtakvarga(
      planetAshtak: json['planetAshtak'] != null
          ? PlanetAshtak.fromJson(json['planetAshtak'])
          : null,
      sarvashtak: json['sarvashtak'] != null
          ? Sarvashtak.fromJson(json['sarvashtak'])
          : null,
    );
  }
}

class PlanetAshtak {
  Sarvashtak? sun;
  Sarvashtak? moon;
  Sarvashtak? mars;
  Sarvashtak? mercury;
  Sarvashtak? jupiter;
  Sarvashtak? venus;
  Sarvashtak? saturn;

  PlanetAshtak({
    this.sun,
    this.moon,
    this.mars,
    this.mercury,
    this.jupiter,
    this.venus,
    this.saturn,
  });

  factory PlanetAshtak.fromJson(Map<String, dynamic> json) {
    return PlanetAshtak(
      sun: json['sun'] != null ? Sarvashtak.fromJson(json['sun']) : null,
      moon: json['moon'] != null ? Sarvashtak.fromJson(json['moon']) : null,
      mars: json['mars'] != null ? Sarvashtak.fromJson(json['mars']) : null,
      mercury: json['mercury'] != null
          ? Sarvashtak.fromJson(json['mercury'])
          : null,
      jupiter: json['jupiter'] != null
          ? Sarvashtak.fromJson(json['jupiter'])
          : null,
      venus: json['venus'] != null ? Sarvashtak.fromJson(json['venus']) : null,
      saturn: json['saturn'] != null
          ? Sarvashtak.fromJson(json['saturn'])
          : null,
    );
  }
}

class Sarvashtak {
  AshtakVarga? ashtakVarga;
  Map<String, AshtakPoint>? ashtakPoints;

  Sarvashtak({this.ashtakVarga, this.ashtakPoints});

  factory Sarvashtak.fromJson(Map<String, dynamic> json) {
    return Sarvashtak(
      ashtakVarga: json['ashtak_varga'] != null
          ? AshtakVarga.fromJson(json['ashtak_varga'])
          : null,
      ashtakPoints: json['ashtak_points'] != null
          ? (json['ashtak_points'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, AshtakPoint.fromJson(value)),
      )
          : null,
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
    this.sun = 0,
    this.moon = 0,
    this.mars = 0,
    this.mercury = 0,
    this.jupiter = 0,
    this.venus = 0,
    this.saturn = 0,
    this.ascendant = 0,
    this.total = 0,
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
  AscendantEnum? sign;
  int signId;

  AshtakVarga({this.type = '', this.planet, this.sign, this.signId = 0});

  factory AshtakVarga.fromJson(Map<String, dynamic> json) {
    return AshtakVarga(
      type: json['type'] as String? ?? '',
      planet: json['planet'] as String?,
      sign: parseAscendantEnum(json['sign']),
      signId: json['sign_id'] as int? ?? 0,
    );
  }
}

/// Dosha
class Dosha {
  Kalsarpa? kalsarpa;
  Manglik? manglik;
  Sadhesati? sadhesati;
  PitraDosha? pitraDosha;

  Dosha({this.kalsarpa, this.manglik, this.sadhesati, this.pitraDosha});

  factory Dosha.fromJson(Map<String, dynamic> json) {
    return Dosha(
      kalsarpa: json['kalsarpa'] != null
          ? Kalsarpa.fromJson(json['kalsarpa'])
          : null,
      manglik: json['manglik'] != null
          ? Manglik.fromJson(json['manglik'])
          : null,
      sadhesati: json['sadhesati'] != null
          ? Sadhesati.fromJson(json['sadhesati'])
          : null,
      pitraDosha: json['pitraDosha'] != null
          ? PitraDosha.fromJson(json['pitraDosha'])
          : null,
    );
  }
}

class Kalsarpa {
  bool present;
  String type;
  String oneLine;
  String name;
  KalsarpaReport? report;

  Kalsarpa({
    this.present = false,
    this.type = '',
    this.oneLine = '',
    this.name = '',
    this.report,
  });

  factory Kalsarpa.fromJson(Map<String, dynamic> json) {
    return Kalsarpa(
      present: json['present'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      oneLine: json['oneLine'] as String? ?? '',
      name: json['name'] as String? ?? '',
      report: json['report'] != null
          ? KalsarpaReport.fromJson(json['report'])
          : null,
    );
  }
}

class KalsarpaReport {
  int houseId;
  String report;

  KalsarpaReport({this.houseId = 0, this.report = ''});

  factory KalsarpaReport.fromJson(Map<String, dynamic> json) {
    return KalsarpaReport(
      houseId: json['houseId'] as int? ?? 0,
      report: json['report'] as String? ?? '',
    );
  }
}

class Manglik {
  ManglikPresentRule? manglikPresentRule;
  List<String> manglikCancelRule;
  bool isMarsManglikCancelled;
  String manglikStatus;
  int percentageManglikPresent;
  int percentageManglikAfterCancellation;
  String manglikReport;
  bool isPresent;

  Manglik({
    this.manglikPresentRule,
    this.manglikCancelRule = const [],
    this.isMarsManglikCancelled = false,
    this.manglikStatus = '',
    this.percentageManglikPresent = 0,
    this.percentageManglikAfterCancellation = 0,
    this.manglikReport = '',
    this.isPresent = false,
  });

  factory Manglik.fromJson(Map<String, dynamic> json) {
    return Manglik(
      manglikPresentRule: json['manglikPresentRule'] != null
          ? ManglikPresentRule.fromJson(json['manglikPresentRule'])
          : null,
      manglikCancelRule: json['manglikCancelRule'] != null
          ? List<String>.from(json['manglikCancelRule'])
          : [],
      isMarsManglikCancelled: json['isMarsManglikCancelled'] as bool? ?? false,
      manglikStatus: json['manglikStatus'] as String? ?? '',
      percentageManglikPresent: json['percentageManglikPresent'] as int? ?? 0,
      percentageManglikAfterCancellation:
      json['percentageManglikAfterCancellation'] as int? ?? 0,
      manglikReport: json['manglikReport'] as String? ?? '',
      isPresent: json['isPresent'] as bool? ?? false,
    );
  }
}

class ManglikPresentRule {
  List<String> basedOnAspect;
  List<String> basedOnHouse;

  ManglikPresentRule({
    this.basedOnAspect = const [],
    this.basedOnHouse = const [],
  });

  factory ManglikPresentRule.fromJson(Map<String, dynamic> json) {
    return ManglikPresentRule(
      basedOnAspect: json['basedOnAspect'] != null
          ? List<String>.from(json['basedOnAspect'])
          : [],
      basedOnHouse: json['basedOnHouse'] != null
          ? List<String>.from(json['basedOnHouse'])
          : [],
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
    this.whatIsPitriDosha = '',
    this.isPitriDoshaPresent = false,
    this.rulesMatched = const [],
    this.conclusion = '',
    this.remedies,
    this.effects,
  });

  factory PitraDosha.fromJson(Map<String, dynamic> json) {
    return PitraDosha(
      whatIsPitriDosha: json['whatIsPitriDosha'] as String? ?? '',
      isPitriDoshaPresent: json['isPitriDoshaPresent'] as bool? ?? false,
      rulesMatched: json['rulesMatched'] ?? [],
      conclusion: json['conclusion'] as String? ?? '',
      remedies: json['remedies'],
      effects: json['effects'],
    );
  }
}

class Sadhesati {
  CurrentStatus? currentStatus;
  List<LifeDetail> lifeDetails;

  Sadhesati({this.currentStatus, this.lifeDetails = const []});

  factory Sadhesati.fromJson(Map<String, dynamic> json) {
    return Sadhesati(
      currentStatus: json['currentStatus'] != null
          ? CurrentStatus.fromJson(json['currentStatus'])
          : null,
      lifeDetails: json['lifeDetails'] != null
          ? (json['lifeDetails'] as List)
          .map((e) => LifeDetail.fromJson(e))
          .toList()
          : [],
    );
  }
}

class CurrentStatus {
  String considerationDate;
  bool isSaturnRetrograde;
  AscendantEnum? moonSign;
  AscendantEnum? saturnSign;
  String isUndergoingSadhesati;
  bool sadhesatiStatus;
  String whatIsSadhesati;

  CurrentStatus({
    this.considerationDate = '',
    this.isSaturnRetrograde = false,
    this.moonSign,
    this.saturnSign,
    this.isUndergoingSadhesati = '',
    this.sadhesatiStatus = false,
    this.whatIsSadhesati = '',
  });

  factory CurrentStatus.fromJson(Map<String, dynamic> json) {
    return CurrentStatus(
      considerationDate: json['consideration_date'] as String? ?? '',
      isSaturnRetrograde: json['is_saturn_retrograde'] as bool? ?? false,

      moonSign: parseAscendantEnum(json['moon_sign']),
        saturnSign: parseAscendantEnum(json['saturn_sign']),
      isUndergoingSadhesati: json['is_undergoing_sadhesati'] as String? ?? '',
      sadhesatiStatus: json['sadhesati_status'] as bool? ?? false,
      whatIsSadhesati: json['what_is_sadhesati'] as String? ?? '',
    );
  }
}

class LifeDetail {
  AscendantEnum? moonSign;
  AscendantEnum? saturnSign;
  bool isSaturnRetrograde;
  Type? type;
  String millisecond;
  String date;
  String summary;

  LifeDetail({
    this.moonSign,
    this.saturnSign,
    this.isSaturnRetrograde = false,
    this.type,
    this.millisecond = '',
    this.date = '',
    this.summary = '',
  });

  factory LifeDetail.fromJson(Map<String, dynamic> json) {
    return LifeDetail(
      moonSign: parseAscendantEnum(json['moon_sign']),
        saturnSign: parseAscendantEnum(json['saturn_sign']),
      isSaturnRetrograde: json['is_saturn_retrograde'] as bool? ?? false,
      type: json['type'] != null ? Type.values.byName(json['type']) : null,
      millisecond: json['millisecond'] as String? ?? '',
      date: json['date'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }
}

enum Type { PEAK_START, RISING_END, RISING_START, SETTING_END, SETTING_START }

/// Panchang
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
      basic: Basic.fromJson(json['basic']),
      advanced: Advanced.fromJson(json['advanced']),
      horaMuhurta: HoraMuhurta.fromJson(json['horaMuhurta']),
      chaughadiya: PanchangChaughadiya.fromJson(json['chaughadiya']),
    );
  }
}

class Basic {
  String? day;
  String? tithi;
  String? nakshatra;
  String? yog;
  String? karan;
  String? sunrise;
  String? sunset;
  String? vedicSunrise;
  String? vedicSunset;

  Basic({
    this.day,
    this.tithi,
    this.nakshatra,
    this.yog,
    this.karan,
    this.sunrise,
    this.sunset,
    this.vedicSunrise,
    this.vedicSunset,
  });

  factory Basic.fromJson(Map<String, dynamic> json) {
    return Basic(
      day: json['day'] as String?,
      tithi: json['tithi'] as String?,
      nakshatra: json['nakshatra'] as String?,
      yog: json['yog'] as String?,
      karan: json['karan'] as String?,
      sunrise: json['sunrise'] as String?,
      sunset: json['sunset'] as String?,
      vedicSunrise: json['vedicSunrise'] as String?,
      vedicSunset: json['vedicSunset'] as String?,
    );
  }
}

class Advanced {
  String? day;
  String? sunrise;
  String? sunset;
  String? moonrise;
  String? moonset;
  String? vedicSunrise;
  String? vedicSunset;
  Tithi? tithi;
  AdvancedNakshatra? nakshatra;
  Yog? yog;
  Karan? karan;
  HinduMaah? hinduMaah;
  String? paksha;
  String? ritu;
  AscendantEnum? sunSign;
  AscendantEnum? moonSign;
  String? ayana;
  String? panchangYog;
  int? vikramSamvat;
  int? shakaSamvat;
  String? vkramSamvatName;
  String? shakaSamvatName;
  String? dishaShool;
  String? dishaShoolRemedies;
  NakShool? nakShool;
  String? moonNivas;
  AbhijitMuhurta? abhijitMuhurta;
  AbhijitMuhurta? rahukaal;
  AbhijitMuhurta? guliKaal;
  AbhijitMuhurta? yamghantKaal;

  Advanced({
    this.day,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.vedicSunrise,
    this.vedicSunset,
    this.tithi,
    this.nakshatra,
    this.yog,
    this.karan,
    this.hinduMaah,
    this.paksha,
    this.ritu,
    this.sunSign,
    this.moonSign,
    this.ayana,
    this.panchangYog,
    this.vikramSamvat,
    this.shakaSamvat,
    this.vkramSamvatName,
    this.shakaSamvatName,
    this.dishaShool,
    this.dishaShoolRemedies,
    this.nakShool,
    this.moonNivas,
    this.abhijitMuhurta,
    this.rahukaal,
    this.guliKaal,
    this.yamghantKaal,
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
      tithi: json['tithi'] != null ? Tithi.fromJson(json['tithi']) : null,
      nakshatra: json['nakshatra'] != null
          ? AdvancedNakshatra.fromJson(json['nakshatra'])
          : null,
      yog: json['yog'] != null ? Yog.fromJson(json['yog']) : null,
      karan: json['karan'] != null ? Karan.fromJson(json['karan']) : null,
      hinduMaah: json['hinduMaah'] != null
          ? HinduMaah.fromJson(json['hinduMaah'])
          : null,
      paksha: json['paksha'] as String? ?? '',
      ritu: json['ritu'] as String? ?? '',
      sunSign: json['sunSign'] != null
          ? AscendantEnum.values.byName(json['sunSign'])
          : null,
      moonSign: json['moonSign'] != null
          ? AscendantEnum.values.byName(json['moonSign'])
          : null,
      ayana: json['ayana'] as String? ?? '',
      panchangYog: json['panchangYog'] as String? ?? '',
      vikramSamvat: json['vikramSamvat'] as int? ?? 0,
      shakaSamvat: json['shakaSamvat'] as int? ?? 0,
      vkramSamvatName: json['vkramSamvatName'] as String? ?? '',
      shakaSamvatName: json['shakaSamvatName'] as String? ?? '',
      dishaShool: json['dishaShool'] as String? ?? '',
      dishaShoolRemedies: json['dishaShoolRemedies'] as String? ?? '',
      nakShool: json['nakShool'] != null
          ? NakShool.fromJson(json['nakShool'])
          : null,
      moonNivas: json['moonNivas'] as String? ?? '',
      abhijitMuhurta: json['abhijitMuhurta'] != null
          ? AbhijitMuhurta.fromJson(json['abhijitMuhurta'])
          : null,
      rahukaal: json['rahukaal'] != null
          ? AbhijitMuhurta.fromJson(json['rahukaal'])
          : null,
      guliKaal: json['guliKaal'] != null
          ? AbhijitMuhurta.fromJson(json['guliKaal'])
          : null,
      yamghantKaal: json['yamghantKaal'] != null
          ? AbhijitMuhurta.fromJson(json['yamghantKaal'])
          : null,
    );
  }
}

class Tithi {
  TithiDetails? details;
  EndTime? endTime;
  int? endTimeMs;

  Tithi({this.details, this.endTime, this.endTimeMs});

  factory Tithi.fromJson(Map<String, dynamic> json) {
    return Tithi(
      details: json['details'] != null
          ? TithiDetails.fromJson(json['details'])
          : null,
      endTime: json['endTime'] != null
          ? EndTime.fromJson(json['endTime'])
          : null,
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class TithiDetails {
  int? tithiNumber;
  String? tithiName;
  String? special;
  String? summary;
  String? deity;

  TithiDetails({
    this.tithiNumber,
    this.tithiName,
    this.special,
    this.summary,
    this.deity,
  });

  factory TithiDetails.fromJson(Map<String, dynamic> json) {
    return TithiDetails(
      tithiNumber: json['tithiNumber'] as int? ?? 0,
      tithiName: json['tithiName'] as String? ?? '',
      special: json['special'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
    );
  }
}

class Yog {
  YogDetails? details;
  EndTime? endTime;
  int endTimeMs;

  Yog({this.details, this.endTime, this.endTimeMs = 0});

  factory Yog.fromJson(Map<String, dynamic> json) {
    return Yog(
      details: json['details'] != null
          ? YogDetails.fromJson(json['details'])
          : null,
      endTime: json['endTime'] != null
          ? EndTime.fromJson(json['endTime'])
          : null,
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
    this.yogNumber = 0,
    this.yogName = '',
    this.special = '',
    this.meaning = '',
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

class AdvancedNakshatra {
  NakshatraDetails? details;
  EndTime? endTime;
  int endTimeMs;

  AdvancedNakshatra({this.details, this.endTime, this.endTimeMs = 0});

  factory AdvancedNakshatra.fromJson(Map<String, dynamic> json) {
    return AdvancedNakshatra(
      details: json['details'] != null
          ? NakshatraDetails.fromJson(json['details'])
          : null,
      endTime: json['endTime'] != null
          ? EndTime.fromJson(json['endTime'])
          : null,
      endTimeMs: json['endTimeMs'] as int? ?? 0,
    );
  }
}

class NakshatraDetails {
  int nakNumber;
  String nakName;
  String ruler;
  String deity;
  String special;
  String summary;

  NakshatraDetails({
    this.nakNumber = 0,
    this.nakName = '',
    this.ruler = '',
    this.deity = '',
    this.special = '',
    this.summary = '',
  });

  factory NakshatraDetails.fromJson(Map<String, dynamic> json) {
    return NakshatraDetails(
      nakNumber: json['nakNumber'] as int? ?? 0,
      nakName: json['nakName'] as String? ?? '',
      ruler: json['ruler'] as String? ?? '',
      deity: json['deity'] as String? ?? '',
      special: json['special'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }
}

class Karan {
  KaranDetails? details;
  EndTime? endTime;
  int endTimeMs;

  Karan({this.details, this.endTime, this.endTimeMs = 0});

  factory Karan.fromJson(Map<String, dynamic> json) {
    return Karan(
      details: json['details'] != null
          ? KaranDetails.fromJson(json['details'])
          : null,
      endTime: json['endTime'] != null
          ? EndTime.fromJson(json['endTime'])
          : null,
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
    this.karanNumber = 0,
    this.karanName = '',
    this.special = '',
    this.deity = '',
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

class HinduMaah {
  bool adhikStatus;
  String purnimanta;
  String amanta;
  int amantaId;
  int purnimantaId;

  HinduMaah({
    this.adhikStatus = false,
    this.purnimanta = '',
    this.amanta = '',
    this.amantaId = 0,
    this.purnimantaId = 0,
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

class NakShool {
  String direction;
  String remedies;

  NakShool({this.direction = '', this.remedies = ''});

  factory NakShool.fromJson(Map<String, dynamic> json) {
    return NakShool(
      direction: json['direction'] as String? ?? '',
      remedies: json['remedies'] as String? ?? '',
    );
  }
}

class AbhijitMuhurta {
  String start;
  String end;

  AbhijitMuhurta({this.start = '', this.end = ''});

  factory AbhijitMuhurta.fromJson(Map<String, dynamic> json) {
    return AbhijitMuhurta(
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

class EndTime {
  int hour;
  int minute;
  int second;

  EndTime({this.hour = 0, this.minute = 0, this.second = 0});

  factory EndTime.fromJson(Map<String, dynamic> json) {
    return EndTime(
      hour: json['hour'] as int? ?? 0,
      minute: json['minute'] as int? ?? 0,
      second: json['second'] as int? ?? 0,
    );
  }
}

class PanchangChaughadiya {
  ChaughadiyaChaughadiya? chaughadiya;

  PanchangChaughadiya({this.chaughadiya});

  factory PanchangChaughadiya.fromJson(Map<String, dynamic> json) {
    return PanchangChaughadiya(
      chaughadiya: json['chaughadiya'] != null
          ? ChaughadiyaChaughadiya.fromJson(json['chaughadiya'])
          : null,
    );
  }
}

class ChaughadiyaChaughadiya {
  List<ChaughadiyaDay> day;
  List<ChaughadiyaDay> night;

  ChaughadiyaChaughadiya({this.day = const [], this.night = const []});

  factory ChaughadiyaChaughadiya.fromJson(Map<String, dynamic> json) {
    return ChaughadiyaChaughadiya(
      day: json['day'] != null
          ? (json['day'] as List)
          .map((e) => ChaughadiyaDay.fromJson(e))
          .toList()
          : [],
      night: json['night'] != null
          ? (json['night'] as List)
          .map((e) => ChaughadiyaDay.fromJson(e))
          .toList()
          : [],
    );
  }
}

class ChaughadiyaDay {
  String time;
  String muhurta;

  ChaughadiyaDay({this.time = '', this.muhurta = ''});

  factory ChaughadiyaDay.fromJson(Map<String, dynamic> json) {
    return ChaughadiyaDay(
      time: json['time'] as String? ?? '',
      muhurta: json['muhurta'] as String? ?? '',
    );
  }
}

class HoraMuhurta {
  Hora? hora;

  HoraMuhurta({this.hora});

  factory HoraMuhurta.fromJson(Map<String, dynamic> json) {
    return HoraMuhurta(
      hora: json['hora'] != null ? Hora.fromJson(json['hora']) : null,
    );
  }
}

class Hora {
  List<HoraDay> day;
  List<HoraDay> night;

  Hora({this.day = const [], this.night = const []});

  factory Hora.fromJson(Map<String, dynamic> json) {
    return Hora(
      day: json['day'] != null
          ? (json['day'] as List).map((e) => HoraDay.fromJson(e)).toList()
          : [],
      night: json['night'] != null
          ? (json['night'] as List).map((e) => HoraDay.fromJson(e)).toList()
          : [],
    );
  }
}

class HoraDay {
  String time;
  String hora;

  HoraDay({this.time = '', this.hora = ''});

  factory HoraDay.fromJson(Map<String, dynamic> json) {
    return HoraDay(
      time: json['time'] as String? ?? '',
      hora: json['hora'] as String? ?? '',
    );
  }
}

/// Report
class Reports {
  AscendantClass? ascendant;
  ReportsHouse? house;
  NatalChartInterpretation? planet;
  NatalChartInterpretation? natalChartInterpretation;

  Reports({
    this.ascendant,
    this.house,
    this.planet,
    this.natalChartInterpretation,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      ascendant: json['ascendant'] != null
          ? AscendantClass.fromJson(json['ascendant'])
          : null,
      house: json['house'] != null
          ? ReportsHouse.fromJson(json['house'])
          : null,
      planet: json['planet'] != null
          ? NatalChartInterpretation.fromJson(json['planet'])
          : null,
      natalChartInterpretation: json['natalChartInterpretation'] != null
          ? NatalChartInterpretation.fromJson(json['natalChartInterpretation'])
          : null,
    );
  }
}

class AscendantClass {
  AscendantEnum? sign;
  String characteristics;

  AscendantClass({this.sign, this.characteristics = ''});

  factory AscendantClass.fromJson(Map<String, dynamic> json) {
    return AscendantClass(
      sign: parseAscendantEnum(json['sign']),
      characteristics: json['characteristics'] as String? ?? '',
    );
  }
}

class ReportsHouse {
  HouseJupiter? sun;
  HouseJupiter? moon;
  HouseJupiter? mars;
  HouseJupiter? mercury;
  HouseJupiter? jupiter;
  HouseJupiter? venus;
  HouseJupiter? saturn;

  ReportsHouse({
    this.sun,
    this.moon,
    this.mars,
    this.mercury,
    this.jupiter,
    this.venus,
    this.saturn,
  });

  factory ReportsHouse.fromJson(Map<String, dynamic> json) {
    return ReportsHouse(
      sun: json['sun'] != null ? HouseJupiter.fromJson(json['sun']) : null,
      moon: json['moon'] != null ? HouseJupiter.fromJson(json['moon']) : null,
      mars: json['mars'] != null ? HouseJupiter.fromJson(json['mars']) : null,
      mercury: json['mercury'] != null
          ? HouseJupiter.fromJson(json['mercury'])
          : null,
      jupiter: json['jupiter'] != null
          ? HouseJupiter.fromJson(json['jupiter'])
          : null,
      venus: json['venus'] != null
          ? HouseJupiter.fromJson(json['venus'])
          : null,
      saturn: json['saturn'] != null
          ? HouseJupiter.fromJson(json['saturn'])
          : null,
    );
  }
}

class HouseJupiter {
  String planet;
  String houseReport;

  HouseJupiter({this.planet = '', this.houseReport = ''});

  factory HouseJupiter.fromJson(Map<String, dynamic> json) {
    return HouseJupiter(
      planet: json['planet'] as String? ?? '',
      houseReport: json['house_report'] as String? ?? '',
    );
  }
}

class NatalChartInterpretation {
  NatalChartInterpretation();

  factory NatalChartInterpretation.fromJson(Map<String, dynamic> json) {
    return NatalChartInterpretation();
  }
}

/// Dasha
class Dasha {
  Vimshottari? vimshottari;
  Char? char;
  Yogini? yogini;

  Dasha({this.vimshottari, this.char, this.yogini});

  factory Dasha.fromJson(Map<String, dynamic> json) {
    return Dasha(
      vimshottari: json['vimshottari'] != null
          ? Vimshottari.fromJson(json['vimshottari'])
          : null,
      char: json['char'] != null ? Char.fromJson(json['char']) : null,
      yogini: json['yogini'] != null ? Yogini.fromJson(json['yogini']) : null,
    );
  }
}

class Char {
  CharCurrent? current;

  Char({this.current});

  factory Char.fromJson(Map<String, dynamic> json) {
    return Char(
      current: json['current'] != null
          ? CharCurrent.fromJson(json['current'])
          : null,
    );
  }
}

class CharCurrent {
  String dashaDate;
  PurpleDasha? majorDasha;
  PurpleDasha? subDasha;
  PurpleDasha? subSubDasha;

  CharCurrent({
    this.dashaDate = '',
    this.majorDasha,
    this.subDasha,
    this.subSubDasha,
  });

  factory CharCurrent.fromJson(Map<String, dynamic> json) {
    return CharCurrent(
      dashaDate: json['dasha_date'] as String? ?? '',
      majorDasha: json['major_dasha'] != null
          ? PurpleDasha.fromJson(json['major_dasha'])
          : null,
      subDasha: json['sub_dasha'] != null
          ? PurpleDasha.fromJson(json['sub_dasha'])
          : null,
      subSubDasha: json['sub_sub_dasha'] != null
          ? PurpleDasha.fromJson(json['sub_sub_dasha'])
          : null,
    );
  }
}

class PurpleDasha {
  int signId;
  AscendantEnum? signName;
  String? duration;
  String startDate;
  String endDate;

  PurpleDasha({
    this.signId = 0,
    this.signName,
    this.duration,
    this.startDate = '',
    this.endDate = '',
  });

  factory PurpleDasha.fromJson(Map<String, dynamic> json) {
    return PurpleDasha(
      signId: json['sign_id'] as int? ?? 0,

        signName: parseAscendantEnum(json['sign_name']),
      duration: json['duration'] as String?,
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );
  }
}

class Vimshottari {
  VimshottariCurrent? current;

  Vimshottari({this.current});

  factory Vimshottari.fromJson(Map<String, dynamic> json) {
    return Vimshottari(
      current: json['current'] != null
          ? VimshottariCurrent.fromJson(json['current'])
          : null,
    );
  }
}

class VimshottariCurrent {
  Major? major;
  Major? minor;
  Major? subMinor;
  Major? subSubMinor;
  Major? subSubSubMinor;

  VimshottariCurrent({
    this.major,
    this.minor,
    this.subMinor,
    this.subSubMinor,
    this.subSubSubMinor,
  });

  factory VimshottariCurrent.fromJson(Map<String, dynamic> json) {
    return VimshottariCurrent(
      major: json['major'] != null ? Major.fromJson(json['major']) : null,
      minor: json['minor'] != null ? Major.fromJson(json['minor']) : null,
      subMinor: json['sub_minor'] != null
          ? Major.fromJson(json['sub_minor'])
          : null,
      subSubMinor: json['sub_sub_minor'] != null
          ? Major.fromJson(json['sub_sub_minor'])
          : null,
      subSubSubMinor: json['sub_sub_sub_minor'] != null
          ? Major.fromJson(json['sub_sub_sub_minor'])
          : null,
    );
  }
}

class Major {
  String planet;
  int planetId;
  String start;
  String end;

  Major({this.planet = '', this.planetId = 0, this.start = '', this.end = ''});

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      planet: json['planet'] as String? ?? '',
      planetId: json['planet_id'] as int? ?? 0,
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

class Yogini {
  YoginiCurrent? current;

  Yogini({this.current});

  factory Yogini.fromJson(Map<String, dynamic> json) {
    return Yogini(
      current: json['current'] != null
          ? YoginiCurrent.fromJson(json['current'])
          : null,
    );
  }
}

class YoginiCurrent {
  FluffyDasha? majorDasha;
  FluffyDasha? subDasha;
  FluffyDasha? subSubDasha;

  YoginiCurrent({this.majorDasha, this.subDasha, this.subSubDasha});

  factory YoginiCurrent.fromJson(Map<String, dynamic> json) {
    return YoginiCurrent(
      majorDasha: json['major_dasha'] != null
          ? FluffyDasha.fromJson(json['major_dasha'])
          : null,
      subDasha: json['sub_dasha'] != null
          ? FluffyDasha.fromJson(json['sub_dasha'])
          : null,
      subSubDasha: json['sub_sub_dasha'] != null
          ? FluffyDasha.fromJson(json['sub_sub_dasha'])
          : null,
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
    this.dashaId = 0,
    this.dashaName = '',
    this.duration,
    this.startDate = '',
    this.endDate = '',
  });

  factory FluffyDasha.fromJson(Map<String, dynamic> json) {
    return FluffyDasha(
      dashaId: json['dasha_id'] as int? ?? 0,
      dashaName: json['dasha_name'] as String? ?? '',
      duration: json['duration'] as String?,
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );
  }
}


/// Remedies Only
