part of 'nursing_appointment_form_bloc.dart';

abstract class NursingAppointmentFormEvent extends Equatable {
  const NursingAppointmentFormEvent();

  @override
  List<Object?> get props => [];
}

class NursingAppointmentSubmitted extends NursingAppointmentFormEvent {
  final ProfessionalEntity professional;
  final DateTime selectedDate;
  final DateTime selectedTime;
  final NursingCase nursingCase;

  const NursingAppointmentSubmitted({
    required this.professional,
    required this.selectedDate,
    required this.selectedTime,
    required this.nursingCase,
  });

  @override
  List<Object?> get props => [professional, selectedDate, selectedTime, nursingCase];
}
