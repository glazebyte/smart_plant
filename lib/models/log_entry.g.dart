// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogEntry _$LogEntryFromJson(Map<String, dynamic> json) => LogEntry(
  timestamp: (json['ts'] as num).toInt(),
  soilMoisture: (json['soil'] as num?)?.toDouble(),
  humidity: (json['hum'] as num?)?.toDouble(),
  temperature: (json['temp'] as num?)?.toDouble(),
  batteryVoltage: (json['bat'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LogEntryToJson(LogEntry instance) => <String, dynamic>{
  'ts': instance.timestamp,
  'soil': instance.soilMoisture,
  'hum': instance.humidity,
  'temp': instance.temperature,
  'bat': instance.batteryVoltage,
};

LogRequest _$LogRequestFromJson(Map<String, dynamic> json) => LogRequest(
  action: json['action'] as String,
  start: (json['start'] as num).toInt(),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$LogRequestToJson(LogRequest instance) =>
    <String, dynamic>{
      'action': instance.action,
      'start': instance.start,
      'count': instance.count,
    };
