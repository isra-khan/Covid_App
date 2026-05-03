import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefs {
  static const _kOnboarding = 'auth_onboarding_completed';

  static Future<bool> isOnboardingCompleted() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kOnboarding) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboarding, v);
  }
}
