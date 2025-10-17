import 'package:json_annotation/json_annotation.dart';

part 'log_entry.g.dart';

@JsonSerializable()
class LogEntry {
  @JsonKey(name: 'ts')
  final int timestamp;
  
  @JsonKey(name: 'soil')
  final double? soilMoisture;
  
  @JsonKey(name: 'hum')
  final double? humidity;
  
  @JsonKey(name: 'temp')
  final double? temperature;
  
  @JsonKey(name: 'bat')
  final double? batteryVoltage;

  const LogEntry({
    required this.timestamp,
    this.soilMoisture,
    this.humidity,
    this.temperature,
    this.batteryVoltage,
  });

  factory LogEntry.fromJson(Map<String, dynamic> json) => _$LogEntryFromJson(json);
  Map<String, dynamic> toJson() => _$LogEntryToJson(this);

  // Helper methods
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  
  String get formattedDateTime {
    final dt = dateTime;
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
  
  String get soilMoisturePercentage => soilMoisture != null ? '${soilMoisture!.toStringAsFixed(1)}%' : 'N/A';
  String get humidityPercentage => humidity != null ? '${humidity!.toStringAsFixed(1)}%' : 'N/A';
  String get temperatureCelsius => temperature != null ? '${temperature!.toStringAsFixed(1)}°C' : 'N/A';
  String get batteryVoltageString => batteryVoltage != null ? '${batteryVoltage!.toStringAsFixed(2)}V' : 'N/A';

  @override
  String toString() {
    return 'LogEntry(timestamp: $timestamp, soil: $soilMoisture%, humidity: $humidity%, temp: $temperature°C, battery: ${batteryVoltage}V)';
  }
}

@JsonSerializable()
class LogRequest {
  final String action;
  final int start;
  final int? count;

  const LogRequest({
    required this.action,
    required this.start,
    this.count,
  });

  factory LogRequest.fromJson(Map<String, dynamic> json) => _$LogRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LogRequestToJson(this);

  // Factory constructor for getting logs
  factory LogRequest.get({int start = 0, int? count}) {
    return LogRequest(action: 'get', start: start, count: count);
  }

  @override
  String toString() {
    return 'LogRequest(action: $action, start: $start, count: $count)';
  }
}