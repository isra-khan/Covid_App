import 'package:shared_preferences/shared_preferences.dart';

class PersonalPrefs {
  static const _kCountry = 'pp_country_name';
  static const _kFlag = 'pp_country_flag';
  static const _kThreshold = 'pp_threshold';
  static const _kEnabled = 'pp_notify_enabled';
  static const _kLastNotified = 'pp_last_notified_ymd';

  final String? countryName;
  final String? flagUrl;
  final int threshold;
  final bool notificationsEnabled;
  final String? lastNotifiedDate;

  PersonalPrefs({
    this.countryName,
    this.flagUrl,
    this.threshold = 50000,
    this.notificationsEnabled = false,
    this.lastNotifiedDate,
  });

  bool get isConfigured => countryName != null && countryName!.isNotEmpty;

  static Future<PersonalPrefs> load() async {
    final p = await SharedPreferences.getInstance();
    return PersonalPrefs(
      countryName: p.getString(_kCountry),
      flagUrl: p.getString(_kFlag),
      threshold: p.getInt(_kThreshold) ?? 50000,
      notificationsEnabled: p.getBool(_kEnabled) ?? false,
      lastNotifiedDate: p.getString(_kLastNotified),
    );
  }

  static Future<void> save({
    required String countryName,
    required String flagUrl,
    required int threshold,
    required bool notificationsEnabled,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kCountry, countryName);
    await p.setString(_kFlag, flagUrl);
    await p.setInt(_kThreshold, threshold);
    await p.setBool(_kEnabled, notificationsEnabled);
  }

  static Future<void> setLastNotified(String ymd) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kLastNotified, ymd);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kCountry);
    await p.remove(_kFlag);
    await p.remove(_kThreshold);
    await p.remove(_kEnabled);
    await p.remove(_kLastNotified);
  }

  static String todayYmd() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
