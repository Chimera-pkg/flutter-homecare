import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class TimeSlot extends StatefulWidget {
  final DateTime startTime;
  final DateTime endTime;
  final DateTime? selectedTime;
  final ValueChanged<DateTime> onTimeSelected;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  List<DateTime> timeSlots = [];

  @override
  void initState() {
    super.initState();
    timeSlots = generateTimeSlots(widget.startTime, widget.endTime);
  }

  List<DateTime> generateTimeSlots(DateTime startTime, DateTime endTime) {
    List<DateTime> slots = [];
    DateTime current = startTime;
    while (current.isBefore(endTime)) {
      slots.add(current);
      current = current.add(Duration(minutes: 30));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 105 / 42,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final time = timeSlots[index];
        final isSelected = widget.selectedTime == time;

        return GestureDetector(
          onTap: () {
            widget.onTimeSelected(time);
          },
          child: Container(
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [Const.tosca.withOpacity(0.5), Const.tosca],
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
                '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
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
