import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:m2health/const.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_state.dart';
import 'package:m2health/cubit/schedule/presentation/widgets/availability_form_dialog.dart';

class WeeklyHoursTab extends StatelessWidget {
  WeeklyHoursTab({super.key});

  final List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: daysOfWeek.length,
          itemBuilder: (context, index) {
            final dayName = daysOfWeek[index];
            final dayAvailabilities = state.availabilities
                .where((a) => a.dayOfWeek == index)
                .toList();

            return _DayAvailabilityCard(
              dayName: dayName,
              dayIndex: index,
              availabilities: dayAvailabilities,
            );
          },
        );
      },
    );
  }
}

class _DayAvailabilityCard extends StatelessWidget {
  final String dayName;
  final int dayIndex;
  final List<ProviderAvailability> availabilities;

  const _DayAvailabilityCard({
    required this.dayName,
    required this.dayIndex,
    required this.availabilities,
  });

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: AvailabilityFormDialog(dayIndex: dayIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // MODIFIED: Layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display full day name
                Text(
                  dayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.add_circle_outline, color: Const.aqua),
                  onPressed: () => _showAddDialog(context),
                )
              ],
            ),
            const SizedBox(height: 12),
            // Show time blocks or "Unavailable"
            if (availabilities.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child:
                    Text('Unavailable', style: TextStyle(color: Colors.grey)),
              )
            else
              Column(
                spacing: 8.0,
                children: availabilities.map((avail) {
                  return _TimeBlockChip(
                    availability: avail,
                    dayIndex: dayIndex,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeBlockChip extends StatelessWidget {
  final ProviderAvailability availability;
  final int dayIndex;
  const _TimeBlockChip({required this.availability, required this.dayIndex});

  // Helper to parse time string "HH:mm" or "HH:mm:ss"
  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // Helper to convert the system saved time to the user's local time
  String _formatProviderTime(String timeStr, String? providerTimezoneStr) {
    tz.Location providerLocation;

    if (providerTimezoneStr != null) {
      try {
        providerLocation = tz.getLocation(providerTimezoneStr);
      } catch (e) {
        log('Invalid timezone: $providerTimezoneStr. Falling back to local.',
            name: 'WeeklyHoursTab');
        providerLocation = tz.local; // Fallback
      }
    } else {
      providerLocation = tz.local;
    }

    final tz.TZDateTime nowInLocal = tz.TZDateTime.now(tz.local);
    final time = _parseTime(timeStr);

    // Create the absolute time in the *provider's* timezone
    final tz.TZDateTime providerTime = tz.TZDateTime(
      providerLocation,
      nowInLocal.year,
      nowInLocal.month,
      nowInLocal.day,
      time.hour,
      time.minute,
    );

    // Convert that absolute time to the *user's* local timezone
    final tz.TZDateTime localTime = tz.TZDateTime.from(providerTime, tz.local);

    return DateFormat('HH:mm').format(localTime);
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ScheduleCubit>(),
        child: AvailabilityFormDialog(
          dayIndex: dayIndex,
          availability: availability,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Time Block?'),
        content: Text(
            'Are you sure you want to delete ${availability.startTime} - ${availability.endTime}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<ScheduleCubit>().deleteWeeklyRule(availability.id);
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String startTime =
        _formatProviderTime(availability.startTime, availability.timezone);
    final String endTime =
        _formatProviderTime(availability.endTime, availability.timezone);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            width: double.infinity, // Ensures the border expands fully
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '$startTime - $endTime',
              style: const TextStyle(color: Colors.black, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
          onPressed: () => _showEditDialog(context),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          onPressed: () => _showDeleteDialog(context),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
