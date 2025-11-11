import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nursing/domain/usecases/create_nursing_appointment.dart';

abstract class NursingAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateNursingAppointmentParams data);
}
