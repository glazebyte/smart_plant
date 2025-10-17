import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../services/ble_service.dart';

class ConnectionStatusCard extends StatelessWidget {
  const ConnectionStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BleProvider>(
      builder: (context, bleProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatusIcon(bleProvider.connectionState),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getStatusTitle(bleProvider.connectionState),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getStatusDescription(bleProvider),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (bleProvider.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bleProvider.errorMessage!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: bleProvider.clearError,
                                icon: const Icon(Icons.close, size: 16),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (bleProvider.connectionState == BleConnectionState.disconnected)
                  ElevatedButton.icon(
                    onPressed: bleProvider.scanForDevices,
                    icon: Icon(MdiIcons.magnify),
                    label: const Text('Scan'),
                  ),
                if (bleProvider.connectionState == BleConnectionState.connected)
                  TextButton.icon(
                    onPressed: bleProvider.disconnect,
                    icon: Icon(MdiIcons.bluetoothOff),
                    label: const Text('Disconnect'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIcon(BleConnectionState state) {
    IconData iconData;
    Color color;

    switch (state) {
      case BleConnectionState.disconnected:
        iconData = MdiIcons.bluetooth;
        color = Colors.grey;
        break;
      case BleConnectionState.scanning:
        iconData = MdiIcons.magnify;
        color = Colors.blue;
        break;
      case BleConnectionState.connecting:
        iconData = MdiIcons.bluetoothConnect;
        color = Colors.orange;
        break;
      case BleConnectionState.connected:
        iconData = MdiIcons.bluetoothConnect;
        color = Colors.green;
        break;
    }

    Widget icon = Icon(iconData, color: color, size: 32);
    
    if (state == BleConnectionState.scanning || state == BleConnectionState.connecting) {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          icon,
        ],
      );
    }

    return icon;
  }

  String _getStatusTitle(BleConnectionState state) {
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

  String _getStatusDescription(BleProvider bleProvider) {
    switch (bleProvider.connectionState) {
      case BleConnectionState.disconnected:
        if (bleProvider.availableDevices.isEmpty) {
          return 'Tap scan to find your smart plant device';
        } else {
          return '${bleProvider.availableDevices.length} device(s) found';
        }
      case BleConnectionState.scanning:
        return 'Looking for smart plant devices...';
      case BleConnectionState.connecting:
        return 'Establishing connection...';
      case BleConnectionState.connected:
        return bleProvider.connectedDevice?.platformName ?? 'Unknown device';
    }
  }
}