// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogEntry _$LogEntryFromJson(Map<String, dynamic> json) => LogEntry(
  timestamp: (json['t'] as num).toInt(),
  soilMoisture: (json['s'] as num?)?.toDouble(),
  humidity: (json['h'] as num?)?.toDouble(),
  temperature: (json['tmp'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LogEntryToJson(LogEntry instance) => <String, dynamic>{
  't': instance.timestamp,
  's': instance.soilMoisture,
  'h': instance.humidity,
  'tmp': instance.temperature,
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
