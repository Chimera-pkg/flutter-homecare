part of 'home_health_screening_flow_bloc.dart';

enum HomeHealthScreeningStep {
  selectServices,
  searchProfessional,
  viewProfessionalDetail,
  scheduling,
}

enum ScreeningSubmissionStatus {
  initial,
  submitting,
  success,
  failure,
}

class HomeHealthScreeningFlowState extends Equatable {
  final HomeHealthScreeningStep currentStep;
  final List<ScreeningItem> selectedItems;
  final ProfessionalEntity? selectedProfessional;
  final DateTime? selectedTimeSlot;
  final AppointmentEntity? createdAppointment;
  final ScreeningSubmissionStatus submissionStatus;
  final String? errorMessage;

  const HomeHealthScreeningFlowState({
    this.currentStep = HomeHealthScreeningStep.selectServices,
    this.selectedItems = const [],
    this.selectedProfessional,
    this.selectedTimeSlot,
    this.createdAppointment,
    this.submissionStatus = ScreeningSubmissionStatus.initial,
    this.errorMessage,
  });

  factory HomeHealthScreeningFlowState.initial() {
    return const HomeHealthScreeningFlowState();
  }

  HomeHealthScreeningFlowState copyWith({
    HomeHealthScreeningStep? currentStep,
    List<ScreeningItem>? selectedItems,
    ProfessionalEntity? selectedProfessional,
    DateTime? selectedTimeSlot,
    AppointmentEntity? createdAppointment,
    ScreeningSubmissionStatus? submissionStatus,
    String? errorMessage,
  }) {
    return HomeHealthScreeningFlowState(
      currentStep: currentStep ?? this.currentStep,
      selectedItems: selectedItems ?? this.selectedItems,
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
        selectedItems,
        selectedProfessional,
        selectedTimeSlot,
        createdAppointment,
        submissionStatus,
        errorMessage,
      ];
}