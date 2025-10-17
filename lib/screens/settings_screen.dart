import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/sensor_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer2<BleProvider, SensorDataProvider>(
        builder: (context, bleProvider, sensorProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Device Settings Section
              Text(
                'Device',
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
                      title: const Text('Device Connection'),
                      subtitle: Text(
                        bleProvider.isConnected 
                          ? 'Connected to ${bleProvider.connectedDevice?.platformName ?? 'Unknown'}'
                          : 'Not connected',
                      ),
                      trailing: bleProvider.isConnected
                          ? TextButton(
                              onPressed: bleProvider.disconnect,
                              child: const Text('Disconnect'),
                            )
                          : TextButton(
                              onPressed: bleProvider.scanForDevices,
                              child: const Text('Connect'),
                            ),
                    ),
                    if (bleProvider.isConnected) ...[
                      const Divider(),
                      ListTile(
                        leading: Icon(MdiIcons.clockOutline),
                        title: const Text('Sync Device Time'),
                        subtitle: const Text('Update device RTC with current time'),
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
                'Data Management',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(MdiIcons.database, color: Colors.blue),
                      title: const Text('Clear Local Data'),
                      subtitle: Text(
                        'Remove all stored sensor readings (${sensorProvider.historicalData.length} entries)',
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
                      title: const Text('Download Device Logs'),
                      subtitle: const Text('Fetch historical data from device'),
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
                'About',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(MdiIcons.leaf, color: Colors.green),
                      title: const Text('Smart Plant Monitor'),
                      subtitle: const Text('Version 1.0.0'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(MdiIcons.information),
                      title: const Text('Device Info'),
                      subtitle: const Text('ESP32 Smart Plant Monitoring System'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(MdiIcons.heart, color: Colors.red),
                      title: const Text('Made with Flutter'),
                      subtitle: const Text('Built for plant care enthusiasts'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Device Status Section
              if (sensorProvider.hasData) ...[
                Text(
                  'Current Status',
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
                          label: 'Soil Moisture',
                          value: sensorProvider.latestSensorData!.soilMoisturePercentage,
                          color: _getSoilMoistureColor(sensorProvider.soilMoistureLevel!),
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.thermometer,
                          label: 'Temperature',
                          value: sensorProvider.latestSensorData!.temperatureCelsius,
                          color: Colors.orange,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.waterOutline,
                          label: 'Humidity',
                          value: sensorProvider.latestSensorData!.humidityPercentage,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          context,
                          icon: MdiIcons.battery,
                          label: 'Battery',
                          value: sensorProvider.latestSensorData!.batteryVoltageString,
                          color: _getBatteryColor(sensorProvider.batteryLevel!),
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

  Color _getBatteryColor(BatteryLevel level) {
    switch (level) {
      case BatteryLevel.low:
        return Colors.red;
      case BatteryLevel.medium:
        return Colors.orange;
      case BatteryLevel.high:
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
          const SnackBar(
            content: Text('Device time synchronized successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync time: $e'),
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
        title: const Text('Clear Local Data'),
        content: const Text(
          'This will remove all stored sensor readings from your device. '
          'This action cannot be undone.\n\n'
          'Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await sensorProvider.clearAllData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Local data cleared successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Data'),
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
          const SnackBar(
            content: Text('Log download requested. Check the Logs tab.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request logs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}