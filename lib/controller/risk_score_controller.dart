import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/utils/risk_calculator.dart';
import 'package:get/get.dart';

class RiskScoreController extends GetxController {
  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();
  RxInt age = 30.obs;
  RxBool hasComorbidities = false.obs;
  Rxn<RiskResult> result = Rxn<RiskResult>();

  void setCountry(CountryModel? c) => selectedCountry.value = c;
  void setAge(int a) => age.value = a;
  void setComorbidities(bool b) => hasComorbidities.value = b;

  void compute() {
    final c = selectedCountry.value;
    if (c == null) return;
    result.value = RiskCalculator.compute(
      country: c,
      age: age.value,
      hasComorbidities: hasComorbidities.value,
    );
  }
}
