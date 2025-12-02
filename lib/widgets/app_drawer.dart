import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/hourly_forecast.dart';
import '../screens/daily_forecast.dart';
import '../screens/places_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color.fromARGB(255, 46, 11, 102)),
            child: 
            Center(
              child: const Text(
                "Weather App",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),

          ListTile(
            title: const Text("Home"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
            },
          ),

          ListTile(
            title: const Text("Hourly Forecast"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HourlyForecast()));
            },
          ),

          ListTile(
            title: const Text("Daily Forecast"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const DailyForecast()));
            },
          ),

          ListTile(
            title: const Text("Places"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const PlacesScreen()));
            },
          ),
        ],
      ),
    );
  }
}
