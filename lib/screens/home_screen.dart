import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/Weather.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/services/WeatherService.dart';
import 'package:weather_app/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService service = WeatherService();

  late Future<Weather?> weatherFuture;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Weather App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WeatherProvider>().fetchWeather("hebron");
            },
          ),
        ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.weather == null
          ? const Center(child: Text("Error loading weather"))
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
                ],
              ),
            ),
    );
  }
}
