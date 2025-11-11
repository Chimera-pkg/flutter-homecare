
part of 'nursing_appointment_form_bloc.dart';

abstract class NursingAppointmentFormState extends Equatable {
  const NursingAppointmentFormState();

  @override
  List<Object> get props => [];
}

class NursingAppointmentFormInitial extends NursingAppointmentFormState {}

class NursingAppointmentFormSubmissionInProgress extends NursingAppointmentFormState {}

class NursingAppointmentFormSubmissionSuccess extends NursingAppointmentFormState {
  final AppointmentEntity appointment;
  final NursingCase nursingCase;

  const NursingAppointmentFormSubmissionSuccess({required this.appointment, required this.nursingCase});

  @override
  List<Object> get props => [appointment];
}

class NursingAppointmentFormSubmissionFailure extends NursingAppointmentFormState {
  final String message;

  const NursingAppointmentFormSubmissionFailure({required this.message});

  @override
  List<Object> get props => [message];
}
