import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/sensor_data.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Consumer2<BleProvider, SensorDataProvider>(
        builder: (context, bleProvider, sensorProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Device Settings Section
              Text(
                AppLocalizations.of(context)!.device,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        bleProvider.isConnected 
                          ? MdiIcons.bluetoothConnect 
                          : MdiIcons.bluetooth,
                        color: bleProvider.isConnected 
                          ? Colors.green 
                          : Colors.grey,
                      ),
                      title: Text(AppLocalizations.of(context)!.deviceConnection),
                      subtitle: Text(
                        bleProvider.isConnected
                          ? AppLocalizations.of(context)!.connectedTo(bleProvider.connectedDevice?.platformName ?? 'Unknown')
                          : AppLocalizations.of(context)!.notConnected,
                      ),
                      trailing: bleProvider.isConnected
                          ? TextButton(
                              onPressed: bleProvider.disconnect,
                              child: Text(AppLocalizations.of(context)!.disconnect),
                            )
                          : TextButton(
                              onPressed: bleProvider.scanForDevices,
                              child: Text(AppLocalizations.of(context)!.connect),
                            ),
                    ),
                    if (bleProvider.isConnected) ...[
                      const Divider(),
                      ListTile(
                        leading: Icon(MdiIcons.clockOutline),
                        title: Text(AppLocalizations.of(context)!.syncDeviceTime),
                        subtitle: Text(AppLocalizations.of(context)!.updateDeviceRTC),
                        trailing: IconButton(
                          onPressed: () => _syncTime(context, bleProvider),
                          icon: Icon(MdiIcons.refresh),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Data Management Section
              Text(
                AppLocalizations.of(context)!.dataManagement,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(MdiIcons.database, color: Colors.blue),
                      title: Text(AppLocalizations.of(context)!.clearLocalData),
                      subtitle: Text(
                        AppLocalizations.of(context)!.removeStoredReadings(sensorProvider.historicalData.length),
                      ),
                      trailing: IconButton(
                        onPressed: sensorProvider.historicalData.isNotEmpty
                            ? () => _clearData(context, sensorProvider)
                            : null,
                        icon: Icon(MdiIcons.delete, color: Colors.red),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(MdiIcons.download, color: Colors.green),
                      title: Text(AppLocalizations.of(context)!.downloadDeviceLogs),
                      subtitle: Text(AppLocalizations.of(context)!.fetchHistoricalData),
                      trailing: IconButton(
                        onPressed: bleProvider.isConnected
                            ? () => _downloadLogs(context, bleProvider)
                            : null,
                        icon: Icon(MdiIcons.download),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // App Information Section
              Text(
                AppLocalizations.of(context)!.about,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(MdiIcons.leaf, color: Colors.green),
                      title: Text(AppLocalizations.of(context)!.appTitle),
                      subtitle: Text(AppLocalizations.of(context)!.version),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(MdiIcons.information),
                      title: Text(AppLocalizations.of(context)!.deviceInfo),
                      subtitle: Text(AppLocalizations.of(context)!.esp32System),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(MdiIcons.heart, color: Colors.red),
                      title: Text(AppLocalizations.of(context)!.madeWithFlutter),
                      subtitle: Text(AppLocalizations.of(context)!.builtForPlantCare),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Device Status Section
              if (sensorProvider.hasData) ...[
                Text(
                  AppLocalizations.of(context)!.currentStatus,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.waterPercent,
                          label: AppLocalizations.of(context)!.soilMoisture,
                          value: sensorProvider.latestSensorData!.soilMoisturePercentage,
                          color: _getSoilMoistureColor(sensorProvider.soilMoistureLevel!),
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.thermometer,
                          label: AppLocalizations.of(context)!.temperature,
                          value: sensorProvider.latestSensorData!.temperatureCelsius,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.waterOutline,
                          label: AppLocalizations.of(context)!.humidity,
                          value: sensorProvider.latestSensorData!.humidityPercentage,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        Row(
                          children: [
                            Icon(MdiIcons.clockOutline, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Last update: ${_formatLastUpdate(sensorProvider.latestSensorData!.dateTime)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getSoilMoistureColor(SoilMoistureLevel level) {
    switch (level) {
      case SoilMoistureLevel.low:
        return Colors.red;
      case SoilMoistureLevel.medium:
        return Colors.orange;
      case SoilMoistureLevel.high:
        return Colors.green;
    }
  }


  String _formatLastUpdate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  void _syncTime(BuildContext context, BleProvider bleProvider) async {
    try {
      await bleProvider.syncRTC();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.deviceTimeSynced),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToSyncTime(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearData(BuildContext context, SensorDataProvider sensorProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearLocalData),
        content: Text(AppLocalizations.of(context)!.clearLocalDataConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await sensorProvider.clearAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.localDataCleared),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.clearData),
          ),
        ],
      ),
    );
  }

  void _downloadLogs(BuildContext context, BleProvider bleProvider) async {
    try {
      await bleProvider.requestLogs(start: 0, count: 100);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.logDownloadRequested),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToRequestLogs(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}