// lib/main.dart ou lib/services/app_initializer.dart
import 'package:flutter_application_1/presentation/providers/sensor_provider.dart';
import 'package:flutter_application_1/services/mqtt_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';


final mqttService = MQTTService(
  host: '92f3c5f778a8493db77b4b9500dd459c.s1.eu.hivemq.cloud',
  username: 'piquet',
  password: 'Piquet123*',
);

void setupMQTT(WidgetRef ref) async {
  mqttService.onDataReceived = (sensorData) {
    ref.read(sensorProvider.notifier).addSensor(sensorData);
  };

  mqttService.connectionState.listen((state) {
    final connected = state == MqttConnectionState.connected;
    ref.read(sensorProvider.notifier).setConnected(connected);
  });

  await mqttService.connect();
}