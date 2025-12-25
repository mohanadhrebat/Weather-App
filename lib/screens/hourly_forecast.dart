import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/app_drawer.dart';
import '../services/WeatherService.dart';
import '../models/Weather.dart';

class HourlyForecast extends StatefulWidget {
  const HourlyForecast({super.key});

  @override
  State<HourlyForecast> createState() => _HourlyForecastState();
}

class _HourlyForecastState extends State<HourlyForecast> {
  final WeatherService service = WeatherService();

  ForecastWeather? forecast;
  bool isLoading = true;
  String? error;

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

      // ✅ استخدام getForecast مع GPS كـ string
      forecast = await service.getForecast(
        "${position.latitude},${position.longitude}",
        days: 1,
      );

      if (forecast == null) {
        error = "Could not load forecast";
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() => isLoading = false);
  }

  String formatHour(String timeStr) {
    try {
      String hourPart = timeStr.split(" ").last;
      int hour = int.parse(hourPart.split(":").first);
      if (hour == 0) return "12 AM";
      if (hour == 12) return "12 PM";
      if (hour < 12) return "$hour AM";
      return "${hour - 12} PM";
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Hourly Forecast"),
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
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.network(forecast!.current.iconUrl, width: 60, height: 60),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    forecast!.current.cityName,
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                "${forecast!.current.temperature.round()}°C - ${forecast!.current.conditionText}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Today's Hourly Forecast",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...forecast!.days[0].hours.map((hour) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 70,
                                child: Text(
                                  formatHour(hour.time),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Image.network(hour.iconUrl, width: 40, height: 40),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hour.conditionText,
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                              Text(
                                "${hour.tempC.round()}°C",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (hour.chanceOfRain > 0) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.water_drop, size: 16, color: Colors.blue[300]),
                                Text("${hour.chanceOfRain}%", style: TextStyle(color: Colors.blue[300])),
                              ],
                            ],
                          ),
                        )),
                  ],
                ),
    );
  }
}