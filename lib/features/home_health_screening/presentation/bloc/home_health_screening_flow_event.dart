part of 'home_health_screening_flow_bloc.dart';

sealed class HomeHealthScreeningFlowEvent extends Equatable {
  const HomeHealthScreeningFlowEvent();
  @override
  List<Object?> get props => [];
}

class ScreeningFlowStepChanged extends HomeHealthScreeningFlowEvent {
  final HomeHealthScreeningStep step;
  const ScreeningFlowStepChanged(this.step);
  @override
  List<Object> get props => [step];
}

class ScreeningItemsUpdated extends HomeHealthScreeningFlowEvent {
  final List<ScreeningItem> selectedItems;
  const ScreeningItemsUpdated(this.selectedItems);
  @override
  List<Object> get props => [selectedItems];
}

class ScreeningProfessionalSelected extends HomeHealthScreeningFlowEvent {
  final ProfessionalEntity professional;
  const ScreeningProfessionalSelected(this.professional);
  @override
  List<Object> get props => [professional];
}

class ScreeningTimeSlotSelected extends HomeHealthScreeningFlowEvent {
  final DateTime timeSlot;
  const ScreeningTimeSlotSelected(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class ScreeningSubmitAppointment extends HomeHealthScreeningFlowEvent {}