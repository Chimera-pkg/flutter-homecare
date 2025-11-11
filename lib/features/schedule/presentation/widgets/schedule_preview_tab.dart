import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/timezone.dart' as tz;

class SchedulePreviewTab extends StatefulWidget {
  const SchedulePreviewTab({
    super.key,
  });

  @override
  State<SchedulePreviewTab> createState() => _SchedulePreviewTabState();
}

class _SchedulePreviewTabState extends State<SchedulePreviewTab> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _loadSlotsForDay(_selectedDay);
  }

  void _loadSlotsForDay(DateTime day) {
    context.read<ScheduleCubit>().loadPreviewSlots(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _loadSlotsForDay(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              _buildCalendar(),
              const SizedBox(height: 24),
              const Text(
                'Available Hours',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              _buildTimeSlotGrid(state.isPreviewLoading, state.availableSlots),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: _onDaySelected,
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: Const.aqua,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Const.aqua.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotGrid(bool isLoading, List<TimeSlot> slots) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (slots.isEmpty) {
      return const Center(child: Text('No available slots for this day.'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final absoluteTime = DateTime.parse(slot.startISO);
        final localTime = tz.TZDateTime.from(absoluteTime, tz.local);
        final startTime = DateFormat('HH:mm').format(localTime);
        return OutlinedButton(
          onPressed: null, // Read-only
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            disabledForegroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(),
          ),
          child: Text(startTime),
        );
      },
    );
  }
}
