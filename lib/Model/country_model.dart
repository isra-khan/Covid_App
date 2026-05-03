class CountryModel {
  final String country;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int todayRecovered;
  final int active;
  final int critical;
  final int tests;
  final int population;
  final num casesPerOneMillion;
  final num deathsPerOneMillion;
  final num activePerOneMillion;
  final num recoveredPerOneMillion;
  final num criticalPerOneMillion;
  final String flag;
  final String iso2;
  final String iso3;
  final double lat;
  final double long;
  final String continent;

  CountryModel({
    required this.country,
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.todayRecovered,
    required this.active,
    required this.critical,
    required this.tests,
    required this.population,
    required this.casesPerOneMillion,
    required this.deathsPerOneMillion,
    required this.activePerOneMillion,
    required this.recoveredPerOneMillion,
    required this.criticalPerOneMillion,
    required this.flag,
    required this.iso2,
    required this.iso3,
    required this.lat,
    required this.long,
    required this.continent,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final info = json['countryInfo'] as Map<String, dynamic>? ?? {};
    return CountryModel(
      country: json['country']?.toString() ?? '',
      cases: (json['cases'] ?? 0) as int,
      todayCases: (json['todayCases'] ?? 0) as int,
      deaths: (json['deaths'] ?? 0) as int,
      todayDeaths: (json['todayDeaths'] ?? 0) as int,
      recovered: (json['recovered'] ?? 0) as int,
      todayRecovered: (json['todayRecovered'] ?? 0) as int,
      active: (json['active'] ?? 0) as int,
      critical: (json['critical'] ?? 0) as int,
      tests: (json['tests'] ?? 0) as int,
      population: (json['population'] ?? 0) as int,
      casesPerOneMillion: (json['casesPerOneMillion'] ?? 0) as num,
      deathsPerOneMillion: (json['deathsPerOneMillion'] ?? 0) as num,
      activePerOneMillion: (json['activePerOneMillion'] ?? 0) as num,
      recoveredPerOneMillion: (json['recoveredPerOneMillion'] ?? 0) as num,
      criticalPerOneMillion: (json['criticalPerOneMillion'] ?? 0) as num,
      flag: info['flag']?.toString() ?? '',
      iso2: info['iso2']?.toString() ?? '',
      iso3: info['iso3']?.toString() ?? '',
      lat: (info['lat'] ?? 0).toDouble(),
      long: (info['long'] ?? 0).toDouble(),
      continent: json['continent']?.toString() ?? '',
    );
  }

  double get recoveryRate => cases == 0 ? 0 : (recovered / cases) * 100;
}
