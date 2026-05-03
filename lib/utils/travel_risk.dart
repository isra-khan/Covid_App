import 'package:covidapp/Model/country_model.dart';

enum TravelVerdict { safe, caution, avoid }

class TravelRiskResult {
  final TravelVerdict verdict;
  final double ratio;
  final String summary;
  TravelRiskResult(this.verdict, this.ratio, this.summary);
}

class TravelRisk {
  static TravelRiskResult assess(CountryModel origin, CountryModel destination) {
    final originActive = origin.activePerOneMillion.toDouble();
    final destActive = destination.activePerOneMillion.toDouble();
    final ratio =
        originActive == 0 ? (destActive == 0 ? 1 : 999) : destActive / originActive;

    TravelVerdict verdict;
    String summary;
    if (destActive < 500) {
      verdict = TravelVerdict.safe;
      summary =
          '${destination.country} has low active cases per million. Travel is reasonably safe.';
    } else if (ratio < 1.5 && destActive < 5000) {
      verdict = TravelVerdict.safe;
      summary =
          '${destination.country} has comparable or only slightly higher activity than ${origin.country}.';
    } else if (ratio < 3.0 || destActive < 10000) {
      verdict = TravelVerdict.caution;
      summary =
          '${destination.country} has notably higher active cases. Take precautions.';
    } else {
      verdict = TravelVerdict.avoid;
      summary =
          '${destination.country} has very high active cases compared to ${origin.country}. Reconsider travel.';
    }
    return TravelRiskResult(verdict, ratio.toDouble(), summary);
  }

  static String label(TravelVerdict v) {
    switch (v) {
      case TravelVerdict.safe:
        return 'Safe';
      case TravelVerdict.caution:
        return 'Caution';
      case TravelVerdict.avoid:
        return 'Avoid';
    }
  }
}
