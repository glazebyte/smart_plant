import 'package:json_annotation/json_annotation.dart';

part 'sensor_data.g.dart';

@JsonSerializable()
class SensorData {
  @JsonKey(name: 't')
  final int timestamp;
  
  @JsonKey(name: 's')
  final double soilMoisture;
  
  @JsonKey(name: 'h')
  final double humidity;
  
  @JsonKey(name: 'tmp')
  final double temperature;
  
  const SensorData({
    required this.timestamp,
    required this.soilMoisture,
    required this.humidity,
    required this.temperature,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) => _$SensorDataFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataToJson(this);

  // Helper methods
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  
  String get soilMoisturePercentage => '${soilMoisture.toStringAsFixed(1)}%';
  String get humidityPercentage => '${humidity.toStringAsFixed(1)}%';
  String get temperatureCelsius => '${temperature.toStringAsFixed(1)}°C';
  
  // Status helpers
  SoilMoistureLevel get soilMoistureLevel {
    if (soilMoisture < 30) return SoilMoistureLevel.low;
    if (soilMoisture < 60) return SoilMoistureLevel.medium;
    return SoilMoistureLevel.high;
  }
  
  @override
  String toString() {
    return 'SensorData(timestamp: $timestamp, soil: $soilMoisture%, humidity: $humidity%, temp: $temperature°C)';
  }
}

enum SoilMoistureLevel {
  low,
  medium,
  high,
}
