import 'package:flutter/material.dart';
import 'dart:math';

class IrrigationPlanScreen extends StatelessWidget {
  final String location;
  final String soilType;
  final List<String> cropTypes;

  const IrrigationPlanScreen(
      {super.key,
      required this.location,
      required this.soilType,
      required this.cropTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Plan d’arrosage - $location",
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: cropTypes.map((crop) => _buildCropCard(crop)).toList(),
        ),
      ),
    );
  }

  Widget _buildCropCard(String crop) {
    final random = Random();
    final weatherData = List.generate(7, (index) {
      return {
        "day": ["Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"][index],
        "temp": "${22 + random.nextInt(5)}°",
        "min": "${15 + random.nextInt(5)}°",
        "rain": random.nextInt(60),
      };
    });
    final soilHumidity = random.nextInt(70) + 20;
    final recommendation = "Conseil IA simulé pour $crop";

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("🌿 $crop", style: const TextStyle(color: Colors.white, fontSize: 20))),
          const SizedBox(height: 10),
          Center(child: Text("🪴 Sol : $soilType", style: const TextStyle(color: Colors.white70))),
          const SizedBox(height: 15),
          ...weatherData.map((day) {
            bool isRain = day["rain"] as int > 40;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day["day"] as String, style: const TextStyle(color: Colors.white)),
                Text("${day["temp"]} / ${day["min"]}", style: const TextStyle(color: Colors.white70)),
                Icon(isRain ? Icons.cloud : Icons.wb_sunny, color: isRain ? Colors.blueAccent : Colors.amberAccent),
              ],
            );
          }).toList(),
          const SizedBox(height: 20),
          LinearProgressIndicator(value: soilHumidity / 100, color: Colors.greenAccent, backgroundColor: Colors.white24),
          const SizedBox(height: 10),
          Text("💧 Humidité du sol : $soilHumidity%", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.25), borderRadius: BorderRadius.circular(12)),
            child: Text(recommendation, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
