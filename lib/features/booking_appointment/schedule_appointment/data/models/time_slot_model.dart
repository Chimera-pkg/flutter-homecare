import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.startTime,
    required super.endTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: DateTime.parse(json['startISO']),
      endTime: DateTime.parse(json['endISO']),
    );
  }
}