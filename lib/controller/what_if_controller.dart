import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:get/get.dart';

class WhatIfController extends GetxController {
  final StateServicesController _service = Get.find<StateServicesController>();

  RxInt input = 0.obs;
  Rxn<CountryModel> match = Rxn<CountryModel>();

  void setInput(int v) {
    input.value = v;
    _findMatch();
  }

  void _findMatch() {
    final list = _service.countries;
    if (list.isEmpty || input.value <= 0) {
      match.value = null;
      return;
    }
    CountryModel? best;
    int bestDiff = -1;
    for (final c in list) {
      final diff = (c.cases - input.value).abs();
      if (bestDiff == -1 || diff < bestDiff) {
        best = c;
        bestDiff = diff;
      }
    }
    match.value = best;
  }
}
