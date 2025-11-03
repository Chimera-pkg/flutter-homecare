// nursingclean/presentation/bloc/nursing_case/nursing_case_bloc.dart
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/add_nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/delete_nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/update_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';

class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
  final GetNursingCase getNursingCase;
  final CreateNursingCase createNursingCase;
  final GetNursingAddOnServices getNursingAddOnServices;
  final AddNursingIssue addNursingIssue;
  final DeleteNursingIssue deleteNursingIssue;
  final UpdateNursingCase updateNursingCase;

  NursingCaseBloc({
    required this.getNursingCase,
    required this.createNursingCase,
    required this.getNursingAddOnServices,
    required this.addNursingIssue,
    required this.deleteNursingIssue,
    required this.updateNursingCase,
  }) : super(NursingCaseState.initial()) {
    // Register all event handlers
    on<GetNursingCaseEvent>(_onGetNursingCase);
    on<InitializeNursingCaseEvent>(_onInitializeNursingCase);
    on<SelectServiceTypeEvent>(_onSelectServiceType);
    on<UpdateHealthStatusNursingCaseEvent>(_onUpdateHealthStatusNursingCase);
    on<CreateNursingCaseEvent>(_onCreateNursingCase);
    on<AddNursingIssueEvent>(_onAddNursingIssue);
    on<DeleteNursingIssueEvent>(_onDeleteNursingIssue);
    on<FetchNursingAddOnServices>(_onFetchNursingAddOnServices);
    on<ToggleAddOnService>(_onToggleAddOnService);
    on<UpdateCaseWithAppointment>(_onUpdateCaseWithAppointment);
  }

  // ---------------------------------------------------------------------------
  // Event Handlers
  // ---------------------------------------------------------------------------

  Future<void> _onGetNursingCase(
    GetNursingCaseEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    emit(state.copyWith(nursingCaseStatus: NursingCaseStatus.loading));
    final failureOrNursingCase = await getNursingCase();

    failureOrNursingCase.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          emit(state.copyWith(
              nursingCaseStatus: NursingCaseStatus.unauthenticated));
        } else {
          // On failure, emit an empty case so user can start fresh
          emit(state.copyWith(
            nursingCaseStatus: NursingCaseStatus.success,
            nursingCase: const NursingCase(
              issues: [],
              addOnServices: [],
              estimatedBudget: 0,
            ),
          ));
        }
      },
      (nursingCase) => emit(state.copyWith(
        nursingCaseStatus: NursingCaseStatus.success,
        nursingCase: nursingCase.copyWith(
          addOnServices: const [], // Reset add-on services
          estimatedBudget: 0,
        ),
      )),
    );
  }

  void _onInitializeNursingCase(
    InitializeNursingCaseEvent event,
    Emitter<NursingCaseState> emit,
  ) {
    emit(NursingCaseState.initial());
  }

  void _onSelectServiceType(
    SelectServiceTypeEvent event,
    Emitter<NursingCaseState> emit,
  ) {
    emit(state.copyWith(serviceType: event.serviceType));
  }

  void _onUpdateHealthStatusNursingCase(
    UpdateHealthStatusNursingCaseEvent event,
    Emitter<NursingCaseState> emit,
  ) {
    final updatedCase = state.nursingCase.copyWith(
      mobilityStatus: event.mobilityStatus,
      relatedHealthRecordId: event.relatedHealthRecordId,
    );
    debugPrint('Updated Nursing Case: $updatedCase');
    emit(state.copyWith(nursingCase: updatedCase));
  }

  Future<void> _onCreateNursingCase(
    CreateNursingCaseEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    emit(state.copyWith(nursingCaseStatus: NursingCaseStatus.loading));
    final failureOrSuccess = await createNursingCase(event.nursingCase);
    failureOrSuccess.fold(
      (failure) => emit(state.copyWith(
        nursingCaseStatus: NursingCaseStatus.failure,
        nursingCaseError: _mapFailureToMessage(failure),
      )),
      (_) => add(InitializeNursingCaseEvent()),
    );
  }

  Future<void> _onAddNursingIssue(
    AddNursingIssueEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    final currentCase = state.nursingCase;
    final failureOrCreatedIssue =
        await addNursingIssue(event.issue, currentCase);

    failureOrCreatedIssue.fold(
      (failure) {
        emit(state.copyWith(
          nursingCaseStatus: NursingCaseStatus.failure,
          nursingCaseError: _mapFailureToMessage(failure),
        ));
      },
      (createdIssue) {
        final finalIssues = List<NursingIssue>.from(currentCase.issues)
          ..add(createdIssue);
        emit(state.copyWith(
            nursingCase: currentCase.copyWith(issues: finalIssues)));
      },
    );
  }

  Future<void> _onDeleteNursingIssue(
    DeleteNursingIssueEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    if (event.issue.id == null) return;

    final currentCase = state.nursingCase;
    final updatedIssues = List<NursingIssue>.from(currentCase.issues)
      ..remove(event.issue);
    final updatedCase = currentCase.copyWith(issues: updatedIssues);

    // Optimistic UI update
    emit(state.copyWith(nursingCase: updatedCase));

    final failureOrSuccess = await deleteNursingIssue(event.issue.id!);

    failureOrSuccess.fold(
      (failure) {
        // Revert on failure
        emit(state.copyWith(
          nursingCase: currentCase,
          nursingCaseStatus: NursingCaseStatus.failure,
          nursingCaseError: _mapFailureToMessage(failure),
        ));
      },
      (_) {
        // Success, state is already updated
      },
    );
  }

  Future<void> _onFetchNursingAddOnServices(
    FetchNursingAddOnServices event,
    Emitter<NursingCaseState> emit,
  ) async {
    log('Fetching add-on services for type: ${event.serviceType}',
        name: 'NursingCaseBloc');
    emit(state.copyWith(addOnServicesStatus: NursingCaseStatus.loading));
    final failureOrServices = await getNursingAddOnServices(event.serviceType);

    failureOrServices.fold(
      (failure) {
        log('Failed to load add-on services: ${failure.message}',
            name: 'NursingCaseBloc');
        emit(state.copyWith(
          addOnServicesStatus: NursingCaseStatus.failure,
          addOnServicesError: "Failed to load services",
        ));
      },
      (services) {
        emit(state.copyWith(
          addOnServicesStatus: NursingCaseStatus.success,
          addOnServices: services,
        ));
      },
    );
  }

  void _onToggleAddOnService(
    ToggleAddOnService event,
    Emitter<NursingCaseState> emit,
  ) {
    final currentCase = state.nursingCase;
    final currentAddOns = List<AddOnService>.from(currentCase.addOnServices);

    if (currentAddOns.contains(event.service)) {
      currentAddOns.remove(event.service);
    } else {
      currentAddOns.add(event.service);
    }

    // Recalculate estimated budget
    double newBudget =
        currentAddOns.fold(0.0, (sum, service) => sum + (service.price));

    final updatedCase = currentCase.copyWith(
      addOnServices: currentAddOns,
      estimatedBudget: newBudget,
    );

    emit(state.copyWith(nursingCase: updatedCase));
  }

  Future<void> _onUpdateCaseWithAppointment(
    UpdateCaseWithAppointment event,
    Emitter<NursingCaseState> emit,
  ) async {
    final nursingCase = event.nursingCase;

    //  Optimistically update the local state
    final updatedCase = nursingCase.copyWith(
      appointmentId: event.appointmentId,
    );
    emit(state.copyWith(nursingCase: updatedCase));

    try {
      final addOnIds =
          updatedCase.addOnServices.map((s) => s.id).whereType<int>().toList();

      final updateData = {
        'mobility_status': updatedCase.mobilityStatus?.apiValue,
        'related_health_record_id': updatedCase.relatedHealthRecordId,
        'add_on_ids[]': addOnIds,
        'appointment_id': event.appointmentId,
      } as Map<String, dynamic>;

      for (final issue in updatedCase.issues) {
        if (issue.id != null) {
          await updateNursingCase(issue.id.toString(), updateData);
        }
      }
    } catch (e, stackTrace) {
      log('Failed to sync nursing case update to backend: $e',
          name: 'NursingCaseBloc', error: e, stackTrace: stackTrace);
    }
  }

  // ---------------------------------------------------------------------------
  // Helper Methods
  // ---------------------------------------------------------------------------

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
