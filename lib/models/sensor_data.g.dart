// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  timestamp: (json['t'] as num).toInt(),
  soilMoisture: (json['soil'] as num).toDouble(),
  humidity: (json['hum'] as num).toDouble(),
  temperature: (json['temp'] as num).toDouble(),
  batteryVoltage: (json['bat'] as num).toDouble(),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      't': instance.timestamp,
      'soil': instance.soilMoisture,
      'hum': instance.humidity,
      'temp': instance.temperature,
      'bat': instance.batteryVoltage,
    };
