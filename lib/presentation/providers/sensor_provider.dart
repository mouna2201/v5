import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/sensor_data.dart';

class SensorState {
  final List<SensorData> sensors;
  final bool isConnected;

  SensorState({required this.sensors, this.isConnected = false});

  SensorState copyWith({List<SensorData>? sensors, bool? isConnected}) {
    return SensorState(
      sensors: sensors ?? this.sensors,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class SensorNotifier extends StateNotifier<SensorState> {
  SensorNotifier() : super(SensorState(sensors: []));

  void addSensor(SensorData data) {
    final updated = List<SensorData>.from(state.sensors)
      ..removeWhere((s) => s.deviceId == data.deviceId)
      ..add(data)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    state = state.copyWith(sensors: updated);
  }

  void setConnected(bool connected) {
    state = state.copyWith(isConnected: connected);
  }

  void clear() {
    state = SensorState(sensors: []);
  }
}

final sensorProvider = StateNotifierProvider<SensorNotifier, SensorState>((
  ref,
) {
  return SensorNotifier();
});
