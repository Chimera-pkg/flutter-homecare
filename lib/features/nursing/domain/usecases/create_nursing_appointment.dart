import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/appointment_entity.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:intl/intl.dart';

class CreateNursingAppointment {
  final NursingAppointmentRepository repository;

  CreateNursingAppointment(this.repository);

  Future<Either<Failure, AppointmentEntity>> call(
      CreateAppointmentParams params) async {
    final appointmentEntity = AppointmentEntity(
      providerId: params.professional.id,
      providerType: params.professional.role?.toLowerCase(),
      type: params.professional.role,
      status: 'pending',
      date: params.selectedDate,
      hour: DateFormat('HH:mm:ss').format(params.selectedTime),
      summary: params.nursingCase.addOnServices.map((e) => e.name).join(', '),
      payTotal: params.nursingCase.estimatedBudget,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await repository.createAppointment(appointmentEntity);
  }
}

class CreateAppointmentParams extends Equatable {
  final ProfessionalEntity professional;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final NursingCase nursingCase;

  const CreateAppointmentParams({
    required this.professional,
    required this.selectedDate,
    required this.selectedTime,
    required this.nursingCase,
  });

  @override
  List<Object?> get props =>
      [professional, selectedDate, selectedTime, nursingCase];
}
