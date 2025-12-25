import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/notification_service.dart';
import '../widgets/app_drawer.dart';
import '../services/WeatherService.dart';
import '../models/Weather.dart';

class DailyForecast extends StatefulWidget {
  const DailyForecast({super.key});

  @override
  State<DailyForecast> createState() => _DailyForecastState();
}

class _DailyForecastState extends State<DailyForecast> {
  final WeatherService service = WeatherService();

  ForecastWeather? forecast;
  bool isLoading = true;
  String? error;
  double? lat;
  double? lon;

  @override
  void initState() {
    super.initState();
    loadForecastByGPS();
  }

  Future<void> loadForecastByGPS() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          error = "Location service is disabled";
          isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          error = "Location permission denied";
          isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = position.latitude;
      lon = position.longitude;

      forecast = await service.getForecast(
        "${position.latitude},${position.longitude}",
        days: 3,
      );

      if (forecast == null) {
        error = "Could not load forecast";
      } else {
        // ✅ فحص الطقس وإرسال تنبيه
        for (var day in forecast!.days) {
          NotificationService.checkWeatherAlert(day.conditionText, day.chanceOfRain);
        }
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() => isLoading = false);
  }

 

  String formatDate(String dateStr, int index) {
    if (index == 0) return "Today";
    if (index == 1) return "Tomorrow";

    try {
      DateTime date = DateTime.parse(dateStr);
      List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return days[date.weekday - 1];
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("3-Day Forecast"),
        actions: [
         
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadForecastByGPS,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: loadForecastByGPS,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Image.network(forecast!.current.iconUrl, width: 70, height: 70),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      forecast!.current.cityName,
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${forecast!.current.temperature.round()}°C",
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                ),
                                Text(forecast!.current.conditionText),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  
                    const SizedBox(height: 20),
                    const Text(
                      "3-Day Forecast",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...forecast!.days.asMap().entries.map((entry) {
                      int index = entry.key;
                      DayForecast day = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Image.network(day.iconUrl, width: 55, height: 55),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatDate(day.date, index),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(day.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(day.conditionText, style: TextStyle(color: Colors.grey[400])),
                                  if (day.chanceOfRain > 0)
                                    Row(
                                      children: [
                                        Icon(Icons.water_drop, size: 14, color: Colors.blue[300]),
                                        const SizedBox(width: 4),
                                        Text("${day.chanceOfRain}% rain", style: TextStyle(color: Colors.blue[300], fontSize: 12)),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_upward, size: 16, color: Colors.redAccent),
                                    Text("${day.maxTempC.round()}°", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.arrow_downward, size: 16, color: Colors.lightBlueAccent),
                                    Text("${day.minTempC.round()}°", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlueAccent)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
    );
  }
}