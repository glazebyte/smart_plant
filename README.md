# Smart Plant Monitor 🌱

A modern Flutter Android application for monitoring and controlling your smart plant system via Bluetooth Low Energy (BLE) connection to an ESP32 device.

## Features

### 📊 Real-time Monitoring
- **Soil Moisture**: Track soil moisture levels with visual indicators
- **Temperature & Humidity**: Monitor environmental conditions
- **Battery Status**: Keep track of device battery level
- **Live Dashboard**: Real-time sensor data with color-coded status indicators

### 💧 Smart Watering Control
- **Manual Control**: Trigger watering with customizable duration (5s - 5min)
- **Emergency Stop**: Immediately halt all watering operations
- **Quick Actions**: Pre-set watering durations (15s, 30s, 1min, 2min)
- **Visual Feedback**: Clear status indicators and progress tracking

### 📅 Automated Scheduling
- **Multiple Schedules**: Create and manage multiple watering schedules
- **Time-based Triggers**: Set specific times for automatic watering
- **Duration Control**: Customize watering duration for each schedule
- **Enable/Disable**: Easily toggle schedules on/off
- **Next Run Preview**: See when the next watering will occur

### 📈 Data Logging & History
- **Interactive Charts**: Visualize sensor data trends over time
- **Historical Data**: View detailed logs of all sensor readings
- **Data Export**: Download logs from ESP32 device
- **Trend Analysis**: Monitor patterns in soil moisture, temperature, and humidity

### 🔗 Device Management
- **BLE Connection**: Seamless Bluetooth Low Energy connectivity
- **Device Discovery**: Automatic scanning for smart plant devices
- **Connection Status**: Real-time connection monitoring
- **Time Synchronization**: Keep device RTC in sync

## ESP32 Device Protocol

The app communicates with your ESP32 device using these BLE characteristics:

### Service UUID
```
0000a000-0000-1000-8000-00805f9b34fb
```

### Characteristics

#### 1. Sensor Data (Notify/Read)
**UUID:** `0000a001-0000-1000-8000-00805f9b34fb`
```json
{"t": <timestamp>, "soil": <percentage>, "hum": <RH>, "temp": <celsius>, "bat": <volts>}
```

#### 2. Control (Write)
**UUID:** `0000a002-0000-1000-8000-00805f9b34fb`
```json
{"cmd": "trigger", "duration": 30}
{"cmd": "cancel"}
```

#### 3. Schedule (Read/Write)
**UUID:** `0000a003-0000-1000-8000-00805f9b34fb`
```json
{"slot": 1, "time": "07:30", "duration": 15, "enabled": 1}
```

#### 4. Logs (Read/Notify)
**UUID:** `0000a004-0000-1000-8000-00805f9b34fb`
```json
{"action": "get", "start": 0, "count": 100}
```

#### 5. RTC (Read/Write)
**UUID:** `0000a005-0000-1000-8000-00805f9b34fb`
```json
{"epoch": 1700000000}
```

## Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android development environment
- ESP32 device with smart plant firmware

### Build Instructions

1. **Clone the repository**
```bash
git clone <repository-url>
cd smart_plant
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate model files**
```bash
flutter packages pub run build_runner build
```

4. **Build APK**
```bash
flutter build apk --release
```

5. **Install on device**
```bash
flutter install
```

## App Architecture

### State Management
- **Provider Pattern**: Centralized state management using Provider package
- **BleProvider**: Manages Bluetooth connectivity and device communication
- **SensorDataProvider**: Handles sensor data storage and historical tracking

### Key Components
- **BLE Service**: Handles all Bluetooth Low Energy communication
- **Data Models**: JSON serializable models for sensor data, schedules, and logs
- **Theme System**: Consistent green-themed UI with light/dark mode support
- **Modular Screens**: Separate screens for dashboard, control, scheduling, logs, and settings

### Dependencies
- `flutter_blue_plus`: BLE communication
- `provider`: State management
- `fl_chart`: Data visualization
- `shared_preferences`: Local data storage
- `material_design_icons_flutter`: Rich icon set
- `json_annotation`: JSON serialization

## Device Setup

### ESP32 Requirements
Your ESP32 device should implement:
- **Soil moisture sensor** (analog reading)
- **DHT22/DHT11** for temperature and humidity
- **Solenoid valve** for water control
- **RTC module** for time keeping
- **BLE server** with the specified service and characteristics

### Recommended Hardware
- ESP32 development board
- Capacitive soil moisture sensor
- DHT22 temperature/humidity sensor
- 12V solenoid valve with relay
- DS3231 RTC module
- Water pump and tubing
- Power supply (battery + solar panel recommended)

## Usage

1. **Power on your ESP32 device**
2. **Open the Smart Plant Monitor app**
3. **Tap the Bluetooth icon** to scan for devices
4. **Select your device** from the list to connect
5. **Monitor real-time data** on the dashboard
6. **Set up watering schedules** in the Schedule tab
7. **Use manual controls** for immediate watering
8. **View historical data** in the Logs tab

## Troubleshooting

### Connection Issues
- Ensure ESP32 is powered and in range
- Check that Bluetooth is enabled on your phone
- Try restarting both the app and ESP32 device
- Verify the ESP32 firmware implements the correct BLE service

### Data Issues
- Check sensor connections on ESP32
- Verify sensor calibration
- Ensure stable power supply to ESP32
- Check for interference from other BLE devices

## Contributing

This project is open for contributions! Areas for improvement:
- Additional sensor support
- Advanced scheduling features
- Cloud data backup
- Plant care recommendations
- Multi-device support

## License

This project is released under the MIT License. See LICENSE file for details.

## Support

For support and questions:
- Check the troubleshooting guide above
- Review ESP32 device logs
- Ensure all hardware connections are secure
- Verify BLE service implementation on ESP32

---

**Happy Gardening! 🌱💚**
