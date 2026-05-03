import 'package:covidapp/Model/country_model.dart';

enum RiskLevel { low, moderate, high, critical }

class RiskResult {
  final double score;
  final RiskLevel level;
  RiskResult(this.score, this.level);
}

class RiskCalculator {
  static RiskResult compute({
    required CountryModel country,
    required int age,
    required bool hasComorbidities,
  }) {
    final activePerCapita = country.population == 0
        ? 0.0
        : (country.active / country.population) * 1000000;
    final caseFatality =
        country.cases == 0 ? 0.0 : (country.deaths / country.cases) * 100;

    final exposure =
        ((activePerCapita / 5000).clamp(0, 1) * 35).toDouble();
    final lethality = ((caseFatality / 5).clamp(0, 1) * 25).toDouble();
    final density =
        ((country.casesPerOneMillion / 200000).clamp(0, 1) * 15).toDouble();

    double ageFactor;
    if (age < 30) {
      ageFactor = 5;
    } else if (age < 50) {
      ageFactor = 10;
    } else if (age < 65) {
      ageFactor = 15;
    } else {
      ageFactor = 20;
    }

    final comorbidity = hasComorbidities ? 5.0 : 0.0;

    final score = (exposure + lethality + density + ageFactor + comorbidity)
        .clamp(0, 100)
        .toDouble();

    final level = score < 25
        ? RiskLevel.low
        : score < 50
            ? RiskLevel.moderate
            : score < 75
                ? RiskLevel.high
                : RiskLevel.critical;

    return RiskResult(score, level);
  }

  static String label(RiskLevel l) {
    switch (l) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.moderate:
        return 'Moderate';
      case RiskLevel.high:
        return 'High';
      case RiskLevel.critical:
        return 'Critical';
    }
  }
}
