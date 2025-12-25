import 'package:flutter/material.dart';
import '../services/WeatherService.dart';
import '../models/Weather.dart';

class CityDetailScreen extends StatefulWidget {
  final String cityName;

  const CityDetailScreen({super.key, required this.cityName});

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  final WeatherService service = WeatherService();
  ForecastWeather? forecast;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadForecast();
  }

  Future<void> loadForecast() async {
    setState(() => isLoading = true);
    forecast = await service.getForecast(widget.cityName, days: 3);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.cityName)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : forecast == null
              ? const Center(child: Text("Error loading data"))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Current Weather
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Image.network(forecast!.current.iconUrl, width: 80, height: 80),
                          Text("${forecast!.current.temperature.round()}°C",
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                          Text(forecast!.current.conditionText,
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("3-Day Forecast",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // 3 Days
                    ...forecast!.days.map((day) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Image.network(day.iconUrl, width: 50, height: 50),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(day.date, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(day.conditionText),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text("↑${day.maxTempC.round()}°", style: const TextStyle(color: Colors.red)),
                                  Text("↓${day.minTempC.round()}°", style: const TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
    );
  }
}