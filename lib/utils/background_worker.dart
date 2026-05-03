import 'dart:convert';
import 'package:covidapp/Model/historical_model.dart';
import 'package:covidapp/constant/app_theme.dart';
import 'package:covidapp/constant/app_url.dart';
import 'package:covidapp/utils/notification_service.dart';
import 'package:covidapp/utils/personal_prefs.dart';
import 'package:covidapp/utils/predictor.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';

const String kPersonalAlertTask = 'covidapp_personal_alert_task';
const String kPersonalAlertUniqueName = 'covidapp_personal_alert_unique';

@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await runPersonalAlertCheck();
    } catch (_) {
      // Swallow errors so the worker isn't disabled by retry backoff.
    }
    return Future.value(true);
  });
}

Future<void> runPersonalAlertCheck() async {
  final prefs = await PersonalPrefs.load();
  if (!prefs.isConfigured || !prefs.notificationsEnabled) return;
  final today = PersonalPrefs.todayYmd();
  if (prefs.lastNotifiedDate == today) return;

  final url = AppUrl.historicalApi(prefs.countryName!, days: 30);
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) return;
  final hist = HistoricalModel.fromJson(jsonDecode(res.body));
  final tomorrow = Predictor.predictTomorrow(hist.cases);
  if (tomorrow == null) return;
  if (tomorrow <= prefs.threshold) return;

  await NotificationService.show(
    title: 'COVID alert: ${prefs.countryName}',
    body:
        'Predicted cases tomorrow: ${NumberFormatter.compact(tomorrow.round())} (threshold ${NumberFormatter.compact(prefs.threshold)}).',
  );
  await PersonalPrefs.setLastNotified(today);
}

Future<void> registerPeriodicWorker() async {
  await Workmanager().cancelByUniqueName(kPersonalAlertUniqueName);
  await Workmanager().registerPeriodicTask(
    kPersonalAlertUniqueName,
    kPersonalAlertTask,
    frequency: const Duration(hours: 24),
    initialDelay: _delayUntilNext8am(),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

Future<void> cancelPeriodicWorker() async {
  await Workmanager().cancelByUniqueName(kPersonalAlertUniqueName);
}

Duration _delayUntilNext8am() {
  final now = DateTime.now();
  var target = DateTime(now.year, now.month, now.day, 8);
  if (!target.isAfter(now)) {
    target = target.add(const Duration(days: 1));
  }
  return target.difference(now);
}
