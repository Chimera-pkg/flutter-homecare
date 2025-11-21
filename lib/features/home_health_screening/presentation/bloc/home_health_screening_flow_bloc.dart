import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

part 'home_health_screening_flow_event.dart';
part 'home_health_screening_flow_state.dart';

class HomeHealthScreeningFlowBloc extends Bloc<HomeHealthScreeningFlowEvent, HomeHealthScreeningFlowState> {
  final CreateScreeningAppointment createScreeningAppointment;

  HomeHealthScreeningFlowBloc({
    required this.createScreeningAppointment,
  }) : super(HomeHealthScreeningFlowState.initial()) {
    on<ScreeningFlowStepChanged>(_onStepChanged);
    on<ScreeningItemsUpdated>(_onItemsUpdated);
    on<ScreeningProfessionalSelected>(_onProfessionalSelected);
    on<ScreeningTimeSlotSelected>(_onTimeSlotSelected);
    on<ScreeningSubmitAppointment>(_onSubmitAppointment);
  }

  void _onStepChanged(
      ScreeningFlowStepChanged event, Emitter<HomeHealthScreeningFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onItemsUpdated(
      ScreeningItemsUpdated event, Emitter<HomeHealthScreeningFlowState> emit) {
    emit(state.copyWith(
      selectedItems: event.selectedItems,
      currentStep: HomeHealthScreeningStep.searchProfessional,
    ));
  }

  void _onProfessionalSelected(
      ScreeningProfessionalSelected event, Emitter<HomeHealthScreeningFlowState> emit) {
    emit(state.copyWith(
      selectedProfessional: event.professional,
      currentStep: HomeHealthScreeningStep.viewProfessionalDetail,
    ));
  }

  void _onTimeSlotSelected(
      ScreeningTimeSlotSelected event, Emitter<HomeHealthScreeningFlowState> emit) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));
    add(ScreeningSubmitAppointment());
  }

  void _onSubmitAppointment(
      ScreeningSubmitAppointment event, Emitter<HomeHealthScreeningFlowState> emit) async {
    emit(state.copyWith(submissionStatus: ScreeningSubmissionStatus.submitting));

    final params = CreateScreeningAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      selectedItems: state.selectedItems,
    );

    final result = await createScreeningAppointment(params);
    
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: ScreeningSubmissionStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (appointment) {
        emit(state.copyWith(
          submissionStatus: ScreeningSubmissionStatus.success,
          createdAppointment: appointment,
        ));
      },
    );
  }
}