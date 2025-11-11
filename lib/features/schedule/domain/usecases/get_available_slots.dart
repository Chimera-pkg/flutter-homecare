import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class GetAvailableSlots {
  final ScheduleRepository repository;
  GetAvailableSlots(this.repository);

  Future<Either<Failure, List<TimeSlot>>> call(
      GetAvailableSlotsParams params) async {
    return await repository.getAvailableSlots(params);
  }
}

class GetAvailableSlotsParams extends Equatable {
  final String date; // "YYYY-MM-DD"
  final String? timezone;

  const GetAvailableSlotsParams({
    required this.date,
    this.timezone,
  });

  @override
  List<Object?> get props => [date, timezone];
}