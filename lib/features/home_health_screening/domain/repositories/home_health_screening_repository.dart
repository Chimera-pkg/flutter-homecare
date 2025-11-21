import 'package:dartz/dartz.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';

abstract class HomeHealthScreeningRepository {
  Future<Either<Failure, List<ScreeningCategory>>> getScreeningServices();
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreateScreeningAppointmentParams params);
}