import 'package:covidapp/Model/country_model.dart';

class VoiceQueryParser {
  static CountryModel? matchCountry(
      String transcript, List<CountryModel> countries) {
    if (transcript.trim().isEmpty || countries.isEmpty) return null;
    final t = transcript.toLowerCase();
    CountryModel? best;
    int bestLen = 0;
    for (final c in countries) {
      final name = c.country.toLowerCase();
      if (name.isEmpty) continue;
      if (t.contains(name) && name.length > bestLen) {
        best = c;
        bestLen = name.length;
      }
    }
    if (best != null) return best;
    for (final c in countries) {
      final iso = c.iso2.toLowerCase();
      if (iso.isNotEmpty && t.contains(' $iso ')) return c;
    }
    return null;
  }
}
