// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorData _$SensorDataFromJson(Map<String, dynamic> json) => SensorData(
  timestamp: (json['t'] as num).toInt(),
  soilMoisture: (json['s'] as num).toDouble(),
  humidity: (json['h'] as num).toDouble(),
  temperature: (json['tmp'] as num).toDouble(),
);

Map<String, dynamic> _$SensorDataToJson(SensorData instance) =>
    <String, dynamic>{
      't': instance.timestamp,
      's': instance.soilMoisture,
      'h': instance.humidity,
      'tmp': instance.temperature,
    };
