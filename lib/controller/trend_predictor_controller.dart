import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/Model/historical_model.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/utils/predictor.dart';
import 'package:get/get.dart';

class TrendPredictorController extends GetxController {
  final StateServicesController _service = Get.find<StateServicesController>();

  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();
  Rxn<HistoricalModel> historical = Rxn<HistoricalModel>();
  RxList<double> predicted = <double>[].obs;
  RxBool isLoading = false.obs;
  RxnString error = RxnString();

  Future<void> load(CountryModel c) async {
    selectedCountry.value = c;
    isLoading.value = true;
    error.value = null;
    historical.value = null;
    predicted.clear();
    try {
      final data = await _service.fetchHistorical(c.country, days: 30);
      historical.value = data;
      predicted.assignAll(Predictor.predictNext7(data.cases));
    } catch (e) {
      error.value = 'Failed to load historical data.';
    } finally {
      isLoading.value = false;
    }
  }
}
