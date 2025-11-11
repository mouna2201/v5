import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/sensor_card.dart';
import '../../presentation/providers/sensor_provider.dart';

class FarmerDashboardScreen extends ConsumerWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorState = ref.watch(sensorProvider);
    final sensors = sensorState.sensors;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        backgroundColor: const Color(0xFF1B5E20),
        actions: [
          Icon(
            sensorState.isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: sensorState.isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: sensors.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sensorState.isConnected ? Icons.hourglass_empty : Icons.cloud_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    sensorState.isConnected
                        ? "En attente des données..."
                        : "Hors ligne",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                return SensorCard(
                  key: ValueKey(sensors[index].deviceId),
                  sensorData: sensors[index],
                );
              },
            ),
    );
  }
}