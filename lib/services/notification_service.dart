import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // تهيئة الإشعارات
  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(settings);
  }

  // إرسال إشعار
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'weather_channel',
      'Weather Alerts',
      channelDescription: 'Weather alerts for rain, snow, storms',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
    );
  }

  // فحص الطقس وإرسال تنبيه
  static void checkWeatherAlert(String condition, int chanceOfRain) {
    String conditionLower = condition.toLowerCase();

    if (conditionLower.contains('rain') || chanceOfRain > 50) {
      showNotification(
        title: '🌧️ Rain Alert!',
        body: 'Rain expected. Chance: $chanceOfRain%',
      );
    } else if (conditionLower.contains('snow')) {
      showNotification(
        title: '❄️ Snow Alert!',
        body: 'Snow expected in your area.',
      );
    } else if (conditionLower.contains('storm') || conditionLower.contains('thunder')) {
      showNotification(
        title: '⛈️ Storm Alert!',
        body: 'Storm expected. Stay safe!',
      );
    }
  }
}