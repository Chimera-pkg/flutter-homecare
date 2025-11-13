import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/repositories/schedule_appointment_repository.dart';

class RescheduleAppointment {
  final ScheduleAppointmentRepository repository;

  RescheduleAppointment(this.repository);

  Future<Either<Failure, Unit>> call({
    required int appointmentId,
    required DateTime newTime,
  }) async {
    return await repository.rescheduleAppointment(
      appointmentId: appointmentId,
      newTime: newTime,
    );
  }
}
