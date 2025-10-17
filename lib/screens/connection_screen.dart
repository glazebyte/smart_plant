import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../providers/ble_provider.dart';
import '../services/ble_service.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    super.initState();
    // Start scanning when screen loads if not connected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bleProvider = Provider.of<BleProvider>(context, listen: false);
      if (!bleProvider.isConnected && !bleProvider.isScanning) {
        bleProvider.scanForDevices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Connection'),
        actions: [
          Consumer<BleProvider>(
            builder: (context, bleProvider, child) {
              return IconButton(
                onPressed: bleProvider.isScanning ? null : bleProvider.scanForDevices,
                icon: Icon(
                  bleProvider.isScanning ? MdiIcons.loading : MdiIcons.refresh,
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<BleProvider>(
        builder: (context, bleProvider, child) {
          return Column(
            children: [
              // Connection Status Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: _getStatusColor(bleProvider.connectionState).withOpacity(0.1),
                child: Column(
                  children: [
                    Icon(
                      _getStatusIcon(bleProvider.connectionState),
                      size: 48,
                      color: _getStatusColor(bleProvider.connectionState),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStatusText(bleProvider.connectionState),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _getStatusColor(bleProvider.connectionState),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (bleProvider.connectedDevice != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        bleProvider.connectedDevice!.platformName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              // Error Message
              if (bleProvider.errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connection Error',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bleProvider.errorMessage!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: bleProvider.clearError,
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),

              // Device List
              Expanded(
                child: bleProvider.availableDevices.isEmpty
                    ? _buildEmptyState(bleProvider)
                    : _buildDeviceList(bleProvider),
              ),

              // Action Buttons
              if (bleProvider.isConnected)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: bleProvider.disconnect,
                      icon: Icon(MdiIcons.bluetoothOff),
                      label: const Text('Disconnect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                )
              else if (!bleProvider.isScanning)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: bleProvider.scanForDevices,
                      icon: Icon(MdiIcons.magnify),
                      label: const Text('Scan for Devices'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BleProvider bleProvider) {
    if (bleProvider.isScanning) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Scanning for smart plant devices...'),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.bluetooth,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No devices found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Make sure your smart plant device is powered on\nand in pairing mode',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: bleProvider.scanForDevices,
            icon: Icon(MdiIcons.refresh),
            label: const Text('Scan Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(BleProvider bleProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bleProvider.availableDevices.length,
      itemBuilder: (context, index) {
        final device = bleProvider.availableDevices[index];
        final isConnected = bleProvider.connectedDevice == device;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isConnected 
                ? Colors.green 
                : Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                isConnected 
                  ? MdiIcons.bluetoothConnect 
                  : MdiIcons.leaf,
                color: isConnected 
                  ? Colors.white 
                  : Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text(
              device.platformName.isNotEmpty 
                ? device.platformName 
                : 'Unknown Device',
              style: TextStyle(
                fontWeight: isConnected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.remoteId.toString()),
                if (isConnected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CONNECTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: isConnected
                ? Icon(Icons.check_circle, color: Colors.green)
                : bleProvider.isConnecting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.bluetooth),
            onTap: isConnected 
                ? null 
                : () => _connectToDevice(bleProvider, device),
          ),
        );
      },
    );
  }

  void _connectToDevice(BleProvider bleProvider, BluetoothDevice device) async {
    try {
      await bleProvider.connectToDevice(device);
      if (mounted && bleProvider.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connected to ${device.platformName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getStatusIcon(BleConnectionState state) {
    switch (state) {
      case BleConnectionState.disconnected:
        return MdiIcons.bluetooth;
      case BleConnectionState.scanning:
        return MdiIcons.magnify;
      case BleConnectionState.connecting:
        return MdiIcons.bluetoothConnect;
      case BleConnectionState.connected:
        return MdiIcons.bluetoothConnect;
    }
  }

  Color _getStatusColor(BleConnectionState state) {
    switch (state) {
      case BleConnectionState.disconnected:
        return Colors.grey;
      case BleConnectionState.scanning:
        return Colors.blue;
      case BleConnectionState.connecting:
        return Colors.orange;
      case BleConnectionState.connected:
        return Colors.green;
    }
  }

  String _getStatusText(BleConnectionState state) {
    switch (state) {
      case BleConnectionState.disconnected:
        return 'Disconnected';
      case BleConnectionState.scanning:
        return 'Scanning...';
      case BleConnectionState.connecting:
        return 'Connecting...';
      case BleConnectionState.connected:
        return 'Connected';
    }
  }
}