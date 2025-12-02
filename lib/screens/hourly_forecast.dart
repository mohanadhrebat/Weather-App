import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text("Hourly Forecast")),

      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, i) {
          return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Hour $i",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Row(
                  children: const [
                    Icon(Icons.wb_sunny, color: Colors.yellow),
                    SizedBox(width: 10),
                    Text("25°C"),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
