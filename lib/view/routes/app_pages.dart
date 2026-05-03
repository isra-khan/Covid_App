import 'package:covidapp/binding/feature_bindings.dart';
import 'package:covidapp/binding/splash_binding.dart';
import 'package:covidapp/binding/state_service_binding.dart';
import 'package:covidapp/view/auth_gate_screen.dart';
import 'package:covidapp/view/countries_list_screen.dart';
import 'package:covidapp/view/dashboard_screen.dart';
import 'package:covidapp/view/heatmap_screen.dart';
import 'package:covidapp/view/leaderboard_screen.dart';
import 'package:covidapp/view/news_screen.dart';
import 'package:covidapp/view/onboarding_screen.dart';
import 'package:covidapp/view/personal_country_screen.dart';
import 'package:covidapp/view/risk_score_screen.dart';
import 'package:covidapp/view/routes/routes.dart';
import 'package:covidapp/view/sign_in_screen.dart';
import 'package:covidapp/view/sign_up_screen.dart';
import 'package:covidapp/view/splash_screen.dart';
import 'package:covidapp/view/symptom_checker_screen.dart';
import 'package:covidapp/view/travel_advisor_screen.dart';
import 'package:covidapp/view/trend_predictor_screen.dart';
import 'package:covidapp/view/voice_stats_screen.dart';
import 'package:covidapp/view/what_if_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
      bindings: [StateServicesBinding(), DashboardBinding()],
    ),
    GetPage(
      name: Routes.contactList,
      page: () => const CountriesListScreen(),
      binding: StateServicesBinding(),
    ),
    GetPage(
      name: Routes.riskScore,
      page: () => const RiskScoreScreen(),
      binding: RiskScoreBinding(),
    ),
    GetPage(
      name: Routes.trendPredictor,
      page: () => const TrendPredictorScreen(),
      binding: TrendPredictorBinding(),
    ),
    GetPage(
      name: Routes.whatIf,
      page: () => const WhatIfScreen(),
      binding: WhatIfBinding(),
    ),
    GetPage(
      name: Routes.heatmap,
      page: () => const HeatmapScreen(),
      binding: StateServicesBinding(),
    ),
    GetPage(
      name: Routes.news,
      page: () => const NewsScreen(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: Routes.leaderboard,
      page: () => const LeaderboardScreen(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: Routes.symptomChecker,
      page: () => const SymptomCheckerScreen(),
      binding: SymptomCheckerBinding(),
    ),
    GetPage(
      name: Routes.travelAdvisor,
      page: () => const TravelAdvisorScreen(),
      binding: TravelAdvisorBinding(),
    ),
    GetPage(
      name: Routes.voiceStats,
      page: () => const VoiceStatsScreen(),
      binding: VoiceStatsBinding(),
    ),
    GetPage(
      name: Routes.personalCountry,
      page: () => const PersonalCountryScreen(),
      binding: PersonalCountryBinding(),
    ),
    GetPage(
      name: Routes.authGate,
      page: () => const AuthGateScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.signIn,
      page: () => const SignInScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => const SignUpScreen(),
      binding: AuthBinding(),
    ),
  ];
}
