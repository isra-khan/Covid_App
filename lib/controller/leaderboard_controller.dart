import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  final StateServicesController _service = Get.find<StateServicesController>();

  RxList<CountryModel> top = <CountryModel>[].obs;
  RxList<CountryModel> bottom = <CountryModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _build();
    ever(_service.countries, (_) => _build());
  }

  Future<void> _build() async {
    isLoading.value = true;
    if (_service.countries.isEmpty) {
      await _service.fetchCountries();
    }
    final eligible = _service.countries
        .where((c) => c.cases >= 10000 && c.recovered > 0)
        .toList()
      ..sort((a, b) => b.recoveryRate.compareTo(a.recoveryRate));
    top.assignAll(eligible.take(10).toList());
    bottom.assignAll(eligible.reversed.take(10).toList());
    isLoading.value = false;
  }
}
