// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/legacy.dart';
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

  void addSensor(SensorData data, dynamic state) {
    final updated = state.sensors
      ..removeWhere((s) => s.deviceId == data.deviceId)
      ..add(data);
    state = state.copyWith(
      sensors: List.from(updated)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
    );
  }

  void setConnected(bool connected) {
    var state = state.copyWith(isConnected: connected);
  }

  void clear() {
    var state;
    state = state.copyWith(sensors: []);
  }
}

final sensorProvider = StateNotifierProvider<SensorNotifier, SensorState>((
  ref,
) {
  return SensorNotifier();
});
