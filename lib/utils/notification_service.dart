import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  static Future<bool> requestPermissions() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;
    final iosGranted = await ios?.requestPermissions(
            alert: true, badge: true, sound: true) ??
        true;
    return androidGranted && iosGranted;
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'personal_alerts',
        'Personal COVID Alerts',
        channelDescription:
            'Daily prediction alerts for your selected country.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(0, title, body, details);
  }
}
