import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:m2health/const.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/usecases/add_availability.dart';
import 'package:m2health/features/schedule/domain/usecases/update_availability.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';

class AvailabilityFormDialog extends StatefulWidget {
  final int dayIndex;
  final ProviderAvailability? availability;

  const AvailabilityFormDialog({
    super.key,
    required this.dayIndex,
    this.availability,
  });

  bool get isEditing => availability != null;

  @override
  State<AvailabilityFormDialog> createState() => _AvailabilitFormyDialogState();
}

class _AvailabilitFormyDialogState extends State<AvailabilityFormDialog> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  tz.Location? _providerLocation;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _initTimesInLocalZone();
    }
  }

  // ADDED: Helper to get the provider's tz.Location
  tz.Location _getProviderLocation() {
    if (_providerLocation != null) return _providerLocation!;

    final String? providerTimezoneStr = widget.availability?.timezone;
    if (providerTimezoneStr != null) {
      try {
        _providerLocation = tz.getLocation(providerTimezoneStr);
        return _providerLocation!;
      } catch (e) {
        log('Invalid provider timezone: $providerTimezoneStr. Falling back to local.',
            name: 'AvailabilityFormDialog');
        // Fallback to user's local timezone
      }
    }
    _providerLocation = tz.local;
    return _providerLocation!;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _initTimesInLocalZone() {
    final providerLocation = _getProviderLocation();
    final tz.TZDateTime nowInLocal = tz.TZDateTime.now(tz.local);

    // Convert Start Time
    final TimeOfDay wallStartTime = _parseTime(widget.availability!.startTime);
    final tz.TZDateTime providerStartTime = tz.TZDateTime(
      providerLocation,
      nowInLocal.year,
      nowInLocal.month,
      nowInLocal.day,
      wallStartTime.hour,
      wallStartTime.minute,
    );
    // Convert to user's local time
    final tz.TZDateTime localStartTime =
        tz.TZDateTime.from(providerStartTime, tz.local);
    _startTime = TimeOfDay.fromDateTime(localStartTime);

    // Convert End Time
    final TimeOfDay wallEndTime = _parseTime(widget.availability!.endTime);
    final tz.TZDateTime providerEndTime = tz.TZDateTime(
      providerLocation,
      nowInLocal.year,
      nowInLocal.month,
      nowInLocal.day,
      wallEndTime.hour,
      wallEndTime.minute,
    );
    // Convert to user's local time
    final tz.TZDateTime localEndTime =
        tz.TZDateTime.from(providerEndTime, tz.local);
    _endTime = TimeOfDay.fromDateTime(localEndTime);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _onSave() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end time.')),
      );
      return;
    }

    if (_startTime!.hour > _endTime!.hour ||
        (_startTime!.hour == _endTime!.hour &&
            _startTime!.minute >= _endTime!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }

    if (widget.isEditing) {
      final formattedStart = _formatTime(_startTime!);
      final formattedEnd = _formatTime(_endTime!);

      final params = UpdateAvailabilityParams(
        id: widget.availability!.id,
        dayOfWeek: widget.dayIndex,
        startTime: formattedStart,
        endTime: formattedEnd,
      );
      context.read<ScheduleCubit>().updateWeeklyRule(params);
    } else {
      final formattedStart = _formatTime(_startTime!);
      final formattedEnd = _formatTime(_endTime!);

      final params = AddAvailabilityParams(
        dayOfWeek: widget.dayIndex,
        startTime: formattedStart,
        endTime: formattedEnd,
      );
      context.read<ScheduleCubit>().saveWeeklyRule(params);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Hours' : 'Add Hours'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimePickerChip(
                label: 'Start',
                time: _startTime,
                onTap: () => _selectTime(context, true),
              ),
              const Text('-'),
              _TimePickerChip(
                label: 'End',
                time: _endTime,
                onTap: () => _selectTime(context, false),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(backgroundColor: Const.aqua),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _TimePickerChip extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimePickerChip({required this.label, this.time, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(time?.format(context) ?? label),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}
