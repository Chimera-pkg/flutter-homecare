import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';

abstract class ScheduleAppointmentRepository {
  Future<Either<Failure, List<TimeSlot>>> getAvailableTimeSlots(
      GetAvailableTimeSlotsParams params);
  Future<Either<Failure, Unit>> rescheduleAppointment({
    required int appointmentId,
    required DateTime newTime,
  });
}
