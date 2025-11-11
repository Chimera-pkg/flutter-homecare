import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_appointment_repository.dart';

class CreateNursingAppointment {
  final NursingAppointmentRepository repository;

  CreateNursingAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateNursingAppointmentParams params) async {
    return await repository.createAppointment(params);
  }
}

class CreateNursingAppointmentParams extends Equatable {
  final String type = 'nursing';
  final String providerType = 'nurse';
  final int providerId;
  final DateTime startDatetime;
  final NursingCase nursingCase;

  String get summary => nursingCase.addOnServices.map((e) => e.name).join(', ');
  double get payTotal => nursingCase.addOnServices
      .map((e) => e.price)
      .fold(0.0, (previousValue, element) => previousValue + element); // Sum of prices

  const CreateNursingAppointmentParams({
    required this.providerId,
    required this.startDatetime,
    required this.nursingCase,
  });

  @override
  List<Object?> get props => [
        type,
        providerType,
        providerId,
        startDatetime,
        nursingCase,
      ];
}
