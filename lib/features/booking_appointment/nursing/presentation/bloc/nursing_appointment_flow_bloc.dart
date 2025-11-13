import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/nursing/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/health_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/usecases/create_nursing_appointment.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

part 'nursing_appointment_flow_event.dart';
part 'nursing_appointment_flow_state.dart';

class NursingAppointmentFlowBloc
    extends Bloc<NursingAppointmentFlowEvent, NursingAppointmentFlowState> {
  final CreateNursingAppointment createNursingAppointment;

  NursingAppointmentFlowBloc({
    required this.createNursingAppointment,
    required NurseServiceType serviceType,
  }) : super(NursingAppointmentFlowState.initial(serviceType)) {
    on<FlowStepChanged>(_onStepChanged);
    on<FlowPersonalIssueUpdated>(_onPersonalCaseUpdated);
    on<FlowHealthStatusUpdated>(_onHealthStatusUpdated);
    on<FlowAddOnServicesUpdated>(_onAddOnServicesUpdated);
    on<FlowProfessionalSelected>(_onProfessionalSelected);
    on<FlowTimeSlotSelected>(_onTimeSlotSelected);
    on<FlowSubmitAppointment>(_onSubmitAppointment);
  }

  @override
  void onEvent(NursingAppointmentFlowEvent event) {
    super.onEvent(event);
    log('Event triggered: $event'); // Logs the event details
  }

  void _onStepChanged(
      FlowStepChanged event, Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onPersonalCaseUpdated(FlowPersonalIssueUpdated event,
      Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedIssues: event.personalIssues,
      currentStep: NursingFlowStep.healthStatus,
    ));
  }

  void _onHealthStatusUpdated(FlowHealthStatusUpdated event,
      Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(
      healthStatus: event.healthStatus,
      currentStep: NursingFlowStep.addOnService,
    ));
  }

  void _onAddOnServicesUpdated(FlowAddOnServicesUpdated event,
      Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedAddOnServices: event.addOnServices,
      currentStep: NursingFlowStep.searchProfessional,
    ));
  }

  void _onProfessionalSelected(FlowProfessionalSelected event,
      Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedProfessional: event.professional,
      currentStep: NursingFlowStep.viewProfessionalDetail,
    ));
  }

  void _onTimeSlotSelected(
      FlowTimeSlotSelected event, Emitter<NursingAppointmentFlowState> emit) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));

    add(FlowSubmitAppointment()); // Trigger submission after time slot selection
  }

  void _onSubmitAppointment(FlowSubmitAppointment event,
      Emitter<NursingAppointmentFlowState> emit) async {
    emit(state.copyWith(
        submissionStatus: AppointmentSubmissionStatus.submitting));

    log('Selected Time: ${state.selectedTimeSlot!.toIso8601String()}');

    final params = CreateNursingAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      nursingCase: NursingCase(
        issues: state.selectedIssues,
        mobilityStatus: state.healthStatus?.mobilityStatus,
        relatedHealthRecordId: state.healthStatus?.relatedHealthRecordId,
        addOnServices: state.selectedAddOnServices,
      ),
    );

    final result = await createNursingAppointment(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.failure,
          errorMessage: 'Failed to create appointment:\n${failure.message}',
        ));
      },
      (appointment) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.success,
          createdAppointment: appointment,
        ));
      },
    );
  }
}
