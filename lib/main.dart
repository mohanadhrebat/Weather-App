import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الإشعارات
  await NotificationService.init();
  
  // ✅ طلب إذن الإشعارات (Android 13+)
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider()..fetchWeatherByGPS(),
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}