class SymptomInput {
  final bool fever;
  final bool dryCough;
  final bool fatigue;
  final bool lossOfTasteOrSmell;
  final bool shortnessOfBreath;
  final bool soreThroat;
  final bool headache;
  final bool bodyAches;
  SymptomInput({
    this.fever = false,
    this.dryCough = false,
    this.fatigue = false,
    this.lossOfTasteOrSmell = false,
    this.shortnessOfBreath = false,
    this.soreThroat = false,
    this.headache = false,
    this.bodyAches = false,
  });
}

enum SymptomVerdict { likelyNotCovid, monitorAtHome, consultDoctor, urgent }

class SymptomResult {
  final int score;
  final SymptomVerdict verdict;
  final String advice;
  SymptomResult(this.score, this.verdict, this.advice);
}

class SymptomScorer {
  static SymptomResult score(SymptomInput s) {
    int total = 0;
    if (s.fever) total += 3;
    if (s.dryCough) total += 3;
    if (s.fatigue) total += 2;
    if (s.lossOfTasteOrSmell) total += 5;
    if (s.shortnessOfBreath) total += 6;
    if (s.soreThroat) total += 1;
    if (s.headache) total += 1;
    if (s.bodyAches) total += 1;

    if (s.shortnessOfBreath) {
      return SymptomResult(
        total,
        SymptomVerdict.urgent,
        'Shortness of breath can be serious. Seek medical care now.',
      );
    }
    if (total >= 8) {
      return SymptomResult(
        total,
        SymptomVerdict.consultDoctor,
        'Your symptoms suggest you should consult a doctor and get tested.',
      );
    }
    if (total >= 4) {
      return SymptomResult(
        total,
        SymptomVerdict.monitorAtHome,
        'Monitor your symptoms at home. Isolate from others and stay hydrated.',
      );
    }
    return SymptomResult(
      total,
      SymptomVerdict.likelyNotCovid,
      'Your symptoms are unlikely to indicate COVID-19. Stay vigilant.',
    );
  }
}
