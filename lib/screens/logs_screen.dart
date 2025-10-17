import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/ble_provider.dart';
import '../providers/sensor_data_provider.dart';
import '../models/log_entry.dart';
import '../models/sensor_data.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoadingLogs = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Logs'),
        actions: [
          Consumer<BleProvider>(
            builder: (context, bleProvider, child) {
              return IconButton(
                onPressed: bleProvider.isConnected && !_isLoadingLogs
                    ? _requestLogs
                    : null,
                icon: _isLoadingLogs
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(MdiIcons.download),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(MdiIcons.chartLine),
              text: 'Charts',
            ),
            Tab(
              icon: Icon(MdiIcons.formatListBulleted),
              text: 'History',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChartsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildChartsTab() {
    return Consumer<SensorDataProvider>(
      builder: (context, sensorProvider, child) {
        if (sensorProvider.historicalData.isEmpty) {
          return _buildEmptyChartsState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Range Selector
              _buildTimeRangeSelector(),
              const SizedBox(height: 24),

              // Soil Moisture Chart
              _buildChartCard(
                title: 'Soil Moisture',
                icon: MdiIcons.waterPercent,
                color: Colors.blue,
                data: _getSoilMoistureData(sensorProvider),
                unit: '%',
              ),
              const SizedBox(height: 16),

              // Temperature Chart
              _buildChartCard(
                title: 'Temperature',
                icon: MdiIcons.thermometer,
                color: Colors.orange,
                data: _getTemperatureData(sensorProvider),
                unit: '°C',
              ),
              const SizedBox(height: 16),

              // Humidity Chart
              _buildChartCard(
                title: 'Humidity',
                icon: MdiIcons.waterOutline,
                color: Colors.teal,
                data: _getHumidityData(sensorProvider),
                unit: '%',
              ),
              const SizedBox(height: 16),

              // Battery Chart
              _buildChartCard(
                title: 'Battery Voltage',
                icon: MdiIcons.battery,
                color: Colors.green,
                data: _getBatteryData(sensorProvider),
                unit: 'V',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer2<BleProvider, SensorDataProvider>(
      builder: (context, bleProvider, sensorProvider, child) {
        return Column(
          children: [
            // Connection Warning
            if (!bleProvider.isConnected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
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
                      child: Text(
                        'Connect to device to download log data',
                        style: TextStyle(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),

            // Log Entries List
            Expanded(
              child: sensorProvider.logEntries.isEmpty
                  ? _buildEmptyHistoryState()
                  : _buildLogsList(sensorProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyChartsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.chartLine,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Chart Data',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect to your device and wait for\nsensor data to view charts',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistoryState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.history,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No Log Data',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the download button to fetch\nlog data from your device',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Consumer<BleProvider>(
            builder: (context, bleProvider, child) {
              return ElevatedButton.icon(
                onPressed:
                    bleProvider.isConnected && !_isLoadingLogs ? _requestLogs : null,
                icon: Icon(MdiIcons.download),
                label: const Text('Download Logs'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Time Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement 24h filter
                    },
                    child: const Text('24 Hours'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement 7d filter
                    },
                    child: const Text('7 Days'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement 30d filter
                    },
                    child: const Text('30 Days'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<FlSpot> data,
    required String unit,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatChartTime(value.toInt()),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(0)}$unit',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data,
                      isCurved: true,
                      color: color,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsList(SensorDataProvider sensorProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sensorProvider.logEntries.length,
      itemBuilder: (context, index) {
        final log = sensorProvider.logEntries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: Icon(
              MdiIcons.leaf,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(log.formattedDateTime),
            subtitle: Text(_getLogSummary(log)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (log.soilMoisture != null)
                      _buildLogDetailRow(
                        icon: MdiIcons.waterPercent,
                        label: 'Soil Moisture',
                        value: log.soilMoisturePercentage,
                        color: Colors.blue,
                      ),
                    if (log.humidity != null)
                      _buildLogDetailRow(
                        icon: MdiIcons.waterOutline,
                        label: 'Humidity',
                        value: log.humidityPercentage,
                        color: Colors.teal,
                      ),
                    if (log.temperature != null)
                      _buildLogDetailRow(
                        icon: MdiIcons.thermometer,
                        label: 'Temperature',
                        value: log.temperatureCelsius,
                        color: Colors.orange,
                      ),
                    if (log.batteryVoltage != null)
                      _buildLogDetailRow(
                        icon: MdiIcons.battery,
                        label: 'Battery',
                        value: log.batteryVoltageString,
                        color: Colors.green,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
      ),
    );
  }

  List<FlSpot> _getSoilMoistureData(SensorDataProvider provider) {
    final data = provider.getDataForLastHours(24);
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.soilMoisture);
    }).toList();
  }

  List<FlSpot> _getTemperatureData(SensorDataProvider provider) {
    final data = provider.getDataForLastHours(24);
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.temperature);
    }).toList();
  }

  List<FlSpot> _getHumidityData(SensorDataProvider provider) {
    final data = provider.getDataForLastHours(24);
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.humidity);
    }).toList();
  }

  List<FlSpot> _getBatteryData(SensorDataProvider provider) {
    final data = provider.getDataForLastHours(24);
    return data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.batteryVoltage);
    }).toList();
  }

  String _formatChartTime(int index) {
    // Simple time formatting for chart
    return '${index}h';
  }

  String _getLogSummary(LogEntry log) {
    final parts = <String>[];
    if (log.soilMoisture != null) parts.add('Soil: ${log.soilMoisturePercentage}');
    if (log.temperature != null) parts.add('Temp: ${log.temperatureCelsius}');
    return parts.take(2).join(' • ');
  }

  Future<void> _requestLogs() async {
    final bleProvider = Provider.of<BleProvider>(context, listen: false);
    final sensorProvider = Provider.of<SensorDataProvider>(context, listen: false);

    if (!bleProvider.isConnected) return;

    setState(() {
      _isLoadingLogs = true;
    });

    try {
      // Clear existing logs
      sensorProvider.clearLogEntries();

      // Request logs from device
      await bleProvider.requestLogs(start: 0, count: 100);

      // Listen for log data and parse it
      final subscription = bleProvider.logDataStream.listen((logString) {
        try {
          final lines = logString.split('\n');
          for (final line in lines) {
            if (line.trim().isNotEmpty) {
              final logData = Map<String, dynamic>.from(
                  jsonDecode(line));
              final logEntry = LogEntry.fromJson(logData);
              sensorProvider.addLogEntry(logEntry);
            }
          }
        } catch (e) {
          debugPrint('Failed to parse log line: $e');
        }
      });

      // Stop listening after a timeout
      Future.delayed(const Duration(seconds: 10), () {
        subscription.cancel();
        if (mounted) {
          setState(() {
            _isLoadingLogs = false;
          });
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Log data requested successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoadingLogs = false;
      });

      if (mounted) {
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