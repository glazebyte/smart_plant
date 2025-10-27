import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Smart Plant Monitor'**
  String get appTitle;

  /// Dashboard tab label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Control tab label
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get control;

  /// Schedule tab label
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Logs tab label
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Soil moisture sensor label
  ///
  /// In en, this message translates to:
  /// **'Soil Moisture'**
  String get soilMoisture;

  /// Humidity sensor label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Temperature sensor label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Header for current sensor readings
  ///
  /// In en, this message translates to:
  /// **'Current Readings'**
  String get currentReadings;

  /// Message when no sensor data is available
  ///
  /// In en, this message translates to:
  /// **'No sensor data available'**
  String get noSensorData;

  /// Message when waiting for sensor data
  ///
  /// In en, this message translates to:
  /// **'Waiting for data from your smart plant...'**
  String get waitingForData;

  /// Message when device is not connected
  ///
  /// In en, this message translates to:
  /// **'Connect to your smart plant to view data'**
  String get connectToViewData;

  /// Label for last update time
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// Time format for just now
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Time format for minutes ago
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// Time format for hours ago
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// Device connection screen title
  ///
  /// In en, this message translates to:
  /// **'Device Connection'**
  String get deviceConnection;

  /// Connection status: disconnected
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Connection status: scanning
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// Connection status: connecting
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get connecting;

  /// Connection status: connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Connection error header
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// Message when no devices are found
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevicesFound;

  /// Instructions for device pairing
  ///
  /// In en, this message translates to:
  /// **'Make sure your smart plant device is powered on\nand in pairing mode'**
  String get devicePairingInstructions;

  /// Button to scan for devices again
  ///
  /// In en, this message translates to:
  /// **'Scan Again'**
  String get scanAgain;

  /// Button to scan for devices
  ///
  /// In en, this message translates to:
  /// **'Scan for Devices'**
  String get scanForDevices;

  /// Message when scanning for devices
  ///
  /// In en, this message translates to:
  /// **'Scanning for smart plant devices...'**
  String get scanningForDevices;

  /// Button to disconnect from device
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Message when connected to device
  ///
  /// In en, this message translates to:
  /// **'Connected to {deviceName}'**
  String connectedTo(String deviceName);

  /// Error message when connection fails
  ///
  /// In en, this message translates to:
  /// **'Failed to connect: {error}'**
  String failedToConnect(String error);

  /// Manual control screen title
  ///
  /// In en, this message translates to:
  /// **'Manual Control'**
  String get manualControl;

  /// Warning when device is not connected
  ///
  /// In en, this message translates to:
  /// **'Device Not Connected'**
  String get deviceNotConnected;

  /// Message to connect device for controls
  ///
  /// In en, this message translates to:
  /// **'Connect to your smart plant device to use manual controls'**
  String get connectToUseControls;

  /// Plant status section header
  ///
  /// In en, this message translates to:
  /// **'Plant Status'**
  String get plantStatus;

  /// Soil moisture status: needs water
  ///
  /// In en, this message translates to:
  /// **'Needs Water'**
  String get needsWater;

  /// Soil moisture status: moderate
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Soil moisture status: well watered
  ///
  /// In en, this message translates to:
  /// **'Well Watered'**
  String get wellWatered;

  /// Temperature status: cold
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get cold;

  /// Temperature status: cool
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get cool;

  /// Temperature status: optimal
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get optimal;

  /// Temperature status: warm
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get warm;

  /// Temperature status: hot
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hot;

  /// General status: normal
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Manual watering section header
  ///
  /// In en, this message translates to:
  /// **'Manual Watering'**
  String get manualWatering;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Quick select duration header
  ///
  /// In en, this message translates to:
  /// **'Quick Select'**
  String get quickSelect;

  /// Button to start watering
  ///
  /// In en, this message translates to:
  /// **'Start Watering'**
  String get startWatering;

  /// Button to stop watering
  ///
  /// In en, this message translates to:
  /// **'Stop Watering'**
  String get stopWatering;

  /// Message to connect for manual control
  ///
  /// In en, this message translates to:
  /// **'Connect to device to enable manual control'**
  String get connectToEnableControl;

  /// Emergency controls section header
  ///
  /// In en, this message translates to:
  /// **'Emergency Controls'**
  String get emergencyControls;

  /// Emergency stop button
  ///
  /// In en, this message translates to:
  /// **'Emergency Stop'**
  String get emergencyStop;

  /// Emergency stop description
  ///
  /// In en, this message translates to:
  /// **'Immediately stop all watering'**
  String get immediatelyStopWatering;

  /// Stop button text
  ///
  /// In en, this message translates to:
  /// **'STOP'**
  String get stop;

  /// Message when watering starts
  ///
  /// In en, this message translates to:
  /// **'Watering started for {duration}'**
  String wateringStartedFor(String duration);

  /// Error when watering fails to start
  ///
  /// In en, this message translates to:
  /// **'Failed to start watering: {error}'**
  String failedToStartWatering(String error);

  /// Message when watering is stopped
  ///
  /// In en, this message translates to:
  /// **'Watering stopped'**
  String get wateringStopped;

  /// Error when watering fails to stop
  ///
  /// In en, this message translates to:
  /// **'Failed to stop watering: {error}'**
  String failedToStopWatering(String error);

  /// Emergency stop confirmation message
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY STOP - All watering stopped'**
  String get emergencyStopAll;

  /// Emergency stop failure message
  ///
  /// In en, this message translates to:
  /// **'Emergency stop failed: {error}'**
  String emergencyStopFailed(String error);

  /// Watering schedule screen title
  ///
  /// In en, this message translates to:
  /// **'Watering Schedule'**
  String get wateringSchedule;

  /// Message to connect for schedule management
  ///
  /// In en, this message translates to:
  /// **'Connect to your device to manage watering schedules'**
  String get connectToManageSchedules;

  /// Message when no schedules exist
  ///
  /// In en, this message translates to:
  /// **'No Schedules Yet'**
  String get noSchedulesYet;

  /// Instructions to add first schedule
  ///
  /// In en, this message translates to:
  /// **'Add your first watering schedule to\nkeep your plant healthy automatically'**
  String get addFirstSchedule;

  /// Button to add schedule
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
  String get addSchedule;

  /// Schedule slot label
  ///
  /// In en, this message translates to:
  /// **'Schedule {slot}'**
  String scheduleSlot(int slot);

  /// Next scheduled time
  ///
  /// In en, this message translates to:
  /// **'Next: {time}'**
  String nextScheduled(String time);

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Delete schedule dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Schedule'**
  String get deleteSchedule;

  /// Delete schedule confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete Schedule {slot}?'**
  String deleteScheduleConfirm(int slot);

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// New schedule dialog title
  ///
  /// In en, this message translates to:
  /// **'New Schedule'**
  String get newSchedule;

  /// Edit schedule dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get editSchedule;

  /// Watering time field label
  ///
  /// In en, this message translates to:
  /// **'Watering Time'**
  String get wateringTime;

  /// Enable schedule switch label
  ///
  /// In en, this message translates to:
  /// **'Enable Schedule'**
  String get enableSchedule;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Error loading schedules
  ///
  /// In en, this message translates to:
  /// **'Failed to load schedules: {error}'**
  String failedToLoadSchedules(String error);

  /// Schedule save success message
  ///
  /// In en, this message translates to:
  /// **'Schedule saved successfully'**
  String get scheduleSavedSuccessfully;

  /// Error saving schedule
  ///
  /// In en, this message translates to:
  /// **'Failed to save schedule: {error}'**
  String failedToSaveSchedule(String error);

  /// Data logs screen title
  ///
  /// In en, this message translates to:
  /// **'Data Logs'**
  String get dataLogs;

  /// Charts tab label
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get charts;

  /// History tab label
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Message when no chart data available
  ///
  /// In en, this message translates to:
  /// **'No Chart Data'**
  String get noChartData;

  /// Instructions to get chart data
  ///
  /// In en, this message translates to:
  /// **'Connect to your device and wait for\nsensor data to view charts'**
  String get connectForCharts;

  /// Message when no log data available
  ///
  /// In en, this message translates to:
  /// **'No Log Data'**
  String get noLogData;

  /// Instructions to download logs
  ///
  /// In en, this message translates to:
  /// **'Tap the download button to fetch\nlog data from your device'**
  String get tapDownloadLogs;

  /// Download logs button
  ///
  /// In en, this message translates to:
  /// **'Download Logs'**
  String get downloadLogs;

  /// Message to connect for log download
  ///
  /// In en, this message translates to:
  /// **'Connect to device to download log data'**
  String get connectToDownloadLogs;

  /// Time range selector label
  ///
  /// In en, this message translates to:
  /// **'Time Range'**
  String get timeRange;

  /// 24 hours time range
  ///
  /// In en, this message translates to:
  /// **'24 Hours'**
  String get hours24;

  /// 7 days time range
  ///
  /// In en, this message translates to:
  /// **'7 Days'**
  String get days7;

  /// 30 days time range
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get days30;

  /// Log request success message
  ///
  /// In en, this message translates to:
  /// **'Log data requested successfully'**
  String get logDataRequested;

  /// Log request error message
  ///
  /// In en, this message translates to:
  /// **'Failed to request logs: {error}'**
  String failedToRequestLogs(String error);

  /// Device settings section
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// Device not connected status
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// Connect button
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Sync device time option
  ///
  /// In en, this message translates to:
  /// **'Sync Device Time'**
  String get syncDeviceTime;

  /// Update device RTC description
  ///
  /// In en, this message translates to:
  /// **'Update device RTC with current time'**
  String get updateDeviceRTC;

  /// Data management section
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Clear local data option
  ///
  /// In en, this message translates to:
  /// **'Clear Local Data'**
  String get clearLocalData;

  /// Clear data description
  ///
  /// In en, this message translates to:
  /// **'Remove all stored sensor readings ({count} entries)'**
  String removeStoredReadings(int count);

  /// Download device logs option
  ///
  /// In en, this message translates to:
  /// **'Download Device Logs'**
  String get downloadDeviceLogs;

  /// Download logs description
  ///
  /// In en, this message translates to:
  /// **'Fetch historical data from device'**
  String get fetchHistoricalData;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// Device info option
  ///
  /// In en, this message translates to:
  /// **'Device Info'**
  String get deviceInfo;

  /// ESP32 system description
  ///
  /// In en, this message translates to:
  /// **'ESP32 Smart Plant Monitoring System'**
  String get esp32System;

  /// Made with Flutter label
  ///
  /// In en, this message translates to:
  /// **'Made with Flutter'**
  String get madeWithFlutter;

  /// App purpose description
  ///
  /// In en, this message translates to:
  /// **'Built for plant care enthusiasts'**
  String get builtForPlantCare;

  /// Current status section
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// Time sync success message
  ///
  /// In en, this message translates to:
  /// **'Device time synchronized successfully'**
  String get deviceTimeSynced;

  /// Time sync error message
  ///
  /// In en, this message translates to:
  /// **'Failed to sync time: {error}'**
  String failedToSyncTime(String error);

  /// Clear data confirmation message
  ///
  /// In en, this message translates to:
  /// **'This will remove all stored sensor readings from your device. This action cannot be undone.\n\nAre you sure you want to continue?'**
  String get clearLocalDataConfirm;

  /// Clear data button
  ///
  /// In en, this message translates to:
  /// **'Clear Data'**
  String get clearData;

  /// Data clear success message
  ///
  /// In en, this message translates to:
  /// **'Local data cleared successfully'**
  String get localDataCleared;

  /// Log download request message
  ///
  /// In en, this message translates to:
  /// **'Log download requested. Check the Logs tab.'**
  String get logDownloadRequested;

  /// Good status indicator
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Low status indicator
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Scan button text
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// Instruction to scan for devices
  ///
  /// In en, this message translates to:
  /// **'Tap scan to find your smart plant device'**
  String get tapScanToFind;

  /// Number of devices found
  ///
  /// In en, this message translates to:
  /// **'{count} device(s) found'**
  String devicesFound(int count);

  /// Status when scanning for devices
  ///
  /// In en, this message translates to:
  /// **'Looking for smart plant devices...'**
  String get lookingForDevices;

  /// Status when connecting to device
  ///
  /// In en, this message translates to:
  /// **'Establishing connection...'**
  String get establishingConnection;

  /// Label for unknown device
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Quick action button to water now
  ///
  /// In en, this message translates to:
  /// **'Water Now'**
  String get waterNow;

  /// 30 seconds duration
  ///
  /// In en, this message translates to:
  /// **'30 seconds'**
  String get seconds30;

  /// Quick action button to sync time
  ///
  /// In en, this message translates to:
  /// **'Sync Time'**
  String get syncTime;

  /// Update RTC subtitle
  ///
  /// In en, this message translates to:
  /// **'Update RTC'**
  String get updateRTC;

  /// Quick action button to refresh data
  ///
  /// In en, this message translates to:
  /// **'Refresh Data'**
  String get refreshData;

  /// Get latest data subtitle
  ///
  /// In en, this message translates to:
  /// **'Get latest'**
  String get getLatest;

  /// Quick action button to view logs
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get viewLogs;

  /// Data history subtitle
  ///
  /// In en, this message translates to:
  /// **'Data history'**
  String get dataHistory;

  /// Message to connect device for quick actions
  ///
  /// In en, this message translates to:
  /// **'Connect to your smart plant to use quick actions'**
  String get connectToUseQuickActions;

  /// Water plant dialog title
  ///
  /// In en, this message translates to:
  /// **'Water Plant'**
  String get waterPlant;

  /// Select watering duration instruction
  ///
  /// In en, this message translates to:
  /// **'Select watering duration:'**
  String get selectWateringDuration;

  /// Duration in seconds
  ///
  /// In en, this message translates to:
  /// **'Duration: {duration} seconds'**
  String durationSeconds(int duration);

  /// Time sync success message
  ///
  /// In en, this message translates to:
  /// **'Time synchronized successfully'**
  String get timeSynchronizedSuccessfully;

  /// Data refresh request message
  ///
  /// In en, this message translates to:
  /// **'Data refresh requested'**
  String get dataRefreshRequested;

  /// Short log data request message
  ///
  /// In en, this message translates to:
  /// **'Log data requested'**
  String get logDataRequestedShort;

  /// Plant assistant chat screen title
  ///
  /// In en, this message translates to:
  /// **'Plant Assistant'**
  String get plantAssistant;

  /// Clear chat button and dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// Clear chat confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all chat messages? This action cannot be undone.'**
  String get clearChatConfirm;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Message when no chat messages exist
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with your Plant Assistant'**
  String get startConversation;

  /// Chat error message
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please check your API key and try again.'**
  String get chatError;

  /// Chat input placeholder text
  ///
  /// In en, this message translates to:
  /// **'Ask about your plant...'**
  String get typeMessage;

  /// Typing indicator text
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// Chat tab label
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
