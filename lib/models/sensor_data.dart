import 'dart:convert';

class SensorData {
  final String deviceId;
  final double? temperature;
  final double? humidity;
  final double? soilMoisture;
  final double? battery;
  final DateTime timestamp;
  final String topic;

  SensorData({
    required this.deviceId,
    this.temperature,
    this.humidity,
    this.soilMoisture,
    this.battery,
    required this.timestamp,
    required this.topic,
  });

  factory SensorData.fromMqtt(String topic, String message) {
    final deviceId = _extractDeviceId(topic);
    final now = DateTime.now();
    
    try {
      final data = json.decode(message);
      return SensorData(
        deviceId: data['device_id'] ?? deviceId,
        temperature: data['temperature']?.toDouble(),
        humidity: data['humidity']?.toDouble(),
        soilMoisture: data['farm/soil1']?.toDouble(),
        battery: data['battery']?.toDouble(),
        timestamp: DateTime.parse(data['timestamp'] ?? now.toIso8601String()),
        topic: topic,
      );
    } catch (e) {
      return _parseSimpleMessage(topic, message, now);
    }
  }

  static SensorData _parseSimpleMessage(String topic, String message, DateTime timestamp) {
    final deviceId = _extractDeviceId(topic);
    double? temp, humidity;
    
    final tempMatch = RegExp(r'(\d+(?:\.\d+)?)\s*°?\s*[cC]').firstMatch(message);
    if (tempMatch != null) temp = double.parse(tempMatch.group(1)!);
    
    final humidityMatch = RegExp(r'(\d+(?:\.\d+)?)\s*%').firstMatch(message);
    if (humidityMatch != null) humidity = double.parse(humidityMatch.group(1)!);
    
    return SensorData(
      deviceId: deviceId,
      temperature: temp,
      humidity: humidity,
      timestamp: timestamp,
      topic: topic,
    );
  }

  static String _extractDeviceId(String topic) {
    final parts = topic.split('/');
    if (topic.startsWith('farm/')) return parts[1];
    if (topic.contains('capteurs/')) return parts[parts.indexOf('capteurs') + 1];
    return parts.last;
  }
}