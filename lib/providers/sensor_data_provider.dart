import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sensor_data.dart';
import '../models/log_entry.dart';

class SensorDataProvider extends ChangeNotifier {
  SensorData? _latestSensorData;
  List<SensorData> _historicalData = [];
  List<LogEntry> _logEntries = [];
  bool _isLoading = false;
  String? _errorMessage;

  static const String _latestDataKey = 'latest_sensor_data';
  static const String _historicalDataKey = 'historical_sensor_data';
  static const int _maxHistoricalEntries = 1000;

  // Getters
  SensorData? get latestSensorData => _latestSensorData;
  List<SensorData> get historicalData => _historicalData;
  List<LogEntry> get logEntries => _logEntries;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _latestSensorData != null;

  // Computed properties
  double? get soilMoisturePercentage => _latestSensorData?.soilMoisture;
  double? get humidityPercentage => _latestSensorData?.humidity;
  double? get temperatureCelsius => _latestSensorData?.temperature;

  SoilMoistureLevel? get soilMoistureLevel => _latestSensorData?.soilMoistureLevel;

  // Status indicators
  bool get needsWatering => soilMoistureLevel == SoilMoistureLevel.low;

  SensorDataProvider() {
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      
      // Load latest sensor data
      final latestDataJson = prefs.getString(_latestDataKey);
      if (latestDataJson != null) {
        final data = jsonDecode(latestDataJson);
        _latestSensorData = SensorData.fromJson(data);
      }

      // Load historical data
      final historicalDataJson = prefs.getString(_historicalDataKey);
      if (historicalDataJson != null) {
        final List<dynamic> dataList = jsonDecode(historicalDataJson);
        _historicalData = dataList.map((data) => SensorData.fromJson(data)).toList();
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load stored data: $e');
      _setLoading(false);
    }
  }

  Future<void> updateSensorData(SensorData newData) async {
    try {
      _latestSensorData = newData;
      
      // Add to historical data
      _historicalData.add(newData);
      
      // Keep only the most recent entries
      if (_historicalData.length > _maxHistoricalEntries) {
        _historicalData = _historicalData.sublist(_historicalData.length - _maxHistoricalEntries);
      }

      // Save to storage
      await _saveToStorage();
      
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to update sensor data: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save latest data
      if (_latestSensorData != null) {
        final latestDataJson = jsonEncode(_latestSensorData!.toJson());
        await prefs.setString(_latestDataKey, latestDataJson);
      }

      // Save historical data
      final historicalDataJson = jsonEncode(
        _historicalData.map((data) => data.toJson()).toList()
      );
      await prefs.setString(_historicalDataKey, historicalDataJson);
    } catch (e) {
      debugPrint('Failed to save sensor data: $e');
    }
  }

  void addLogEntry(LogEntry logEntry) {
    _logEntries.add(logEntry);
    
    // Keep only recent log entries (last 500)
    if (_logEntries.length > 500) {
      _logEntries = _logEntries.sublist(_logEntries.length - 500);
    }
    
    notifyListeners();
  }

  void addLogEntries(List<LogEntry> entries) {
    _logEntries.addAll(entries);
    
    // Sort by timestamp (newest first)
    _logEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    // Keep only recent log entries
    if (_logEntries.length > 500) {
      _logEntries = _logEntries.sublist(0, 500);
    }
    
    notifyListeners();
  }

  void clearLogEntries() {
    _logEntries.clear();
    notifyListeners();
  }

  // Get sensor data for the last N hours
  List<SensorData> getDataForLastHours(int hours) {
    final cutoffTime = DateTime.now().subtract(Duration(hours: hours));
    return _historicalData
        .where((data) => data.dateTime.isAfter(cutoffTime))
        .toList();
  }

  // Get sensor data for a specific day
  List<SensorData> getDataForDay(DateTime day) {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return _historicalData
        .where((data) =>
            data.dateTime.isAfter(startOfDay) &&
            data.dateTime.isBefore(endOfDay))
        .toList();
  }

  // Get average values for the last N hours
  Map<String, double?> getAverageValues(int hours) {
    final data = getDataForLastHours(hours);
    if (data.isEmpty) {
      return {
        'soilMoisture': null,
        'humidity': null,
        'temperature': null,
      };
    }

    return {
      'soilMoisture': data.map((d) => d.soilMoisture).reduce((a, b) => a + b) / data.length,
      'humidity': data.map((d) => d.humidity).reduce((a, b) => a + b) / data.length,
      'temperature': data.map((d) => d.temperature).reduce((a, b) => a + b) / data.length,
    };
  }

  // Get min/max values for the last N hours
  Map<String, Map<String, double?>> getMinMaxValues(int hours) {
    final data = getDataForLastHours(hours);
    if (data.isEmpty) {
      return {
        'soilMoisture': {'min': null, 'max': null},
        'humidity': {'min': null, 'max': null},
        'temperature': {'min': null, 'max': null},
      };
    }

    final soilValues = data.map((d) => d.soilMoisture).toList();
    final humidityValues = data.map((d) => d.humidity).toList();
    final tempValues = data.map((d) => d.temperature).toList();

    return {
      'soilMoisture': {
        'min': soilValues.reduce((a, b) => a < b ? a : b),
        'max': soilValues.reduce((a, b) => a > b ? a : b),
      },
      'humidity': {
        'min': humidityValues.reduce((a, b) => a < b ? a : b),
        'max': humidityValues.reduce((a, b) => a > b ? a : b),
      },
      'temperature': {
        'min': tempValues.reduce((a, b) => a < b ? a : b),
        'max': tempValues.reduce((a, b) => a > b ? a : b),
      },
    };
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _clearError();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    debugPrint('SensorDataProvider Error: $error');
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() {
    _clearError();
  }

  Future<void> clearAllData() async {
    try {
      _latestSensorData = null;
      _historicalData.clear();
      _logEntries.clear();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_latestDataKey);
      await prefs.remove(_historicalDataKey);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear data: $e');
    }
  }
}