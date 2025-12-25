import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/services/notification_service.dart';
import 'package:weather_app/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ✅ فتح Weather Map
  Future<void> openWeatherMap(double? lat, double? lon) async {
  if (lat != null && lon != null) {
    final url = Uri.parse("https://www.windy.com/$lat/$lon");
    await launchUrl(url, mode: LaunchMode.inAppBrowserView);
  }
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          // ✅ زر Weather Map
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: "Weather Map",
            onPressed: () {
              openWeatherMap(provider.lastLat, provider.lastLon);
            },
          ),
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
              context.read<WeatherProvider>().refresh();
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
                  const SizedBox(height: 30),
                  // ✅ زر Weather Map
                  ElevatedButton.icon(
                    onPressed: () {
                      openWeatherMap(provider.lastLat, provider.lastLon);
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Open Weather Map"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NotificationService.showNotification(
                        title: "🌧️ Test!",
                        body: "Rain is coming!",
                      );
                    },
                    child: const Text("Test Notification"),
                  ),
                ],
              ),
            ),
    );
  }
}
