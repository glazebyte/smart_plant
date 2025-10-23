import 'package:json_annotation/json_annotation.dart';

part 'schedule.g.dart';

@JsonSerializable()
class WaterSchedule {
  final int slot;
  final String time; // Format: "HH:MM"
  final int duration; // Duration in seconds
  final bool enabled; // 1 for enabled, 0 for disabled

  const WaterSchedule({
    required this.slot,
    required this.time,
    required this.duration,
    required this.enabled,
  });

  factory WaterSchedule.fromJson(Map<String, dynamic> json) => _$WaterScheduleFromJson(json);
  Map<String, dynamic> toJson() => _$WaterScheduleToJson(this);

  // Helper methods
  bool get isEnabled => enabled == true;
  
  String get durationText {
    if (duration < 60) return '${duration}s';
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (seconds == 0) return '${minutes}m';
    return '${minutes}m ${seconds}s';
  }
  
  DateTime? get nextScheduledTime {
    if (!isEnabled) return null;
    
    final now = DateTime.now();
    final timeParts = time.split(':');
    if (timeParts.length != 2) return null;
    
    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return null;
    
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    
    // If the scheduled time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    return scheduledTime;
  }

  WaterSchedule copyWith({
    int? slot,
    String? time,
    int? duration,
    bool? enabled,
  }) {
    return WaterSchedule(
      slot: slot ?? this.slot,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() {
    return 'WaterSchedule(slot: $slot, time: $time, duration: ${duration}s, enabled: $enabled)';
  }
}

@JsonSerializable()
class ControlCommand {
  final String cmd;
  final int? duration;

  const ControlCommand({
    required this.cmd,
    this.duration,
  });

  factory ControlCommand.fromJson(Map<String, dynamic> json) => _$ControlCommandFromJson(json);
  Map<String, dynamic> toJson() => _$ControlCommandToJson(this);

  // Factory constructors for common commands
  factory ControlCommand.trigger(int durationSeconds) {
    return ControlCommand(cmd: 'trigger', duration: durationSeconds);
  }

  factory ControlCommand.cancel() {
    return const ControlCommand(cmd: 'cancel');
  }

  @override
  String toString() {
    if (duration != null) {
      return 'ControlCommand(cmd: $cmd, duration: ${duration}s)';
    }
    return 'ControlCommand(cmd: $cmd)';
  }
}