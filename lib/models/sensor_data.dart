import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  @JsonKey(name: 't')
  final int timestamp;
  
  @JsonKey(name: 'soil')
  final double soilMoisture;
  
  @JsonKey(name: 'hum')
  final double humidity;
  
  @JsonKey(name: 'temp')
  final double temperature;
  
  @JsonKey(name: 'bat')
  final double batteryVoltage;

  const SensorData({
    required this.timestamp,
    required this.soilMoisture,
    required this.humidity,
    required this.temperature,
    required this.batteryVoltage,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);

  // Helper methods
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  
  String get soilMoisturePercentage => '${soilMoisture.toStringAsFixed(1)}%';
  String get humidityPercentage => '${humidity.toStringAsFixed(1)}%';
  String get temperatureCelsius => '${temperature.toStringAsFixed(1)}°C';
  String get batteryVoltageString => '${batteryVoltage.toStringAsFixed(2)}V';
  
  // Status helpers
  SoilMoistureLevel get soilMoistureLevel {
    if (soilMoisture < 30) return SoilMoistureLevel.low;
    if (soilMoisture < 60) return SoilMoistureLevel.medium;
    return SoilMoistureLevel.high;
  }
  
  BatteryLevel get batteryLevel {
    if (batteryVoltage < 3.3) return BatteryLevel.low;
    if (batteryVoltage < 3.7) return BatteryLevel.medium;
    return BatteryLevel.high;
  }

  @override
  String toString() {
    return 'SensorData(timestamp: $timestamp, soil: $soilMoisture%, humidity: $humidity%, temp: $temperature°C, battery: ${batteryVoltage}V)';
  }
}

enum SoilMoistureLevel {
  low,
  medium,
  high,
}

enum BatteryLevel {
  low,
  medium,
  high,
}