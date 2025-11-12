import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/repositories/schedule_appointment_repository.dart';


class GetAvailableTimeSlots {
  final ScheduleAppointmentRepository repository;
  GetAvailableTimeSlots(this.repository);

  Future<Either<Failure, List<TimeSlot>>> call(
      GetAvailableTimeSlotsParams params) async {
    return await repository.getAvailableTimeSlots(params);
  }
}

class GetAvailableTimeSlotsParams extends Equatable {
  final int providerId;
  final String providerType;
  final DateTime date;

  const GetAvailableTimeSlotsParams({
    required this.providerId,
    required this.providerType,
    required this.date,
  });

  @override
  List<Object?> get props => [providerId, providerType, date];
}