import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class DailyForecast extends StatelessWidget {
  const DailyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Daily Forecast")),

      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Day $i",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Icon(Icons.wb_sunny, size: 35, color: Colors.yellow),
                const Text("High: 30°C"),
                const Text("Low: 20°C"),
              ],
            ),
          );
        },
      ),
    );
  }
}
