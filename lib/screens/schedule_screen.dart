import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/ble_provider.dart';
import '../models/schedule.dart';
import '../l10n/app_localizations.dart';
import 'dart:developer';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<WaterSchedule> _schedules = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    if (!mounted) return;

    final bleProvider = Provider.of<BleProvider>(context, listen: false);
    if (!bleProvider.isConnected) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final schedules = await bleProvider.loadSchedules();
      log(
        'ScheduleScreen: Loaded ${schedules.length} schedules: $schedules',
        name: 'ScheduleScreen',
      );
      if (mounted) {
        setState(() {
          _schedules = schedules;
          _isLoading = false;
        });
        log(
          'ScheduleScreen: Updated state with ${_schedules.length} schedules',
          name: 'ScheduleScreen',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToLoadSchedules(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.wateringSchedule),
        actions: [
          IconButton(onPressed: _loadSchedules, icon: Icon(MdiIcons.refresh)),
        ],
      ),
      body: Consumer<BleProvider>(
        builder: (context, bleProvider, child) {
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.deviceNotConnected,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.connectToManageSchedules,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.orange[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Schedules List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _schedules.isEmpty
                    ? _buildEmptyState()
                    : _buildSchedulesList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<BleProvider>(
        builder: (context, bleProvider, child) {
          return FloatingActionButton(
            onPressed: bleProvider.isConnected ? _addNewSchedule : null,
            child: Icon(MdiIcons.plus),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(MdiIcons.calendarClock, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noSchedulesYet,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addFirstSchedule,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Consumer<BleProvider>(
            builder: (context, bleProvider, child) {
              return ElevatedButton.icon(
                onPressed: bleProvider.isConnected ? _addNewSchedule : null,
                icon: Icon(MdiIcons.plus),
                label: Text(AppLocalizations.of(context)!.addSchedule),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: schedule.isEnabled
                  ? Colors.green.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              child: Icon(
                schedule.isEnabled ? MdiIcons.waterPump : MdiIcons.waterPumpOff,
                color: schedule.isEnabled ? Colors.green : Colors.grey,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.scheduleSlot(schedule.slot),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: schedule.isEnabled ? null : Colors.grey,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      MdiIcons.clockOutline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text('${schedule.time} • ${schedule.durationText}'),
                  ],
                ),
                if (schedule.isEnabled &&
                    schedule.nextScheduledTime != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        MdiIcons.calendarClock,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.nextScheduled(_formatNextSchedule(schedule.nextScheduledTime!)),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            trailing: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Switch(
                  value: schedule.isEnabled,
                  onChanged: (value) => _toggleSchedule(schedule, value),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editSchedule(schedule);
                        break;
                      case 'delete':
                        _deleteSchedule(schedule);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(MdiIcons.pencil, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(MdiIcons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNextSchedule(DateTime nextTime) {
    final now = DateTime.now();
    final difference = nextTime.difference(now);

    if (difference.inHours < 24) {
      if (difference.inHours < 1) {
        return 'in ${difference.inMinutes}m';
      } else {
        return 'in ${difference.inHours}h ${difference.inMinutes % 60}m';
      }
    } else {
      return 'Tomorrow at ${nextTime.hour.toString().padLeft(2, '0')}:${nextTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _addNewSchedule() {
    _showScheduleDialog(null);
  }

  void _editSchedule(WaterSchedule schedule) {
    _showScheduleDialog(schedule);
  }

  void _showScheduleDialog(WaterSchedule? existingSchedule) {
    showDialog(
      context: context,
      builder: (context) => ScheduleDialog(
        schedule: existingSchedule,
        onSave: (schedule) async {
          await _saveSchedule(schedule);
        },
      ),
    );
  }

  Future<void> _saveSchedule(WaterSchedule schedule) async {
    final bleProvider = Provider.of<BleProvider>(context, listen: false);

    try {
      await bleProvider.saveSchedule(schedule);
      await _loadSchedules(); // Reload to get updated list

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.scheduleSavedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToSaveSchedule(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleSchedule(WaterSchedule schedule, bool enabled) async {
    final updatedSchedule = schedule.copyWith(enabled: enabled ? true : false);
    await _saveSchedule(updatedSchedule);
  }

  void _deleteSchedule(WaterSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteSchedule),
        content: Text(
          AppLocalizations.of(context)!.deleteScheduleConfirm(schedule.slot),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete by setting enabled to 0 and duration to 0
              final deletedSchedule = schedule.copyWith(
                enabled: false,
                duration: 0,
              );
              await _saveSchedule(deletedSchedule);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }
}

class ScheduleDialog extends StatefulWidget {
  final WaterSchedule? schedule;
  final Function(WaterSchedule) onSave;

  const ScheduleDialog({super.key, this.schedule, required this.onSave});

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  late TextEditingController _timeController;
  late int _duration;
  late bool _enabled;
  late int _slot;

  @override
  void initState() {
    super.initState();

    if (widget.schedule != null) {
      _timeController = TextEditingController(text: widget.schedule!.time);
      _enabled = widget.schedule!.isEnabled;
      _slot = widget.schedule!.slot;
      if (widget.schedule!.duration >= 5) {
        _duration = widget.schedule!.duration;
      } else {
        _duration = 30; // Default duration
      }
    } else {
      _timeController = TextEditingController(text: '07:00');
      _duration = 30;
      _enabled = true;
      _slot =
          DateTime.now().millisecondsSinceEpoch % 100; // Simple slot generation
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.schedule != null ? AppLocalizations.of(context)!.editSchedule : AppLocalizations.of(context)!.newSchedule),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time picker
          TextField(
            controller: _timeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.wateringTime,
              hintText: 'HH:MM',
              prefixIcon: Icon(MdiIcons.clockOutline),
            ),
            readOnly: true,
            onTap: _selectTime,
          ),
          const SizedBox(height: 16),

          // Duration slider
          Text(
            '${AppLocalizations.of(context)!.duration}: ${_formatDuration(_duration)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: _duration.toDouble(),
            min: 5,
            max: 300,
            divisions: 59,
            onChanged: (value) {
              setState(() {
                _duration = value.round();
              });
            },
          ),

          const SizedBox(height: 16),

          // Enabled switch
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.enableSchedule),
            value: _enabled,
            onChanged: (value) {
              setState(() {
                _enabled = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(onPressed: _saveSchedule, child: Text(AppLocalizations.of(context)!.save)),
      ],
    );
  }

  Future<void> _selectTime() async {
    final currentTime = TimeOfDay.now();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    if (selectedTime != null) {
      setState(() {
        _timeController.text =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      });
    }
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

  void _saveSchedule() {
    final schedule = WaterSchedule(
      slot: _slot,
      time: _timeController.text,
      duration: _duration,
      enabled: _enabled ? true : false,
    );

    widget.onSave(schedule);
    Navigator.pop(context);
  }
}
