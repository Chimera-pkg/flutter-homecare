import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/cubit/schedule/domain/usecases/index.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_cubit.dart';

class DateOverrideFormDialog extends StatefulWidget {
  final DateTime selectedDate;
  final ProviderAvailabilityOverride? scheduleOverride;

  const DateOverrideFormDialog(
      {super.key, required this.selectedDate, this.scheduleOverride});

  bool get isEditing => scheduleOverride != null;

  @override
  State<DateOverrideFormDialog> createState() => _DateOverrideFormDialogState();
}

class _DateOverrideFormDialogState extends State<DateOverrideFormDialog> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _startTime =
          TimeOfDay.fromDateTime(widget.scheduleOverride!.startDatetime);
      _endTime = TimeOfDay.fromDateTime(widget.scheduleOverride!.endDatetime);
    }
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

  void _onSave() {
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

    final startDateTime = widget.selectedDate.copyWith(
      hour: _startTime!.hour,
      minute: _startTime!.minute,
    );
    final endDateTime = widget.selectedDate.copyWith(
      hour: _endTime!.hour,
      minute: _endTime!.minute,
    );

    if (widget.isEditing) {
      final params = UpdateOverrideParams(
        id: widget.scheduleOverride!.id,
        startDatetime: startDateTime,
        endDatetime: endDateTime,
      );
      context.read<ScheduleCubit>().updateOverrideRule(params);
    } else {
      final params = AddOverrideParams(
        startDatetime: startDateTime,
        endDatetime: endDateTime,
      );
      context.read<ScheduleCubit>().saveOverride(params);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          const Text('Add Specific Hours'),
          Text(
            DateFormat('MMMM d, yyyy').format(widget.selectedDate),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey),
          ),
        ],
      ),
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
