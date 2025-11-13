part of 'pharmacy_appointment_flow_bloc.dart';

sealed class PharmacyAppointmentFlowEvent extends Equatable {
  const PharmacyAppointmentFlowEvent();
  @override
  List<Object?> get props => [];
}

class FlowStepChanged extends PharmacyAppointmentFlowEvent {
  final PharmacyFlowStep step;
  const FlowStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class FlowPersonalIssueUpdated extends PharmacyAppointmentFlowEvent {
  final List<PersonalIssue> personalIssues;
  const FlowPersonalIssueUpdated(this.personalIssues);
  @override
  List<Object> get props => [personalIssues];
}

class FlowHealthStatusUpdated extends PharmacyAppointmentFlowEvent {
  final HealthStatus healthStatus;
  const FlowHealthStatusUpdated(this.healthStatus);
  @override
  List<Object> get props => [healthStatus];
}

class FlowAddOnServicesUpdated extends PharmacyAppointmentFlowEvent {
  final List<AddOnService> addOnServices;
  const FlowAddOnServicesUpdated(this.addOnServices);
  @override
  List<Object> get props => [addOnServices];
}

class FlowProfessionalSelected extends PharmacyAppointmentFlowEvent {
  final ProfessionalEntity professional;
  const FlowProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class FlowTimeSlotSelected extends PharmacyAppointmentFlowEvent {
  final DateTime timeSlot;
  const FlowTimeSlotSelected(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class FlowSubmitAppointment extends PharmacyAppointmentFlowEvent {}
