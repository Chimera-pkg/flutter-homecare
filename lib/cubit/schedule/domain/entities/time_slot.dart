import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final String startISO;
  final String endISO;

  const TimeSlot({
    required this.startISO,
    required this.endISO,
  });

  @override
  List<Object?> get props => [startISO, endISO];
}