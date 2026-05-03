import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/utils/background_worker.dart';
import 'package:covidapp/utils/notification_service.dart';
import 'package:covidapp/utils/personal_prefs.dart';
import 'package:covidapp/utils/predictor.dart';
import 'package:get/get.dart';

class PersonalCountryController extends GetxController {
  final StateServicesController _service = Get.find<StateServicesController>();

  Rxn<CountryModel> country = Rxn<CountryModel>();
  RxInt threshold = 50000.obs;
  RxBool notificationsEnabled = false.obs;
  Rxn<int> tomorrowPrediction = Rxn<int>();
  RxBool isLoading = false.obs;
  RxnString error = RxnString();
  RxBool isConfigured = false.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await PersonalPrefs.load();
    if (!prefs.isConfigured) return;
    threshold.value = prefs.threshold;
    notificationsEnabled.value = prefs.notificationsEnabled;
    isConfigured.value = true;
    if (_service.countries.isEmpty) {
      await _service.fetchCountries();
    }
    final match = _service.countries.firstWhereOrNull(
        (c) => c.country == prefs.countryName);
    if (match != null) {
      country.value = match;
      await refreshPrediction();
    }
  }

  Future<void> refreshPrediction() async {
    final c = country.value;
    if (c == null) return;
    isLoading.value = true;
    error.value = null;
    try {
      final hist = await _service.fetchHistorical(c.country, days: 30);
      final tom = Predictor.predictTomorrow(hist.cases);
      tomorrowPrediction.value = tom?.round();
    } catch (_) {
      error.value = 'Failed to load prediction.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> setup({
    required CountryModel newCountry,
    required int newThreshold,
    required bool notify,
  }) async {
    country.value = newCountry;
    threshold.value = newThreshold;
    notificationsEnabled.value = notify;
    isConfigured.value = true;

    await PersonalPrefs.save(
      countryName: newCountry.country,
      flagUrl: newCountry.flag,
      threshold: newThreshold,
      notificationsEnabled: notify,
    );

    if (notify) {
      final granted = await NotificationService.requestPermissions();
      if (granted) {
        await registerPeriodicWorker();
      } else {
        notificationsEnabled.value = false;
        await PersonalPrefs.save(
          countryName: newCountry.country,
          flagUrl: newCountry.flag,
          threshold: newThreshold,
          notificationsEnabled: false,
        );
      }
    } else {
      await cancelPeriodicWorker();
    }

    await refreshPrediction();
    return notificationsEnabled.value == notify;
  }

  Future<void> clear() async {
    await cancelPeriodicWorker();
    await PersonalPrefs.clear();
    country.value = null;
    threshold.value = 50000;
    notificationsEnabled.value = false;
    tomorrowPrediction.value = null;
    isConfigured.value = false;
  }

  Future<void> runWorkerNow() async {
    await runPersonalAlertCheck();
  }
}
