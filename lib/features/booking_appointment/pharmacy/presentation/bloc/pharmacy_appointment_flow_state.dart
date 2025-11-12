part of 'pharmacy_appointment_flow_bloc.dart';

enum PharmacyFlowStep {
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

class PharmacyAppointmentFlowState extends Equatable {
  final PharmacyFlowStep currentStep;

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

  const PharmacyAppointmentFlowState({
    this.currentStep = PharmacyFlowStep.personalCase,
    this.selectedIssues = const [],
    this.healthStatus,
    this.selectedAddOnServices = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = AppointmentSubmissionStatus.initial,
    this.errorMessage,
  });

  factory PharmacyAppointmentFlowState.initial() {
    return const PharmacyAppointmentFlowState();
  }

  PharmacyAppointmentFlowState copyWith({
    PharmacyFlowStep? currentStep,
    List<PersonalIssue>? selectedIssues,
    HealthStatus? healthStatus,
    List<AddOnService>? selectedAddOnServices,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    AppointmentSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return PharmacyAppointmentFlowState(
      currentStep: currentStep ?? this.currentStep,
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