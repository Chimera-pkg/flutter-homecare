import 'package:equatable/equatable.dart';

class ProviderAvailability extends Equatable {
  final int id;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? timezone;

  const ProviderAvailability({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.timezone,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, startTime, endTime, timezone];
}