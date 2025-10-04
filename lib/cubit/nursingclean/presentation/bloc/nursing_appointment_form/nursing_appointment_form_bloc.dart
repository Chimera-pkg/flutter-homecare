import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:intl/intl.dart';

part 'nursing_appointment_form_event.dart';
part 'nursing_appointment_form_state.dart';

class NursingAppointmentFormBloc
    extends Bloc<NursingAppointmentFormEvent, NursingAppointmentFormState> {
  final NursingAppointmentRepository _appointmentRepository;
  final CreateNursingCase _createNursingCase;

  NursingAppointmentFormBloc({
    required NursingAppointmentRepository appointmentRepository,
    required CreateNursingCase createNursingCase,
  })  : _appointmentRepository = appointmentRepository,
        _createNursingCase = createNursingCase,
        super(NursingAppointmentFormInitial()) {
    on<NursingAppointmentSubmitted>(_onAppointmentSubmitted);
  }

  Future<void> _onAppointmentSubmitted(
    NursingAppointmentSubmitted event,
    Emitter<NursingAppointmentFormState> emit,
  ) async {
    emit(NursingAppointmentFormSubmissionInProgress());

    final appointmentToCreate = AppointmentEntity(
      providerId: event.professional.id,
      providerType: event.professional.role.toLowerCase(),
      type: event.professional.role,
      status: 'pending',
      date: event.selectedDate,
      hour: DateFormat('HH:mm:ss').format(event.selectedTime),
      summary: 'Appointment booking with ${event.professional.name}',
      payTotal: event.nursingCase.estimatedBudget,
      profileServicesData: {
        'id': event.professional.id,
        'name': event.professional.name,
        'avatar': event.professional.avatar,
        'role': event.professional.role,
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final createdAppointmentResult =
        await _appointmentRepository.createAppointment(appointmentToCreate);

    await createdAppointmentResult.fold(
      (failure) async => emit(
          NursingAppointmentFormSubmissionFailure(message: failure.toString())),
      (createdAppointment) async {
        final nursingCaseToSubmit = event.nursingCase.copyWith(
          appointmentId: createdAppointment.id,
        );

        final nursingCaseResult = await _createNursingCase(nursingCaseToSubmit);

        nursingCaseResult.fold(
          (failure) =>
              print("Error submitting nursing case: ${failure.toString()}"),
          (_) => print("Nursing case submitted successfully!"),
        );

        debugPrint('Created Appointment: $createdAppointment');

        emit(NursingAppointmentFormSubmissionSuccess(
          appointment: createdAppointment,
          nursingCase: nursingCaseToSubmit,
        ));
      },
    );
  }
}
