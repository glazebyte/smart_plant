// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Plant Monitor';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get control => 'Control';

  @override
  String get schedule => 'Schedule';

  @override
  String get logs => 'Logs';

  @override
  String get settings => 'Settings';

  @override
  String get soilMoisture => 'Soil Moisture';

  @override
  String get humidity => 'Humidity';

  @override
  String get temperature => 'Temperature';

  @override
  String get currentReadings => 'Current Readings';

  @override
  String get noSensorData => 'No sensor data available';

  @override
  String get waitingForData => 'Waiting for data from your smart plant...';

  @override
  String get connectToViewData => 'Connect to your smart plant to view data';

  @override
  String get lastUpdate => 'Last Update';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get deviceConnection => 'Device Connection';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get scanning => 'Scanning...';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connected => 'Connected';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get noDevicesFound => 'No devices found';

  @override
  String get devicePairingInstructions =>
      'Make sure your smart plant device is powered on\nand in pairing mode';

  @override
  String get scanAgain => 'Scan Again';

  @override
  String get scanForDevices => 'Scan for Devices';

  @override
  String get scanningForDevices => 'Scanning for smart plant devices...';

  @override
  String get disconnect => 'Disconnect';

  @override
  String connectedTo(String deviceName) {
    return 'Connected to $deviceName';
  }

  @override
  String failedToConnect(String error) {
    return 'Failed to connect: $error';
  }

  @override
  String get manualControl => 'Manual Control';

  @override
  String get deviceNotConnected => 'Device Not Connected';

  @override
  String get connectToUseControls =>
      'Connect to your smart plant device to use manual controls';

  @override
  String get plantStatus => 'Plant Status';

  @override
  String get needsWater => 'Needs Water';

  @override
  String get moderate => 'Moderate';

  @override
  String get wellWatered => 'Well Watered';

  @override
  String get cold => 'Cold';

  @override
  String get cool => 'Cool';

  @override
  String get optimal => 'Optimal';

  @override
  String get warm => 'Warm';

  @override
  String get hot => 'Hot';

  @override
  String get normal => 'Normal';

  @override
  String get manualWatering => 'Manual Watering';

  @override
  String get duration => 'Duration';

  @override
  String get quickSelect => 'Quick Select';

  @override
  String get startWatering => 'Start Watering';

  @override
  String get stopWatering => 'Stop Watering';

  @override
  String get connectToEnableControl =>
      'Connect to device to enable manual control';

  @override
  String get emergencyControls => 'Emergency Controls';

  @override
  String get emergencyStop => 'Emergency Stop';

  @override
  String get immediatelyStopWatering => 'Immediately stop all watering';

  @override
  String get stop => 'STOP';

  @override
  String wateringStartedFor(String duration) {
    return 'Watering started for $duration';
  }

  @override
  String failedToStartWatering(String error) {
    return 'Failed to start watering: $error';
  }

  @override
  String get wateringStopped => 'Watering stopped';

  @override
  String failedToStopWatering(String error) {
    return 'Failed to stop watering: $error';
  }

  @override
  String get emergencyStopAll => 'EMERGENCY STOP - All watering stopped';

  @override
  String emergencyStopFailed(String error) {
    return 'Emergency stop failed: $error';
  }

  @override
  String get wateringSchedule => 'Watering Schedule';

  @override
  String get connectToManageSchedules =>
      'Connect to your device to manage watering schedules';

  @override
  String get noSchedulesYet => 'No Schedules Yet';

  @override
  String get addFirstSchedule =>
      'Add your first watering schedule to\nkeep your plant healthy automatically';

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String scheduleSlot(int slot) {
    return 'Schedule $slot';
  }

  @override
  String nextScheduled(String time) {
    return 'Next: $time';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSchedule => 'Delete Schedule';

  @override
  String deleteScheduleConfirm(int slot) {
    return 'Are you sure you want to delete Schedule $slot?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get newSchedule => 'New Schedule';

  @override
  String get editSchedule => 'Edit Schedule';

  @override
  String get wateringTime => 'Watering Time';

  @override
  String get enableSchedule => 'Enable Schedule';

  @override
  String get save => 'Save';

  @override
  String failedToLoadSchedules(String error) {
    return 'Failed to load schedules: $error';
  }

  @override
  String get scheduleSavedSuccessfully => 'Schedule saved successfully';

  @override
  String failedToSaveSchedule(String error) {
    return 'Failed to save schedule: $error';
  }

  @override
  String get dataLogs => 'Data Logs';

  @override
  String get charts => 'Charts';

  @override
  String get history => 'History';

  @override
  String get noChartData => 'No Chart Data';

  @override
  String get connectForCharts =>
      'Connect to your device and wait for\nsensor data to view charts';

  @override
  String get noLogData => 'No Log Data';

  @override
  String get tapDownloadLogs =>
      'Tap the download button to fetch\nlog data from your device';

  @override
  String get downloadLogs => 'Download Logs';

  @override
  String get connectToDownloadLogs => 'Connect to device to download log data';

  @override
  String get timeRange => 'Time Range';

  @override
  String get hours24 => '24 Hours';

  @override
  String get days7 => '7 Days';

  @override
  String get days30 => '30 Days';

  @override
  String get logDataRequested => 'Log data requested successfully';

  @override
  String failedToRequestLogs(String error) {
    return 'Failed to request logs: $error';
  }

  @override
  String get device => 'Device';

  @override
  String get notConnected => 'Not connected';

  @override
  String get connect => 'Connect';

  @override
  String get syncDeviceTime => 'Sync Device Time';

  @override
  String get updateDeviceRTC => 'Update device RTC with current time';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get clearLocalData => 'Clear Local Data';

  @override
  String removeStoredReadings(int count) {
    return 'Remove all stored sensor readings ($count entries)';
  }

  @override
  String get downloadDeviceLogs => 'Download Device Logs';

  @override
  String get fetchHistoricalData => 'Fetch historical data from device';

  @override
  String get about => 'About';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get deviceInfo => 'Device Info';

  @override
  String get esp32System => 'ESP32 Smart Plant Monitoring System';

  @override
  String get madeWithFlutter => 'Made with Flutter';

  @override
  String get builtForPlantCare => 'Built for plant care enthusiasts';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get deviceTimeSynced => 'Device time synchronized successfully';

  @override
  String failedToSyncTime(String error) {
    return 'Failed to sync time: $error';
  }

  @override
  String get clearLocalDataConfirm =>
      'This will remove all stored sensor readings from your device. This action cannot be undone.\n\nAre you sure you want to continue?';

  @override
  String get clearData => 'Clear Data';

  @override
  String get localDataCleared => 'Local data cleared successfully';

  @override
  String get logDownloadRequested =>
      'Log download requested. Check the Logs tab.';

  @override
  String get good => 'Good';

  @override
  String get low => 'Low';

  @override
  String get scan => 'Scan';

  @override
  String get tapScanToFind => 'Tap scan to find your smart plant device';

  @override
  String devicesFound(int count) {
    return '$count device(s) found';
  }

  @override
  String get lookingForDevices => 'Looking for smart plant devices...';

  @override
  String get establishingConnection => 'Establishing connection...';

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get waterNow => 'Water Now';

  @override
  String get seconds30 => '30 seconds';

  @override
  String get syncTime => 'Sync Time';

  @override
  String get updateRTC => 'Update RTC';

  @override
  String get refreshData => 'Refresh Data';

  @override
  String get getLatest => 'Get latest';

  @override
  String get viewLogs => 'View Logs';

  @override
  String get dataHistory => 'Data history';

  @override
  String get connectToUseQuickActions =>
      'Connect to your smart plant to use quick actions';

  @override
  String get waterPlant => 'Water Plant';

  @override
  String get selectWateringDuration => 'Select watering duration:';

  @override
  String durationSeconds(int duration) {
    return 'Duration: $duration seconds';
  }

  @override
  String get timeSynchronizedSuccessfully => 'Time synchronized successfully';

  @override
  String get dataRefreshRequested => 'Data refresh requested';

  @override
  String get logDataRequestedShort => 'Log data requested';
}
