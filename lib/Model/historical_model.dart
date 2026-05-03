class HistoricalModel {
  final List<DateTime> dates;
  final List<int> cases;
  final List<int> deaths;
  final List<int> recovered;

  HistoricalModel({
    required this.dates,
    required this.cases,
    required this.deaths,
    required this.recovered,
  });

  factory HistoricalModel.fromJson(Map<String, dynamic> json) {
    final timeline = json['timeline'] as Map<String, dynamic>? ?? json;
    final casesMap = (timeline['cases'] ?? {}) as Map<String, dynamic>;
    final deathsMap = (timeline['deaths'] ?? {}) as Map<String, dynamic>;
    final recoveredMap = (timeline['recovered'] ?? {}) as Map<String, dynamic>;

    final orderedKeys = casesMap.keys.toList();

    DateTime parseKey(String key) {
      final parts = key.split('/');
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final yearTwoDigits = int.parse(parts[2]);
      final year = yearTwoDigits + 2000;
      return DateTime(year, month, day);
    }

    return HistoricalModel(
      dates: orderedKeys.map(parseKey).toList(),
      cases: orderedKeys.map((k) => (casesMap[k] ?? 0) as int).toList(),
      deaths: orderedKeys.map((k) => (deathsMap[k] ?? 0) as int).toList(),
      recovered:
          orderedKeys.map((k) => (recoveredMap[k] ?? 0) as int).toList(),
    );
  }
}
