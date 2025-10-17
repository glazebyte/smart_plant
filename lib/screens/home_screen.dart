import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/sensor_data.dart';
import '../widgets/sensor_card.dart';
import '../widgets/connection_status_card.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/status_indicator.dart';
import 'connection_screen.dart';
import 'control_screen.dart';
import 'schedule_screen.dart';
import 'logs_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    
    // Listen to sensor data stream
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bleProvider = Provider.of<BleProvider>(context, listen: false);
      final sensorDataProvider = Provider.of<SensorDataProvider>(context, listen: false);
      
      bleProvider.sensorDataStream.listen((sensorData) {
        sensorDataProvider.updateSensorData(sensorData);
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          DashboardTab(),
          ControlScreen(),
          ScheduleScreen(),
          LogsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.viewDashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.waterPump),
            label: 'Control',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.calendar),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.history),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.cog),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Plant Monitor'),
        actions: [
          Consumer<BleProvider>(
            builder: (context, bleProvider, child) {
              return IconButton(
                icon: Icon(
                  bleProvider.isConnected 
                    ? MdiIcons.bluetoothConnect 
                    : MdiIcons.bluetooth,
                  color: bleProvider.isConnected 
                    ? Colors.green 
                    : Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnectionScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer2<BleProvider, SensorDataProvider>(
        builder: (context, bleProvider, sensorProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              if (!bleProvider.isConnected) {
                await bleProvider.scanForDevices();
              }
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status
                  ConnectionStatusCard(),
                  const SizedBox(height: 16),

                  // Status Indicators
                  if (sensorProvider.hasData) ...[
                    Row(
                      children: [
                        Expanded(
                          child: StatusIndicator(
                            icon: MdiIcons.waterPercent,
                            label: 'Soil Moisture',
                            value: sensorProvider.needsWatering ? 'Low' : 'Good',
                            color: sensorProvider.needsWatering 
                              ? Colors.orange 
                              : Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatusIndicator(
                            icon: MdiIcons.battery,
                            label: 'Battery',
                            value: sensorProvider.lowBattery ? 'Low' : 'Good',
                            color: sensorProvider.lowBattery 
                              ? Colors.red 
                              : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sensor Cards
                  if (sensorProvider.hasData) ...[
                    Text(
                      'Current Readings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: SensorCard(
                            icon: MdiIcons.waterPercent,
                            label: 'Soil Moisture',
                            value: sensorProvider.latestSensorData!.soilMoisturePercentage,
                            color: _getSoilMoistureColor(sensorProvider.soilMoistureLevel!),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SensorCard(
                            icon: MdiIcons.waterOutline,
                            label: 'Humidity',
                            value: sensorProvider.latestSensorData!.humidityPercentage,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: SensorCard(
                            icon: MdiIcons.thermometer,
                            label: 'Temperature',
                            value: sensorProvider.latestSensorData!.temperatureCelsius,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SensorCard(
                            icon: MdiIcons.battery,
                            label: 'Battery',
                            value: sensorProvider.latestSensorData!.batteryVoltageString,
                            color: _getBatteryColor(sensorProvider.batteryLevel!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // No data state
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MdiIcons.leaf,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No sensor data available',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            bleProvider.isConnected 
                              ? 'Waiting for data from your smart plant...'
                              : 'Connect to your smart plant to view data',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Quick Actions
                  QuickActionsCard(),
                  const SizedBox(height: 16),

                  // Last Update Info
                  if (sensorProvider.hasData)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              MdiIcons.clockOutline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last Update',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  _formatDateTime(sensorProvider.latestSensorData!.dateTime),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Placeholder tabs - these will be implemented next
class ControlTab extends StatelessWidget {
  const ControlTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Control Tab - Coming Soon'),
      ),
    );
  }
}

class ScheduleTab extends StatelessWidget {
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Schedule Tab - Coming Soon'),
      ),
    );
  }
}

class LogsTab extends StatelessWidget {
  const LogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Logs Tab - Coming Soon'),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings Tab - Coming Soon'),
      ),
    );
  }
}