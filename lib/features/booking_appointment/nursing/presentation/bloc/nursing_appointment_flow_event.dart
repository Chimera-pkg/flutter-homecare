part of 'nursing_appointment_flow_bloc.dart';

sealed class NursingAppointmentFlowEvent extends Equatable {
  const NursingAppointmentFlowEvent();
  @override
  List<Object?> get props => [];
}

class FlowStepChanged extends NursingAppointmentFlowEvent {
  final NursingFlowStep step;
  const FlowStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class FlowPersonalIssueUpdated extends NursingAppointmentFlowEvent {
  final List<PersonalIssue> personalIssues;
  const FlowPersonalIssueUpdated(this.personalIssues);
  @override
  List<Object> get props => [personalIssues];
}

class FlowHealthStatusUpdated extends NursingAppointmentFlowEvent {
  final HealthStatus healthStatus;
  const FlowHealthStatusUpdated(this.healthStatus);
  @override
  List<Object> get props => [healthStatus];
}

class FlowAddOnServicesUpdated extends NursingAppointmentFlowEvent {
  final List<AddOnService> addOnServices;
  const FlowAddOnServicesUpdated(this.addOnServices);
  @override
  List<Object> get props => [addOnServices];
}

class FlowProfessionalSelected extends NursingAppointmentFlowEvent {
  final ProfessionalEntity professional;
  const FlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class FlowTimeSlotSelected extends NursingAppointmentFlowEvent {
  final DateTime timeSlot;
  const FlowTimeSlotSelected(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class FlowSubmitAppointment extends NursingAppointmentFlowEvent {}
