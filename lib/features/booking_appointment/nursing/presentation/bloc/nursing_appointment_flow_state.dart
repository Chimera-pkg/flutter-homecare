part of 'nursing_appointment_flow_bloc.dart';

enum NursingFlowStep {
  personalCase,
  healthStatus,
  addOnService,
  searchProfessional,
  viewProfessionalDetail,
  scheduling,
}

enum AppointmentSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class NursingAppointmentFlowState extends Equatable {
  final NursingFlowStep currentStep;

  final NurseServiceType serviceType;

  // Data collected along the flow
  final List<PersonalIssue> selectedIssues;
  final HealthStatus? healthStatus;
  final List<AddOnService> selectedAddOnServices;
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;

  // Submission status
  final AppointmentSubmissionStatus submissionStatus;
  final String? errorMessage;

  const NursingAppointmentFlowState({
    this.currentStep = NursingFlowStep.personalCase,
    required this.serviceType,
    this.selectedIssues = const [],
    this.healthStatus,
    this.selectedAddOnServices = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = AppointmentSubmissionStatus.initial,
    this.errorMessage,
  });

  factory NursingAppointmentFlowState.initial(NurseServiceType serviceType) {
    return NursingAppointmentFlowState(
      serviceType: serviceType,
    );
  }

  NursingAppointmentFlowState copyWith({
    NursingFlowStep? currentStep,
    NurseServiceType? serviceType,
    List<PersonalIssue>? selectedIssues,
    HealthStatus? healthStatus,
    List<AddOnService>? selectedAddOnServices,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    AppointmentSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return NursingAppointmentFlowState(
      currentStep: currentStep ?? this.currentStep,
      serviceType: serviceType ?? this.serviceType,
      selectedIssues: selectedIssues ?? this.selectedIssues,
      healthStatus: healthStatus ?? this.healthStatus,
      selectedAddOnServices:
          selectedAddOnServices ?? this.selectedAddOnServices,
      selectedProfessional: selectedProfessional ?? this.selectedProfessional,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        serviceType,
        selectedIssues,
        healthStatus,
        selectedAddOnServices,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}
