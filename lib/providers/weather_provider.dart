import 'package:flutter/material.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:weather_app/services/WeatherService.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();

  Weather? weather;
  bool isLoading = false;

  Future<void> fetchWeather(String city) async {
    isLoading = true;
    notifyListeners();

    weather = await service.getWeather(city);

    isLoading = false;
    notifyListeners();
  }
}
