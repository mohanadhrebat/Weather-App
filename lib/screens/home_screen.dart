import 'package:flutter/material.dart';
import 'package:weather_app/models/Weather.dart';
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
  void initState() {
    super.initState();

     weatherFuture = service.getWeather("London");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Weather App"),
      ),

      body: FutureBuilder<Weather?>(
        future: weatherFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Error loading weather"));
          }

          Weather weather = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Text(
                  weather.cityName,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 25),

                Image.network(
                  weather.iconUrl,
                  width: 90,
                  height: 90,
                ),

                const SizedBox(height: 25),

                Text(
                  "${weather.temperature}°C",
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Text(
                  weather.conditionText,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
