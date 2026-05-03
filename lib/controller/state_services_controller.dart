import 'dart:convert';
import 'package:covidapp/Model/casesmodel.dart';
import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/Model/historical_model.dart';
import 'package:covidapp/constant/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class StateServicesController extends GetxController
    with SingleGetTickerProviderMixin {
  RxBool isLoading = true.obs;
  RxBool isCountriesLoading = false.obs;
  Rxn<CasesModel> casesModel = Rxn<CasesModel>();
  RxList<CountryModel> countries = <CountryModel>[].obs;

  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  List<Color> chartColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchWorkStateRecords();
    fetchCountries();
  }

  Future<void> fetchWorkStateRecords() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(AppUrl.worldStateApi));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        casesModel.value = CasesModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch');
      }
    } catch (_) {
      // swallow; UI shows "No data"
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<CountryModel>> fetchCountries({bool forceRefresh = false}) async {
    if (countries.isNotEmpty && !forceRefresh) return countries.toList();
    try {
      isCountriesLoading.value = true;
      final response = await http.get(Uri.parse(AppUrl.worldCountries));
      if (response.statusCode == 200) {
        final List<dynamic> raw = jsonDecode(response.body);
        final parsed = raw
            .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        countries.assignAll(parsed);
        return parsed;
      } else {
        throw Exception('Failed to fetch countries');
      }
    } finally {
      isCountriesLoading.value = false;
    }
  }

  Future<HistoricalModel> fetchHistorical(String country,
      {int days = 30}) async {
    final response =
        await http.get(Uri.parse(AppUrl.historicalApi(country, days: days)));
    if (response.statusCode == 200) {
      return HistoricalModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch historical data');
    }
  }

  Future<CountryModel> fetchCountry(String name) async {
    final response = await http.get(Uri.parse(AppUrl.countryApi(name)));
    if (response.statusCode == 200) {
      return CountryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch country');
    }
  }
}
