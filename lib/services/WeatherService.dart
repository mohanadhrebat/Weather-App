import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/Weather.dart';

class WeatherService {
  final String apiKey = "bfc6402dbc134266bf2150452253011";

  // طقس حالي - query ممكن اسم مدينة أو "lat,lon"
  Future<Weather?> getWeather(String query) async {
    try {
      final url = Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$query&aqi=no",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  // توقعات - query ممكن اسم مدينة أو "lat,lon"
  Future<ForecastWeather?> getForecast(String query, {int days = 3}) async {
    try {
      final url = Uri.parse(
        "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$query&days=$days&aqi=no",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ForecastWeather.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}