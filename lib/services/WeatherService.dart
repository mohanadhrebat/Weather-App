import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/Weather.dart';

class WeatherService {
  final String apiKey = "bfc6402dbc134266bf2150452253011";

  Future<Weather?> getWeather(String cityName) async {
    try {
      final url = Uri.parse(
        "http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName&aqi=no",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Weather.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
