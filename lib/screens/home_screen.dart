import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: "Use GPS",
            onPressed: () {
              context.read<WeatherProvider>().fetchWeatherByGPS();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
            onPressed: () {
              context.read<WeatherProvider>().refresh(); // ✅ refresh GPS
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (provider.weather == null)
              ? Center(
                  child: Text(
                    provider.error ?? "Error loading weather",
                    textAlign: TextAlign.center,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        provider.weather!.cityName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Image.network(
                        provider.weather!.iconUrl,
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        "${provider.weather!.temperature.round()}°C",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        provider.weather!.conditionText,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Last updated: ${provider.weather!.lastUpdated}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
    );
  }
}
