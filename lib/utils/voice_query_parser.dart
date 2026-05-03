import 'package:covidapp/Model/country_model.dart';

class VoiceQueryParser {
  static const _intentKeywords = {
    'case', 'cases', 'covid', 'corona', 'coronavirus', 'death', 'deaths',
    'recovered', 'stat', 'stats', 'statistics', 'show', 'tell', 'country',
    'in', 'for', 'about', 'data', 'numbers',
  };

  static CountryModel? matchCountry(
      String transcript, List<CountryModel> countries) {
    if (transcript.trim().isEmpty || countries.isEmpty) return null;
    final t = transcript.toLowerCase();
    final words = t.split(RegExp(r'[^a-z]+')).where((w) => w.isNotEmpty).toSet();
    final hasIntent = words.any(_intentKeywords.contains);
    if (!hasIntent) return null;

    CountryModel? best;
    int bestLen = 0;
    for (final c in countries) {
      final name = c.country.toLowerCase();
      if (name.isEmpty) continue;
      final pattern = RegExp('\\b${RegExp.escape(name)}\\b');
      if (pattern.hasMatch(t) && name.length > bestLen) {
        best = c;
        bestLen = name.length;
      }
    }
    return best;
  }
}
