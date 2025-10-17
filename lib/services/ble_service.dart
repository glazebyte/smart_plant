import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/sensor_data.dart';
import '../models/schedule.dart';
import '../models/log_entry.dart';

class BleService {
  static const String deviceName = 'SmartPlant';
  
  // Service and Characteristic UUIDs
  static const String serviceUuid = '0000a000-0000-1000-8000-00805f9b34fb';
  static const String sensorDataUuid = '0000a001-0000-1000-8000-00805f9b34fb';
  static const String controlUuid = '0000a002-0000-1000-8000-00805f9b34fb';
  static const String scheduleUuid = '0000a003-0000-1000-8000-00805f9b34fb';
  static const String logsUuid = '0000a004-0000-1000-8000-00805f9b34fb';
  static const String rtcUuid = '0000a005-0000-1000-8000-00805f9b34fb';

  BluetoothDevice? _device;
  BluetoothCharacteristic? _sensorDataCharacteristic;
  BluetoothCharacteristic? _controlCharacteristic;
  BluetoothCharacteristic? _scheduleCharacteristic;
  BluetoothCharacteristic? _logsCharacteristic;
  BluetoothCharacteristic? _rtcCharacteristic;

  final StreamController<SensorData> _sensorDataController = StreamController<SensorData>.broadcast();
  final StreamController<String> _logDataController = StreamController<String>.broadcast();
  final StreamController<BleConnectionState> _connectionStateController = StreamController<BleConnectionState>.broadcast();

  Stream<SensorData> get sensorDataStream => _sensorDataController.stream;
  Stream<String> get logDataStream => _logDataController.stream;
  Stream<BleConnectionState> get connectionStateStream => _connectionStateController.stream;

  BleConnectionState _connectionState = BleConnectionState.disconnected;
  BleConnectionState get connectionState => _connectionState;

  bool get isConnected => _connectionState == BleConnectionState.connected;

  Future<void> initialize() async {
    try {
      // Check if Bluetooth is supported
      if (await FlutterBluePlus.isSupported == false) {
        throw Exception('Bluetooth not supported by this device');
      }

      // Turn on Bluetooth if it's off
      if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      debugPrint('Error initializing BLE: $e');
      rethrow;
    }
  }

  Future<List<BluetoothDevice>> scanForDevices({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      _updateConnectionState(BleConnectionState.scanning);
      
      final List<BluetoothDevice> devices = [];
      
      // Start scanning
      await FlutterBluePlus.startScan(timeout: timeout);
      
      // Listen to scan results
      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (result.device.platformName.isNotEmpty && 
              (result.device.platformName.toLowerCase().contains('smartplant') ||
               result.device.platformName.toLowerCase().contains('plant'))) {
            if (!devices.contains(result.device)) {
              devices.add(result.device);
            }
          }
        }
      });

      // Wait for scan to complete
      await Future.delayed(timeout);
      await subscription.cancel();
      await FlutterBluePlus.stopScan();
      
      _updateConnectionState(BleConnectionState.disconnected);
      return devices;
    } catch (e) {
      _updateConnectionState(BleConnectionState.disconnected);
      debugPrint('Error scanning for devices: $e');
      rethrow;
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _updateConnectionState(BleConnectionState.connecting);
      _device = device;

      // Connect to device
      await device.connect(timeout: const Duration(seconds: 15));
      
      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      
      // Find our service
      BluetoothService? smartPlantService;
      for (BluetoothService service in services) {
        if (service.uuid.toString().toLowerCase() == serviceUuid.toLowerCase()) {
          smartPlantService = service;
          break;
        }
      }

      if (smartPlantService == null) {
        throw Exception('Smart Plant service not found');
      }

      // Get characteristics
      for (BluetoothCharacteristic characteristic in smartPlantService.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();
        
        switch (uuid) {
          case sensorDataUuid:
            _sensorDataCharacteristic = characteristic;
            break;
          case controlUuid:
            _controlCharacteristic = characteristic;
            break;
          case scheduleUuid:
            _scheduleCharacteristic = characteristic;
            break;
          case logsUuid:
            _logsCharacteristic = characteristic;
            break;
          case rtcUuid:
            _rtcCharacteristic = characteristic;
            break;
        }
      }

      // Subscribe to sensor data notifications
      if (_sensorDataCharacteristic != null) {
        await _sensorDataCharacteristic!.setNotifyValue(true);
        _sensorDataCharacteristic!.value.listen(_handleSensorData);
      }

      // Subscribe to log data notifications
      if (_logsCharacteristic != null) {
        await _logsCharacteristic!.setNotifyValue(true);
        _logsCharacteristic!.value.listen(_handleLogData);
      }

      _updateConnectionState(BleConnectionState.connected);
    } catch (e) {
      _updateConnectionState(BleConnectionState.disconnected);
      debugPrint('Error connecting to device: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      if (_device != null) {
        await _device!.disconnect();
      }
      _device = null;
      _sensorDataCharacteristic = null;
      _controlCharacteristic = null;
      _scheduleCharacteristic = null;
      _logsCharacteristic = null;
      _rtcCharacteristic = null;
      
      _updateConnectionState(BleConnectionState.disconnected);
    } catch (e) {
      debugPrint('Error disconnecting: $e');
      _updateConnectionState(BleConnectionState.disconnected);
    }
  }

  Future<void> sendControlCommand(ControlCommand command) async {
    if (_controlCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or control characteristic not available');
    }

    try {
      final jsonString = jsonEncode(command.toJson());
      final bytes = utf8.encode(jsonString);
      await _controlCharacteristic!.write(bytes);
    } catch (e) {
      debugPrint('Error sending control command: $e');
      rethrow;
    }
  }

  Future<void> writeSchedule(WaterSchedule schedule) async {
    if (_scheduleCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or schedule characteristic not available');
    }

    try {
      final jsonString = jsonEncode(schedule.toJson());
      final bytes = utf8.encode(jsonString);
      await _scheduleCharacteristic!.write(bytes);
    } catch (e) {
      debugPrint('Error writing schedule: $e');
      rethrow;
    }
  }

  Future<List<WaterSchedule>> readSchedules() async {
    if (_scheduleCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or schedule characteristic not available');
    }

    try {
      final bytes = await _scheduleCharacteristic!.read();
      final jsonString = utf8.decode(bytes);
      final data = jsonDecode(jsonString);
      
      if (data is List) {
        return data.map((item) => WaterSchedule.fromJson(item)).toList();
      } else {
        return [WaterSchedule.fromJson(data)];
      }
    } catch (e) {
      debugPrint('Error reading schedules: $e');
      rethrow;
    }
  }

  Future<void> requestLogs({int start = 0, int? count}) async {
    if (_logsCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or logs characteristic not available');
    }

    try {
      final request = LogRequest.get(start: start, count: count);
      final jsonString = jsonEncode(request.toJson());
      final bytes = utf8.encode(jsonString);
      await _logsCharacteristic!.write(bytes);
    } catch (e) {
      debugPrint('Error requesting logs: $e');
      rethrow;
    }
  }

  Future<void> syncRTC() async {
    if (_rtcCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or RTC characteristic not available');
    }

    try {
      final now = DateTime.now();
      final epochSeconds = now.millisecondsSinceEpoch ~/ 1000;
      final rtcData = {'epoch': epochSeconds};
      final jsonString = jsonEncode(rtcData);
      final bytes = utf8.encode(jsonString);
      await _rtcCharacteristic!.write(bytes);
    } catch (e) {
      debugPrint('Error syncing RTC: $e');
      rethrow;
    }
  }

  Future<DateTime?> readRTC() async {
    if (_rtcCharacteristic == null || !isConnected) {
      throw Exception('Not connected to device or RTC characteristic not available');
    }

    try {
      final bytes = await _rtcCharacteristic!.read();
      final jsonString = utf8.decode(bytes);
      final data = jsonDecode(jsonString);
      
      if (data['epoch'] != null) {
        final epochSeconds = data['epoch'] as int;
        return DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
      }
      return null;
    } catch (e) {
      debugPrint('Error reading RTC: $e');
      rethrow;
    }
  }

  void _handleSensorData(List<int> data) {
    try {
      final jsonString = utf8.decode(data);
      final jsonData = jsonDecode(jsonString);
      final sensorData = SensorData.fromJson(jsonData);
      _sensorDataController.add(sensorData);
    } catch (e) {
      debugPrint('Error parsing sensor data: $e');
    }
  }

  void _handleLogData(List<int> data) {
    try {
      final logString = utf8.decode(data);
      _logDataController.add(logString);
    } catch (e) {
      debugPrint('Error parsing log data: $e');
    }
  }

  void _updateConnectionState(BleConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }

  void dispose() {
    _sensorDataController.close();
    _logDataController.close();
    _connectionStateController.close();
  }
}

enum BleConnectionState {
  disconnected,
  scanning,
  connecting,
  connected,
}