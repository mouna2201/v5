import 'package:flutter/material.dart';
import 'dart:math';

class IrrigationPlanScreen extends StatelessWidget {
  final String location;
  final String soilType;
  final List<String> cropTypes; // 🌾 Plusieurs cultures

  const IrrigationPlanScreen({
    super.key,
    required this.location,
    required this.soilType,
    required this.cropTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101018),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Plan d’arrosage - $location",
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: cropTypes.map((crop) {
            return _buildCropCard(crop);
          }).toList(),
        ),
      ),
    );
  }

  // 🪴 Carte pour chaque culture
  Widget _buildCropCard(String crop) {
    final random = Random();

    // 🌦️ Données météo simulées
    final weatherData = [
      {"day": "Lundi", "temp": "22°", "min": "15°", "rain": random.nextInt(60)},
      {"day": "Mardi", "temp": "24°", "min": "16°", "rain": random.nextInt(60)},
      {"day": "Mercredi", "temp": "25°", "min": "17°", "rain": random.nextInt(60)},
      {"day": "Jeudi", "temp": "23°", "min": "15°", "rain": random.nextInt(60)},
      {"day": "Vendredi", "temp": "21°", "min": "14°", "rain": random.nextInt(60)},
      {"day": "Samedi", "temp": "22°", "min": "15°", "rain": random.nextInt(60)},
      {"day": "Dimanche", "temp": "24°", "min": "16°", "rain": random.nextInt(60)},
    ];

    // 🌡️ Humidité du sol (20–90%)
    int soilHumidity = random.nextInt(70) + 20;

    // 💧 Conseil IA
    String recommendation =
        _getRecommendation(soilType, crop, weatherData, soilHumidity);

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
          Center(
            child: Text(
              "🌿 $crop",
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text("🪴 Sol : $soilType",
                style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 15),

          // 🔹 Tableau météo
          Column(
            children: weatherData.map((day) {
              final int rainValue = day["rain"] as int;
              bool isRain = rainValue > 40;
              IconData icon = isRain ? Icons.cloud : Icons.wb_sunny;
              Color iconColor = isRain ? Colors.blueAccent : Colors.amberAccent;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(day["day"] as String,
                        style: const TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        Icon(icon, color: iconColor, size: 22),
                        const SizedBox(width: 8),
                        Text("$rainValue%",
                            style: const TextStyle(color: Colors.blueAccent)),
                      ],
                    ),
                    Text("${day["temp"]} / ${day["min"]}",
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // 🗓️ Mini calendrier d’arrosage intelligent
          _buildWateringCalendar(weatherData, crop),

          const SizedBox(height: 15),

          // 💬 Texte explicatif
          _buildWateringExplanation(crop),

          const SizedBox(height: 20),

          // 🌡️ Niveau d’humidité du sol
          _buildSoilHumidityWidget(soilHumidity),

          const SizedBox(height: 20),

          // 🤖 Recommandation IA
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "🤖 Conseil IA pour $crop :\n$recommendation",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🌾 Widget humidité du sol
  Widget _buildSoilHumidityWidget(int humidity) {
    Color barColor;
    String status;
    IconData icon;

    if (humidity < 30) {
      barColor = Colors.redAccent;
      status = "Sol sec";
      icon = Icons.warning;
    } else if (humidity < 60) {
      barColor = Colors.orangeAccent;
      status = "Humidité moyenne";
      icon = Icons.water_drop;
    } else {
      barColor = Colors.greenAccent;
      status = "Sol humide";
      icon = Icons.eco;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "💧 Humidité du sol",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: barColor, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                value: humidity / 100,
                color: barColor,
                backgroundColor: Colors.white24,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 10),
            Text("$humidity%", style: const TextStyle(color: Colors.white)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          status,
          style: TextStyle(color: barColor, fontSize: 13),
        ),
      ],
    );
  }

  // 🗓️ Calendrier d’arrosage (IA + météo)
  Widget _buildWateringCalendar(
      List<Map<String, dynamic>> weatherData, String crop) {
    int wateringInterval = 2; // par défaut tous les 2 jours

    if (crop.toLowerCase().contains("olive")) {
      wateringInterval = 7; // 1 fois/semaine
    } else if (crop.toLowerCase().contains("blé")) {
      wateringInterval = 1; // chaque jour
    } else if (crop.toLowerCase().contains("tomate")) {
      wateringInterval = 2; // tous les 2 jours
    } else if (crop.toLowerCase().contains("fraise")) {
      wateringInterval = 1; // chaque jour
    } else if (crop.toLowerCase().contains("maïs")) {
      wateringInterval = 3; // tous les 3 jours
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🗓️ Calendrier d’arrosage (IA + météo)",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weatherData.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final int rainValue = day["rain"] as int;
            bool isRain = rainValue > 40;

            bool shouldWater = false;
            if (!isRain) {
              if (wateringInterval == 1) {
                shouldWater = true; // chaque jour
              } else if (index % wateringInterval == 0) {
                shouldWater = true; // selon la fréquence
              }
            }

            return Column(
              children: [
                Text(
                  (day["day"] as String).substring(0, 3),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Icon(
                  shouldWater ? Icons.water_drop : Icons.cloud,
                  color: shouldWater ? Colors.cyanAccent : Colors.blueAccent,
                  size: 22,
                ),
                const SizedBox(height: 2),
                Text(
                  shouldWater ? "Arrose" : "Repos",
                  style: TextStyle(
                      color: shouldWater ? Colors.cyanAccent : Colors.white38,
                      fontSize: 11),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  // 💬 Explication du plan d’arrosage
  Widget _buildWateringExplanation(String crop) {
    String text;
    if (crop.toLowerCase().contains("olive")) {
      text =
          "🫒 L’olivier nécessite peu d’eau : un arrosage léger par semaine suffit.";
    } else if (crop.toLowerCase().contains("blé")) {
      text = "🌾 Le blé préfère un sol toujours humide : arrosez chaque jour.";
    } else if (crop.toLowerCase().contains("tomate")) {
      text =
          "🍅 La tomate a besoin d’un arrosage régulier : tous les 2 jours environ.";
    } else if (crop.toLowerCase().contains("fraise")) {
      text = "🍓 Les fraises nécessitent beaucoup d’eau : arrosez quotidiennement.";
    } else if (crop.toLowerCase().contains("maïs")) {
      text = "🌽 Le maïs aime l’humidité : arrosage tous les 3 jours environ.";
    } else {
      text =
          "💧 Arrosage standard : tous les 2 à 3 jours, selon les conditions météo.";
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white70, fontSize: 13),
    );
  }

  // 💡 Recommandation IA
  String _getRecommendation(
      String soil, String crop, List<Map<String, dynamic>> data, int humidity) {
    bool hasRain = data.any((day) => (day["rain"] as int) > 40);

    if (hasRain) {
      return "Pas d’arrosage prévu cette semaine 🌧️, la pluie couvrira les besoins en eau.";
    }

    String solInfo = "";
    switch (soil.toLowerCase()) {
      case "sableux":
        solInfo = "Le sol sableux retient peu l’eau.";
        break;
      case "argileux":
        solInfo = "Le sol argileux garde bien l’humidité.";
        break;
      case "limoneux":
        solInfo = "Le sol limoneux est équilibré et fertile.";
        break;
      default:
        solInfo = "Sol standard.";
    }

    String freq = "";
    String besoin = "";

    if (crop.toLowerCase().contains("tomate")) {
      freq = "Arrosez chaque jour ou un jour sur deux.";
      besoin = "Besoin moyen : 2L/m² par jour.";
    } else if (crop.toLowerCase().contains("blé")) {
      freq = "Arrosez une fois tous les 4 à 5 jours.";
      besoin = "Besoin faible : 1L/m².";
    } else if (crop.toLowerCase().contains("fraise")) {
      freq = "Arrosage quotidien recommandé.";
      besoin = "Besoin élevé : 2.5L/m².";
    } else if (crop.toLowerCase().contains("olive")) {
      freq = "Arrosez légèrement tous les 5 jours.";
      besoin = "Besoin faible : 1.5L/m².";
    } else if (crop.toLowerCase().contains("maïs")) {
      freq = "Arrosez tous les 2 à 3 jours.";
      besoin = "Besoin moyen : 2L/m².";
    } else {
      freq = "Arrosage standard : tous les 2-3 jours.";
      besoin = "2L/m².";
    }

    if (humidity > 75) {
      return "$solInfo 🌧️ Sol bien humide — reportez l’arrosage.\n$freq ($besoin)";
    } else if (humidity < 40) {
      return "$solInfo ☀️ Sol sec — arrosez dès aujourd’hui.\n$freq ($besoin)";
    } else {
      return "$solInfo 💧 Sol modérément humide.\n$freq ($besoin)";
    }
  }
}
