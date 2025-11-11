import 'package:m2health/features/schedule/domain/entities/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.startISO,
    required super.endISO,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startISO: json['startISO'],
      endISO: json['endISO'],
    );
  }
}