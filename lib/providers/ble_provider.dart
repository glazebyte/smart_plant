import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../services/ble_service.dart';
import '../models/sensor_data.dart';
import '../models/schedule.dart';

class BleProvider extends ChangeNotifier {
  final BleService _bleService = BleService();
  
  List<BluetoothDevice> _availableDevices = [];
  BluetoothDevice? _connectedDevice;
  BleConnectionState _connectionState = BleConnectionState.disconnected;
  String? _errorMessage;
  
  StreamSubscription<SensorData>? _sensorDataSubscription;
  StreamSubscription<String>? _logDataSubscription;
  StreamSubscription<BleConnectionState>? _connectionStateSubscription;

  // Getters
  List<BluetoothDevice> get availableDevices => _availableDevices;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  BleConnectionState get connectionState => _connectionState;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _connectionState == BleConnectionState.connected;
  bool get isScanning => _connectionState == BleConnectionState.scanning;
  bool get isConnecting => _connectionState == BleConnectionState.connecting;

  // Streams
  Stream<SensorData> get sensorDataStream => _bleService.sensorDataStream;
  Stream<String> get logDataStream => _bleService.logDataStream;

  BleProvider() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _bleService.initialize();
      
      // Subscribe to connection state changes
      _connectionStateSubscription = _bleService.connectionStateStream.listen(
        (state) {
          _connectionState = state;
          if (state == BleConnectionState.disconnected) {
            _connectedDevice = null;
          }
          _clearError();
          notifyListeners();
        },
      );
    } catch (e) {
      _setError('Failed to initialize Bluetooth: $e');
    }
  }

  Future<void> scanForDevices() async {
    try {
      _clearError();
      _availableDevices = await _bleService.scanForDevices();
      notifyListeners();
    } catch (e) {
      _setError('Failed to scan for devices: $e');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _clearError();
      await _bleService.connectToDevice(device);
      _connectedDevice = device;
      notifyListeners();
    } catch (e) {
      _setError('Failed to connect to device: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      _clearError();
      await _bleService.disconnect();
      _connectedDevice = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to disconnect: $e');
    }
  }

  Future<void> triggerWatering({required int durationSeconds}) async {
    try {
      _clearError();
      final command = ControlCommand.trigger(durationSeconds);
      await _bleService.sendControlCommand(command);
    } catch (e) {
      _setError('Failed to trigger watering: $e');
    }
  }

  Future<void> cancelWatering() async {
    try {
      _clearError();
      final command = ControlCommand.cancel();
      await _bleService.sendControlCommand(command);
    } catch (e) {
      _setError('Failed to cancel watering: $e');
    }
  }

  Future<void> saveSchedule(WaterSchedule schedule) async {
    try {
      _clearError();
      await _bleService.writeSchedule(schedule);
    } catch (e) {
      _setError('Failed to save schedule: $e');
    }
  }

  Future<List<WaterSchedule>> loadSchedules() async {
    try {
      _clearError();
      return await _bleService.readSchedules();
    } catch (e) {
      _setError('Failed to load schedules: $e');
      return [];
    }
  }

  Future<void> requestLogs({int start = 0, int? count}) async {
    try {
      _clearError();
      await _bleService.requestLogs(start: start, count: count);
    } catch (e) {
      _setError('Failed to request logs: $e');
    }
  }

  Future<void> syncRTC() async {
    try {
      _clearError();
      await _bleService.syncRTC();
    } catch (e) {
      _setError('Failed to sync RTC: $e');
    }
  }

  Future<DateTime?> readRTC() async {
    try {
      _clearError();
      return await _bleService.readRTC();
    } catch (e) {
      _setError('Failed to read RTC: $e');
      return null;
    }
  }

  void _setError(String error) {
    _errorMessage = error;
    debugPrint('BleProvider Error: $error');
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

  @override
  void dispose() {
    _sensorDataSubscription?.cancel();
    _logDataSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _bleService.dispose();
    super.dispose();
  }
}