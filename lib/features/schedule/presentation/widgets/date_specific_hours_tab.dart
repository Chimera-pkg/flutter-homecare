import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:m2health/features/schedule/presentation/widgets/date_override_form_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class DateSpecificHoursTab extends StatefulWidget {
  const DateSpecificHoursTab({super.key});

  @override
  State<DateSpecificHoursTab> createState() => _DateSpecificHoursTabState();
}

class _DateSpecificHoursTabState extends State<DateSpecificHoursTab> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Find if there is an override for the selected day
        final currentOverride = state.overrides.firstWhere(
          (o) => isSameDay(o.date, _selectedDay),
          orElse: () => ProviderAvailabilityOverride(
            date: _selectedDay,
            isUnavailble: false,
            slots: const [],
          ),
        );

        final bool isRealOverride =
            state.overrides.any((o) => isSameDay(o.date, _selectedDay));

        return ListView(
          children: [
            _buildCalendar(state),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDateControlPanel(
                    context, currentOverride, isRealOverride),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendar(ScheduleState state) {
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: _focusedDay,
      currentDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: _onDaySelected,
      calendarFormat: CalendarFormat.month,
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
          color: Const.aqua.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: Colors.green.shade800,
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        // Load events to show dots on calendar
        return state.overrides.where((o) => isSameDay(o.date, day)).toList();
      },
    );
  }

  Widget _buildDateControlPanel(BuildContext context,
      ProviderAvailabilityOverride override, bool isRealOverride) {
    return Column(
      children: [
        // Header: Date + Revert
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(_selectedDay),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (isRealOverride)
              TextButton.icon(
                onPressed: () => _confirmRevert(context),
                icon: const Icon(Icons.undo, size: 18),
                label: const Text('Revert to Weekly'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  visualDensity: VisualDensity.compact,
                ),
              )
          ],
        ),
        const SizedBox(height: 16),

        // Availability Toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: SwitchListTile(
            title:
                const Text('I am unavailable', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Mark this specific date as a Day Off',
                style: TextStyle(fontSize: 12)),
            value: override.isUnavailble,
            activeColor: Colors.red,
            onChanged: (bool value) {
              if (value) {
                // User wants to be unavailable
                log("Setting date unavailable: $_selectedDay");
                context.read<ScheduleCubit>().setDateUnavailable(_selectedDay);
              } else {
                // User wants to be available (Custom Hours)
                // We initialize with a default slot or empty
                // Let's prompt them to add a slot directly
                context.read<ScheduleCubit>().addSlotToDate(
                    _selectedDay,
                    _selectedDay.copyWith(hour: 9, minute: 0),
                    _selectedDay.copyWith(hour: 17, minute: 0));
              }
            },
          ),
        ),
        const SizedBox(height: 24),

        // Time Slots List
        if (!override.isUnavailble) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Specific Hours',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _showAddSlotDialog(context),
                icon: const Icon(Icons.add_circle, color: Const.aqua, size: 28),
              ),
            ],
          ),
          if (override.slots.isEmpty && isRealOverride)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("No slots added yet. You appear unavailable.",
                  style: TextStyle(color: Colors.orange)),
            ),
          if (!isRealOverride)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 40, color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Using Weekly Schedule',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                        onPressed: () => _showAddSlotDialog(context),
                        child: const Text("Customize Hours for this Date"))
                  ],
                ),
              ),
            )
          else
            ...override.slots.map((slot) => _buildSlotItem(context, slot)),
        ]
      ],
    );
  }

  Widget _buildSlotItem(BuildContext context, TimeSlot slot) {
    final start = _formatIsoTime(slot.startTime);
    final end = _formatIsoTime(slot.endTime);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        dense: true,
        leading: const Icon(Icons.access_time, color: Const.aqua),
        title: Text('$start - $end',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () {
            context
                .read<ScheduleCubit>()
                .removeSlotFromDate(_selectedDay, slot);
          },
        ),
      ),
    );
  }

  String _formatIsoTime(String isoString) {
    final dateTime = DateTime.parse(isoString).toLocal();
    return DateFormat('HH:mm').format(dateTime);
  }

  void _showAddSlotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: DateOverrideFormDialog(selectedDate: _selectedDay),
      ),
    );
  }

  void _confirmRevert(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset to Default?"),
        content: const Text(
            "This will remove your custom settings for this day. The schedule will revert to your recurring weekly rules."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<ScheduleCubit>().revertToWeekly(_selectedDay);
              },
              child: const Text("Reset", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
