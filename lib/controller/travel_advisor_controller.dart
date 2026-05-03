import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/utils/travel_risk.dart';
import 'package:get/get.dart';

class TravelAdvisorController extends GetxController {
  Rxn<CountryModel> origin = Rxn<CountryModel>();
  Rxn<CountryModel> destination = Rxn<CountryModel>();
  Rxn<TravelRiskResult> result = Rxn<TravelRiskResult>();

  void setOrigin(CountryModel? c) {
    origin.value = c;
    _recompute();
  }

  void setDestination(CountryModel? c) {
    destination.value = c;
    _recompute();
  }

  void _recompute() {
    final o = origin.value;
    final d = destination.value;
    if (o == null || d == null) {
      result.value = null;
      return;
    }
    result.value = TravelRisk.assess(o, d);
  }
}
