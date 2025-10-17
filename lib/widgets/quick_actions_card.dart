import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Consumer2<BleProvider, SensorDataProvider>(
              builder: (context, bleProvider, sensorProvider, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionButton(
                            icon: MdiIcons.waterPump,
                            label: 'Water Now',
                            subtitle: '30 seconds',
                            color: Colors.blue,
                            onPressed: bleProvider.isConnected
                                ? () => _showWateringDialog(context, bleProvider)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionButton(
                            icon: MdiIcons.clockOutline,
                            label: 'Sync Time',
                            subtitle: 'Update RTC',
                            color: Colors.orange,
                            onPressed: bleProvider.isConnected
                                ? () => _syncTime(context, bleProvider)
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionButton(
                            icon: MdiIcons.refresh,
                            label: 'Refresh Data',
                            subtitle: 'Get latest',
                            color: Colors.green,
                            onPressed: bleProvider.isConnected
                                ? () => _refreshData(context, bleProvider)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionButton(
                            icon: MdiIcons.history,
                            label: 'View Logs',
                            subtitle: 'Data history',
                            color: Colors.purple,
                            onPressed: bleProvider.isConnected
                                ? () => _viewLogs(context, bleProvider)
                                : null,
                          ),
                        ),
                      ],
                    ),
                    if (!bleProvider.isConnected) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.informationOutline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Connect to your smart plant to use quick actions',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWateringDialog(BuildContext context, BleProvider bleProvider) {
    int duration = 30;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Water Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select watering duration:'),
              const SizedBox(height: 16),
              Slider(
                value: duration.toDouble(),
                min: 5,
                max: 120,
                divisions: 23,
                label: '${duration}s',
                onChanged: (value) {
                  setState(() {
                    duration = value.round();
                  });
                },
              ),
              Text('Duration: ${duration} seconds'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                bleProvider.triggerWatering(durationSeconds: duration);
                _showSnackBar(context, 'Watering started for ${duration} seconds');
              },
              child: const Text('Start Watering'),
            ),
          ],
        ),
      ),
    );
  }

  void _syncTime(BuildContext context, BleProvider bleProvider) async {
    try {
      await bleProvider.syncRTC();
      _showSnackBar(context, 'Time synchronized successfully');
    } catch (e) {
      _showSnackBar(context, 'Failed to sync time: $e', isError: true);
    }
  }

  void _refreshData(BuildContext context, BleProvider bleProvider) {
    // The sensor data is automatically refreshed via BLE notifications
    _showSnackBar(context, 'Data refresh requested');
  }

  void _viewLogs(BuildContext context, BleProvider bleProvider) async {
    try {
      await bleProvider.requestLogs(start: 0, count: 100);
      _showSnackBar(context, 'Log data requested');
    } catch (e) {
      _showSnackBar(context, 'Failed to request logs: $e', isError: true);
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback? onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    
    return Material(
      color: isEnabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isEnabled ? color : Colors.grey,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isEnabled ? color : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isEnabled ? Colors.grey[600] : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}