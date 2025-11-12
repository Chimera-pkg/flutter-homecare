import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TimeSlotGridView extends StatelessWidget {
  final List<TimeSlot> timeSlots;
  final DateTime? selectedTime;
  final ValueChanged<DateTime> onTimeSelected;

  const TimeSlotGridView({
    super.key,
    required this.timeSlots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 105 / 42,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final time = timeSlot.startTime;
        final isSelected = selectedTime == time;

        // Convert to local time zone for display
        final localTime = tz.TZDateTime.from(time, tz.local);
        final formattedTime = DateFormat('HH:mm').format(localTime);

        return GestureDetector(
          onTap: () {
            onTimeSelected(time);
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [Const.tosca.withValues(alpha: .5), Const.tosca],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              border: Border.all(
                color: Const.tosca,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Text(
                formattedTime,
                style: TextStyle(
                  color: isSelected ? Colors.white : Const.tosca,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
