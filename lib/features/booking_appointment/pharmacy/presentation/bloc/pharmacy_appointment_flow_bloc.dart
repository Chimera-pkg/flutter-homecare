import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/health_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/mobility_status.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/entities/pharmacy_case.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

part 'pharmacy_appointment_flow_event.dart';
part 'pharmacy_appointment_flow_state.dart';

class PharmacyAppointmentFlowBloc
    extends Bloc<PharmacyAppointmentFlowEvent, PharmacyAppointmentFlowState> {
  final CreatePharmacyAppointment createPharmacyAppointment;

  PharmacyAppointmentFlowBloc({
    required this.createPharmacyAppointment,
  }) : super(PharmacyAppointmentFlowState.initial()) {
    on<FlowStepChanged>(_onStepChanged);
    on<FlowPersonalIssueUpdated>(_onPersonalCaseUpdated);
    on<FlowHealthStatusUpdated>(_onHealthStatusUpdated);
    on<FlowAddOnServicesUpdated>(_onAddOnServicesUpdated);
    on<FlowProfessionalSelected>(_onProfessionalSelected);
    on<FlowTimeSlotSelected>(_onTimeSlotSelected);
    on<FlowSubmitAppointment>(_onSubmitAppointment);
  }

  @override
  void onEvent(PharmacyAppointmentFlowEvent event) {
    super.onEvent(event);
    log('Event triggered: $event'); // Logs the event details
  }

  void _onStepChanged(
      FlowStepChanged event, Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onPersonalCaseUpdated(FlowPersonalIssueUpdated event,
      Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedIssues: event.personalIssues,
      currentStep: PharmacyFlowStep.healthStatus,
    ));
  }

  void _onHealthStatusUpdated(FlowHealthStatusUpdated event,
      Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(
      healthStatus: event.healthStatus,
      currentStep: PharmacyFlowStep.addOnService,
    ));
  }

  void _onAddOnServicesUpdated(FlowAddOnServicesUpdated event,
      Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedAddOnServices: event.addOnServices,
      currentStep: PharmacyFlowStep.searchProfessional,
    ));
  }

  void _onProfessionalSelected(FlowProfessionalSelected event,
      Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(
      selectedProfessional: event.professional,
      currentStep: PharmacyFlowStep.viewProfessionalDetail,
    ));
  }

  void _onTimeSlotSelected(
      FlowTimeSlotSelected event, Emitter<PharmacyAppointmentFlowState> emit) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));

    add(FlowSubmitAppointment()); // Trigger submission after time slot selection
  }

  void _onSubmitAppointment(FlowSubmitAppointment event,
      Emitter<PharmacyAppointmentFlowState> emit) async {
    emit(state.copyWith(
        submissionStatus: AppointmentSubmissionStatus.submitting));

    final params = CreatePharmacyAppointmentParams(
      providerId: state.selectedProfessional!.id,
      startDatetime: state.selectedTimeSlot!,
      pharmacyCase: PharmacyCase(
        issues: state.selectedIssues,
        mobilityStatus: state.healthStatus?.mobilityStatus,
        relatedHealthRecordId: state.healthStatus?.relatedHealthRecordId,
        addOnServices: state.selectedAddOnServices,
      ),
    );

    final result = await createPharmacyAppointment(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          submissionStatus: AppointmentSubmissionStatus.failure,
          errorMessage: 'Failed to create appointment',
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
