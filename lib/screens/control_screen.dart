import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/sensor_data.dart';
import '../l10n/app_localizations.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  double _wateringDuration = 30.0; // seconds
  bool _isWatering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manualControl),
      ),
      body: Consumer2<BleProvider, SensorDataProvider>(
        builder: (context, bleProvider, sensorProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status Warning
                if (!bleProvider.isConnected)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(MdiIcons.alertCircle, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.deviceNotConnected,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)!.connectToUseControls,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // Current Sensor Status
                if (sensorProvider.hasData) ...[
                  Text(
                    AppLocalizations.of(context)!.plantStatus,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusItem(
                                  icon: MdiIcons.waterPercent,
                                  label: AppLocalizations.of(context)!.soilMoisture,
                                  value: sensorProvider.latestSensorData!.soilMoisturePercentage,
                                  color: _getSoilMoistureColor(sensorProvider.soilMoistureLevel!),
                                  status: _getSoilMoistureStatus(sensorProvider.soilMoistureLevel!, context),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStatusItem(
                                  icon: MdiIcons.thermometer,
                                  label: AppLocalizations.of(context)!.temperature,
                                  value: sensorProvider.latestSensorData!.temperatureCelsius,
                                  color: Colors.orange,
                                  status: _getTemperatureStatus(sensorProvider.temperatureCelsius!, context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatusItem(
                                  icon: MdiIcons.waterOutline,
                                  label: AppLocalizations.of(context)!.humidity,
                                  value: sensorProvider.latestSensorData!.humidityPercentage,
                                  color: Colors.blue,
                                  status: AppLocalizations.of(context)!.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Manual Watering Control
                Text(
                  AppLocalizations.of(context)!.manualWatering,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Duration Slider
                        Row(
                          children: [
                            Icon(MdiIcons.timer, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.duration,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Slider(
                          value: _wateringDuration,
                          min: 5,
                          max: 300,
                          divisions: 59,
                          label: _formatDuration(_wateringDuration.round()),
                          onChanged: _isWatering ? null : (value) {
                            setState(() {
                              _wateringDuration = value;
                            });
                          },
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('5s', style: Theme.of(context).textTheme.bodySmall),
                            Text(
                              _formatDuration(_wateringDuration.round()),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('5m', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                        
                        const SizedBox(height: 24),

                        // Quick Duration Buttons
                        Text(
                          AppLocalizations.of(context)!.quickSelect,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [15, 30, 60, 120].map((seconds) => 
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: OutlinedButton(
                                  onPressed: _isWatering ? null : () {
                                    setState(() {
                                      _wateringDuration = seconds.toDouble();
                                    });
                                  },
                                  child: Text(_formatDuration(seconds)),
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                        
                        const SizedBox(height: 24),

                        // Main Control Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: bleProvider.isConnected && !_isWatering
                                ? () => _startWatering(bleProvider)
                                : _isWatering
                                    ? () => _stopWatering(bleProvider)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isWatering 
                                  ? Colors.red 
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(_isWatering ? MdiIcons.stop : MdiIcons.waterPump),
                                const SizedBox(width: 8),
                                Text(
                                  _isWatering
                                      ? AppLocalizations.of(context)!.stopWatering
                                      : AppLocalizations.of(context)!.startWatering,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        if (!bleProvider.isConnected) ...[
                          const SizedBox(height: 12),
                          Text(
                            AppLocalizations.of(context)!.connectToEnableControl,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Emergency Controls
                Text(
                  AppLocalizations.of(context)!.emergencyControls,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(MdiIcons.stopCircle, color: Colors.red),
                          title: Text(AppLocalizations.of(context)!.emergencyStop),
                          subtitle: Text(AppLocalizations.of(context)!.immediatelyStopWatering),
                          trailing: ElevatedButton(
                            onPressed: bleProvider.isConnected 
                                ? () => _emergencyStop(bleProvider)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(AppLocalizations.of(context)!.stop),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required String status,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '${minutes}m';
      } else {
        return '${minutes}m ${remainingSeconds}s';
      }
    }
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

  String _getSoilMoistureStatus(SoilMoistureLevel level, BuildContext context) {
    switch (level) {
      case SoilMoistureLevel.low:
        return AppLocalizations.of(context)!.needsWater;
      case SoilMoistureLevel.medium:
        return AppLocalizations.of(context)!.moderate;
      case SoilMoistureLevel.high:
        return AppLocalizations.of(context)!.wellWatered;
    }
  }


  String _getTemperatureStatus(double temperature, BuildContext context) {
    if (temperature < 15) return AppLocalizations.of(context)!.cold;
    if (temperature < 25) return AppLocalizations.of(context)!.cool;
    if (temperature < 30) return AppLocalizations.of(context)!.optimal;
    if (temperature < 35) return AppLocalizations.of(context)!.warm;
    return AppLocalizations.of(context)!.hot;
  }

  void _startWatering(BleProvider bleProvider) async {
    setState(() {
      _isWatering = true;
    });

    try {
      await bleProvider.triggerWatering(durationSeconds: _wateringDuration.round());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.wateringStartedFor(_formatDuration(_wateringDuration.round()))),
            backgroundColor: Colors.green,
          ),
        );

        // Auto-stop the UI state after the duration
        Future.delayed(Duration(seconds: _wateringDuration.round()), () {
          if (mounted) {
            setState(() {
              _isWatering = false;
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        _isWatering = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToStartWatering(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _stopWatering(BleProvider bleProvider) async {
    try {
      await bleProvider.cancelWatering();
      setState(() {
        _isWatering = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.wateringStopped),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToStopWatering(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _emergencyStop(BleProvider bleProvider) async {
    try {
      await bleProvider.cancelWatering();
      setState(() {
        _isWatering = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.emergencyStopAll),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.emergencyStopFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}