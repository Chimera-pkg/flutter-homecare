import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';

abstract class NursingAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(AppointmentEntity data);
}