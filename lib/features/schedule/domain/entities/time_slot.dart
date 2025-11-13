import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String startTime;
  final String endTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}