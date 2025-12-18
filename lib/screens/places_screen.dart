import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/WeatherService.dart';
import '../models/Weather.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final WeatherService service = WeatherService();

  List<String> cities = [
    "Amman",
  "Jerusalem",
  "Cairo",
  "Dubai",
  "Riyadh",
  "Doha",
  "Istanbul",
  "Berlin",
  ];

  late Future<List<Weather?>> weatherListFuture;

  @override
  void initState() {
    super.initState();
    weatherListFuture = loadWeatherForCities();
  }

  Future<List<Weather?>> loadWeatherForCities() async {
    List<Weather?> results = [];
    for (String city in cities) {
      Weather? w = await service.getWeather(city);
      results.add(w);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("City Weather")),

      body: FutureBuilder<List<Weather?>>(
        future: weatherListFuture,
        builder: (context, snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Error loading cities"));
          }

          List<Weather?> weatherList = snapshot.data!;

          return ListView.builder(
            itemCount: weatherList.length,
            itemBuilder: (context, index) {
              Weather? w = weatherList[index];

              if (w == null) {
                return const ListTile(
                  title: Text("Error loading city"),
                );
              }

              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(

                  color: const Color.fromARGB(255, 15, 0, 0),
                  
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.cityName,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text("${w.temperature.round()}°C"),
                        Text(w.conditionText),
                      ],
                    ),

                    Image.network(
                      w.iconUrl,
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
