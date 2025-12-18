import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'package:weather_app/screens/home_screen.dart';



void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider()..fetchWeather("hebron"),
      child: const WeatherApp()
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

