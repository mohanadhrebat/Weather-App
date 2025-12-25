import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:weather_app/services/WeatherService.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService service = WeatherService();

  Weather? weather;
  bool isLoading = false;
  String? error;

  double? lastLat;
  double? lastLon;

  // ✅ weather by city
  Future<void> fetchWeatherByCity(String city) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      weather = await service.getWeather(city);
      if (weather == null) error = "Could not load weather.";
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ weather by GPS
  Future<void> fetchWeatherByGPS() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final ok = await _ensureLocationPermission();
      if (!ok) {
        error = "Location permission denied.";
        isLoading = false;
        notifyListeners();
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lastLat = pos.latitude;
      lastLon = pos.longitude;

      // ✅ استخدام getWeather مع GPS كـ string
      weather = await service.getWeather("$lastLat,$lastLon");
      if (weather == null) error = "Could not load weather.";
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ refresh
  Future<void> refresh() async {
    if (lastLat != null && lastLon != null) {
      isLoading = true;
      error = null;
      notifyListeners();

      try {
        weather = await service.getWeather("$lastLat,$lastLon");
        if (weather == null) error = "Could not load weather.";
      } catch (e) {
        error = e.toString();
      }

      isLoading = false;
      notifyListeners();
    } else {
      await fetchWeatherByGPS();
    }
  }

  Future<bool> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}