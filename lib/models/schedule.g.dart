// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaterSchedule _$WaterScheduleFromJson(Map<String, dynamic> json) =>
    WaterSchedule(
      slot: (json['slot'] as num).toInt(),
      time: json['time'] as String,
      duration: (json['duration'] as num).toInt(),
      enabled: (json['enabled'] as num).toInt(),
    );

Map<String, dynamic> _$WaterScheduleToJson(WaterSchedule instance) =>
    <String, dynamic>{
      'slot': instance.slot,
      'time': instance.time,
      'duration': instance.duration,
      'enabled': instance.enabled,
    };

ControlCommand _$ControlCommandFromJson(Map<String, dynamic> json) =>
    ControlCommand(
      cmd: json['cmd'] as String,
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ControlCommandToJson(ControlCommand instance) =>
    <String, dynamic>{'cmd': instance.cmd, 'duration': instance.duration};
