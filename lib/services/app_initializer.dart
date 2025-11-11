import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../presentation/providers/sensor_provider.dart';
import '../services/mqtt_service.dart';

/// Provider pour le service MQTT (singleton)
final mqttServiceProvider = Provider<MQTTService>((ref) {
  final service = MQTTService();
  
  // Cleanup quand le provider est disposé
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Fonction helper pour initialiser MQTT
Future<void> setupMQTT(WidgetRef ref) async {
  final mqttService = ref.read(mqttServiceProvider);
  
  mqttService.onDataReceived = (sensorData) {
    ref.read(sensorProvider.notifier).addSensor(sensorData);
  };

  mqttService.connectionState.listen((state) {
    final connected = state == MqttConnectionState.connected;
    ref.read(sensorProvider.notifier).setConnected(connected);
  });

  await mqttService.connect();
}