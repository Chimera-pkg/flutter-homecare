import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [startTime, endTime];
}
