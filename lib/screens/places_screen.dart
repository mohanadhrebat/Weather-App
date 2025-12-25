import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/app_drawer.dart';
import '../services/WeatherService.dart';
import '../models/Weather.dart';
import 'city_detail_screen.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final WeatherService service = WeatherService();
  final TextEditingController searchController = TextEditingController();

  List<String> savedCities = [];
  Map<String, Weather?> weatherData = {};
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSavedCities();
  }

  // تحميل المدن المحفوظة
  Future<void> loadSavedCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cities = prefs.getStringList('saved_cities');
    
    if (cities != null && cities.isNotEmpty) {
      savedCities = cities;
      await loadWeatherForCities();
    }
    setState(() {});
  }

  // حفظ المدن
  Future<void> saveCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_cities', savedCities);
  }

  // تحميل الطقس لكل المدن المحفوظة
  Future<void> loadWeatherForCities() async {
    setState(() => isLoading = true);
    
    for (String city in savedCities) {
      Weather? w = await service.getWeather(city);
      weatherData[city] = w;
    }
    
    setState(() => isLoading = false);
  }

  // البحث عن مدينة جديدة
  Future<void> searchCity(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    Weather? result = await service.getWeather(query.trim());

    setState(() {
      isLoading = false;
      if (result != null) {
        // أضف إذا مش موجود
        if (!savedCities.contains(result.cityName)) {
          savedCities.insert(0, result.cityName);
          weatherData[result.cityName] = result;
          saveCities(); // حفظ
        }
        error = null;
      } else {
        error = "City not found: $query";
      }
    });
  }

  // حذف مدينة
  void removeCity(String cityName) {
    setState(() {
      savedCities.remove(cityName);
      weatherData.remove(cityName);
      saveCities(); // حفظ بعد الحذف
    });
  }

  // تحديث الكل
  Future<void> refreshAll() async {
    await loadWeatherForCities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Search Cities"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshAll,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Enter city name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    onSubmitted: (value) {
                      searchCity(value);
                      searchController.clear();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    searchCity(searchController.text);
                    searchController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          // Loading
          if (isLoading) const LinearProgressIndicator(),

          // Error
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            ),

          // Results
          Expanded(
            child: savedCities.isEmpty
                ? const Center(
                    child: Text(
                      "Search for a city to add it",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: savedCities.length,
                    itemBuilder: (context, index) {
                      String cityName = savedCities[index];
                      Weather? w = weatherData[cityName];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            if (w != null)
                              Image.network(w.iconUrl, width: 50, height: 50)
                            else
                              const Icon(Icons.cloud, size: 50),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cityName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (w != null) ...[
                                    Text("${w.temperature.round()}°C"),
                                    Text(w.conditionText),
                                  ] else
                                    const Text("Loading..."),
                                ],
                              ),
                            ),
                            // More Info Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CityDetailScreen(cityName: cityName),
                                  ),
                                );
                              },
                              child: const Text("More"),
                            ),
                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => removeCity(cityName),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}