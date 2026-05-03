import 'package:covidapp/controller/auth_controller.dart';
import 'package:covidapp/controller/leaderboard_controller.dart';
import 'package:covidapp/controller/news_controller.dart';
import 'package:covidapp/controller/personal_country_controller.dart';
import 'package:covidapp/controller/risk_score_controller.dart';
import 'package:covidapp/controller/state_services_controller.dart';
import 'package:covidapp/controller/symptom_checker_controller.dart';
import 'package:covidapp/controller/travel_advisor_controller.dart';
import 'package:covidapp/controller/trend_predictor_controller.dart';
import 'package:covidapp/controller/voice_stats_controller.dart';
import 'package:covidapp/controller/what_if_controller.dart';
import 'package:get/get.dart';

void _ensureStateServices() {
  if (!Get.isRegistered<StateServicesController>()) {
    Get.put(StateServicesController(), permanent: true);
  }
}

void ensureAuth() {
  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(), permanent: true);
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    ensureAuth();
  }
}

class RiskScoreBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<RiskScoreController>(() => RiskScoreController());
  }
}

class TrendPredictorBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<TrendPredictorController>(() => TrendPredictorController());
  }
}

class WhatIfBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<WhatIfController>(() => WhatIfController());
  }
}

class LeaderboardBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
  }
}

class SymptomCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SymptomCheckerController>(() => SymptomCheckerController());
  }
}

class TravelAdvisorBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<TravelAdvisorController>(() => TravelAdvisorController());
  }
}

class NewsBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<NewsController>(() => NewsController());
  }
}

class VoiceStatsBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    Get.lazyPut<VoiceStatsController>(() => VoiceStatsController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    if (!Get.isRegistered<PersonalCountryController>()) {
      Get.put(PersonalCountryController(), permanent: true);
    }
  }
}

class PersonalCountryBinding extends Bindings {
  @override
  void dependencies() {
    _ensureStateServices();
    if (!Get.isRegistered<PersonalCountryController>()) {
      Get.put(PersonalCountryController(), permanent: true);
    }
  }
}
