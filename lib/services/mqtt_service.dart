import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/sensor_data.dart';

class MQTTService {
  late MqttServerClient client;
  
  static const String host = '92f3c5f778a8493db77b4b9500dd459c.s1.eu.hivemq.cloud';
  static const int port = 8883;
  static const String username = 'piquet';
  static const String password = 'Piquet123*';
  
  Function(SensorData)? onDataReceived;

  get connectionState => null;

  Future<void> connect() async {
    try {
      client = MqttServerClient(host, 'flutter_app_${DateTime.now().millisecondsSinceEpoch}');
      client.port = port;
      client.secure = true;
      client.logging(on: false);

      await client.connect(username, password);
      
      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        print('✅ Connecté à HiveMQ Cloud');
        _subscribeToTopics();
        _listenToMessages();
        return;
      }
    } catch (e) {
      print('❌ Erreur connexion MQTT: $e');
    }
  }

  void _subscribeToTopics() {
    final topics = [
      'farm/soil1',
      'farm/soil2', 
      'farm/soil3',
      'farm/soil4',
      'piquet/agricole/capteurs/+/data'
    ];

    for (final topic in topics) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      print('📡 Souscrit à: $topic');
    }
  }

  void _listenToMessages() {
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      for (final message in messages) {
        final payload = message.payload as MqttPublishMessage;
        final topic = message.topic;
        final messageStr = MqttPublishPayload.bytesToStringAsString(payload.payload.message);

        final sensorData = SensorData.fromMqtt(topic, messageStr);
        onDataReceived?.call(sensorData);
      }
    });
  }

  void disconnect() {
    client.disconnect();
    print('🔌 Déconnecté de HiveMQ');
  }
}