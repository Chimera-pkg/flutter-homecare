import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/const.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/add_nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/delete_nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/add_on_services_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';

class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
  final GetNursingCase getNursingCase;
  final CreateNursingCase createNursingCase;
  final GetNursingAddOnServices getNursingAddOnServices;
  final AddNursingIssue addNursingIssue;
  final DeleteNursingIssue deleteNursingIssue;

  NursingCaseBloc({
    required this.getNursingCase,
    required this.createNursingCase,
    required this.getNursingAddOnServices,
    required this.addNursingIssue,
    required this.deleteNursingIssue,
  }) : super(const NursingCaseInitial()) {
    on<GetNursingCaseEvent>((event, emit) async {
      emit(const NursingCaseLoading());
      final failureOrNursingCase = await getNursingCase();
      final currentServiceType = state is NursingCaseLoaded
          ? (state as NursingCaseLoaded).serviceType
          : null;

      failureOrNursingCase.fold(
        (failure) {
          if (failure is UnauthorizedFailure) {
            emit(const NursingCaseUnauthenticated());
          } else {
            // On failure, emit an empty case so user can start fresh
            emit(NursingCaseLoaded(
              nursingCase: const NursingCase(
                issues: [],
                addOnServices: [],
                estimatedBudget: 0,
              ),
              serviceType: currentServiceType,
            ));
          }
        },
        (nursingCase) => emit(NursingCaseLoaded(
          nursingCase: nursingCase,
          serviceType: currentServiceType,
        )),
      );
    });

    on<InitializeNursingCaseEvent>((event, emit) {
      const nursingCase =
          NursingCase(issues: [], addOnServices: [], estimatedBudget: 0);
      emit(const NursingCaseLoaded(nursingCase: nursingCase));
    });

    on<SelectServiceTypeEvent>((event, emit) {
      final currentState = state;
      if (currentState is NursingCaseLoaded) {
        emit(currentState.copyWith(serviceType: event.serviceType));
      } else {
        emit(NursingCaseLoaded(
          nursingCase: const NursingCase(
            issues: [],
            addOnServices: [],
            estimatedBudget: 0,
          ),
          serviceType: event.serviceType,
        ));
      }
    });

    on<UpdateHealthStatusNursingCaseEvent>((event, emit) async {
      final currentState = state;
      if (currentState is! NursingCaseLoaded) {
        return;
      }
      final currentCase = currentState.nursingCase;
      final updatedCase = currentCase.copyWith(
        mobilityStatus: event.mobilityStatus,
        relatedHealthRecordId: event.relatedHealthRecordId,
      );
      debugPrint('Updated Nursing Case: $updatedCase');
      emit(currentState.copyWith(nursingCase: updatedCase));
    });

    on<CreateNursingCaseEvent>((event, emit) async {
      emit(const NursingCaseLoading());
      final failureOrSuccess = await createNursingCase(event.nursingCase);
      failureOrSuccess.fold(
        (failure) => emit(NursingCaseError(_mapFailureToMessage(failure))),
        (_) => add(InitializeNursingCaseEvent()),
      );
    });

    on<AddNursingIssueEvent>(_onAddNursingIssue);
    on<DeleteNursingIssueEvent>(_onDeleteNursingIssue);

    on<FetchNursingAddOnServices>((event, emit) async {
      final currentState = state;
      if (currentState is! NursingCaseLoaded) {
        return;
      }
      // if (currentState.addOnServicesState is AddOnServicesLoaded) {
      //   return; // don't refetch
      // }
      emit(currentState.copyWith(
          addOnServicesState: const AddOnServicesLoading()));
      final failureOrServices =
          await getNursingAddOnServices(event.serviceType);

      failureOrServices.fold(
        (failure) {
          log('Failed to load add-on services: ${failure.message}',
              name: 'NursingCaseBloc');
          final newState = currentState.copyWith(
              addOnServicesState:
                  const AddOnServicesError("Failed to load services"));
          emit(newState);
        },
        (services) {
          final newState = currentState.copyWith(
              addOnServicesState: AddOnServicesLoaded(services));
          emit(newState);
        },
      );
    });

    on<ToggleAddOnService>((event, emit) {
      final currentState = state;
      if (currentState is! NursingCaseLoaded) {
        return;
      }

      final currentCase = currentState.nursingCase;
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

      emit(currentState.copyWith(nursingCase: updatedCase));
    });
  }

  Future<void> _onAddNursingIssue(
    AddNursingIssueEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NursingCaseLoaded) return;

    final currentCase = currentState.nursingCase;

    final failureOrCreatedIssue =
        await addNursingIssue(event.issue, currentCase);

    failureOrCreatedIssue.fold(
      (failure) {
        emit(NursingCaseError(_mapFailureToMessage(failure)));
        emit(currentState.copyWith());
      },
      (createdIssue) {
        final finalIssues = List<NursingIssue>.from(currentCase.issues)
          ..add(createdIssue);
        emit(currentState.copyWith(
            nursingCase: currentCase.copyWith(issues: finalIssues)));
      },
    );
  }

  Future<void> _onDeleteNursingIssue(
    DeleteNursingIssueEvent event,
    Emitter<NursingCaseState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NursingCaseLoaded) return;
    if (event.issue.id == null) return;

    final currentCase = currentState.nursingCase;
    final updatedIssues = List<NursingIssue>.from(currentCase.issues)
      ..remove(event.issue);
    final updatedCase = currentCase.copyWith(issues: updatedIssues);

    // Optimistic UI update
    emit(currentState.copyWith(nursingCase: updatedCase));

    final failureOrSuccess = await deleteNursingIssue(event.issue.id!);

    failureOrSuccess.fold(
      (failure) {
        // Revert on failure
        emit(currentState.copyWith(nursingCase: currentCase));
        emit(NursingCaseError(_mapFailureToMessage(failure)));
        // Re-emit old state to refresh
        emit(currentState.copyWith());
      },
      (_) {
        // Success, state is already updated
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
