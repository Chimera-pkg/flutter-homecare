import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';

abstract class PharmacyAppointmentRepository {
  Future<Either<Failure, AppointmentEntity>> createAppointment(
      CreatePharmacyAppointmentParams data);
}
