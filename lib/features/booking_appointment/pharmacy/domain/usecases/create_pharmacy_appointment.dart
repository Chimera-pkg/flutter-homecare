import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/repositories/pharmacy_appointment_repository.dart';

class CreatePharmacyAppointment {
  final PharmacyAppointmentRepository repository;

  CreatePharmacyAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreatePharmacyAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreatePharmacyAppointmentParams extends Equatable {
  final String type = 'pharmacy';
  final String providerType = 'pharmacist';
  final int providerId;
  final DateTime startDatetime;
  final PharmacyCase pharmacyCase;

  String get summary =>
      pharmacyCase.addOnServices.map((e) => e.name).join(', ');
  double get payTotal => pharmacyCase.addOnServices.map((e) => e.price).fold(
      0.0,
      (previousValue, element) => previousValue + element); // Sum of prices

  const CreatePharmacyAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.pharmacyCase,
  });

  @override
  List<Object?> get props => [
        type,
        providerType,
        providerId,
        startDatetime,
        pharmacyCase,
      ];
}
