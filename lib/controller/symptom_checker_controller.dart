import 'package:covidapp/utils/symptom_scorer.dart';
import 'package:get/get.dart';

class SymptomCheckerController extends GetxController {
  RxBool fever = false.obs;
  RxBool dryCough = false.obs;
  RxBool fatigue = false.obs;
  RxBool lossOfTasteOrSmell = false.obs;
  RxBool shortnessOfBreath = false.obs;
  RxBool soreThroat = false.obs;
  RxBool headache = false.obs;
  RxBool bodyAches = false.obs;

  Rxn<SymptomResult> result = Rxn<SymptomResult>();

  void compute() {
    result.value = SymptomScorer.score(SymptomInput(
      fever: fever.value,
      dryCough: dryCough.value,
      fatigue: fatigue.value,
      lossOfTasteOrSmell: lossOfTasteOrSmell.value,
      shortnessOfBreath: shortnessOfBreath.value,
      soreThroat: soreThroat.value,
      headache: headache.value,
      bodyAches: bodyAches.value,
    ));
  }

  void reset() {
    fever.value = false;
    dryCough.value = false;
    fatigue.value = false;
    lossOfTasteOrSmell.value = false;
    shortnessOfBreath.value = false;
    soreThroat.value = false;
    headache.value = false;
    bodyAches.value = false;
    result.value = null;
  }
}
