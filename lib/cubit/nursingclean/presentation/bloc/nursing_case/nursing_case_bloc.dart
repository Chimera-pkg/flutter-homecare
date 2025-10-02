import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_issue.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/add_on_services_state.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart';

class NursingCaseBloc extends Bloc<NursingCaseEvent, NursingCaseState> {
  final GetNursingCase getNursingCase;
  final CreateNursingCase createNursingCase;
  final GetNursingAddOnServices getNursingAddOnServices;

  NursingCaseBloc({
    required this.getNursingCase,
    required this.createNursingCase,
    required this.getNursingAddOnServices,
  }) : super(const NursingCaseInitial()) {
    on<GetNursingCaseEvent>((event, emit) async {
      emit(const NursingCaseLoading());
      final failureOrNursingCase = await getNursingCase();

      failureOrNursingCase.fold(
        (failure) {
          if (failure is UnauthorizedFailure) {
            emit(const NursingCaseUnauthenticated());
          } else {
            emit(NursingCaseError(_mapFailureToMessage(failure)));
          }
        },
        (nursingCase) => emit(NursingCaseLoaded(nursingCase: nursingCase)),
      );
    });

    on<InitializeNursingCaseEvent>((event, emit) {
      const nursingCase =
          NursingCase(issues: [], addOnServices: [], estimatedBudget: 0);
      emit(const NursingCaseLoaded(nursingCase: nursingCase));
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
      emit(NursingCaseLoaded(nursingCase: updatedCase));
    });

    on<CreateNursingCaseEvent>((event, emit) async {
      emit(const NursingCaseLoading());
      final failureOrSuccess = await createNursingCase(event.nursingCase);
      failureOrSuccess.fold(
        (failure) => emit(NursingCaseError(_mapFailureToMessage(failure))),
        (_) => add(InitializeNursingCaseEvent()),
      );
    });

    on<AddNursingIssueEvent>((event, emit) {
      final currentState = state;
      if (currentState is NursingCaseLoaded) {
        final currentCase = currentState.nursingCase;
        final updatedIssues = List<NursingIssue>.from(currentCase.issues)
          ..add(event.issue);
        final updatedCase = currentCase.copyWith(issues: updatedIssues);
        emit(NursingCaseLoaded(nursingCase: updatedCase));
      }
    });

    on<DeleteNursingIssueEvent>((event, emit) {
      final currentState = state;
      if (currentState is! NursingCaseLoaded) {
        return;
      }
      final currentCase = currentState.nursingCase;
      final updatedIssues = List<NursingIssue>.from(currentCase.issues)
        ..remove(event.issue);
      final updatedCase = currentCase.copyWith(issues: updatedIssues);
      emit(NursingCaseLoaded(nursingCase: updatedCase));
    });

    on<FetchNursingAddOnServices>((event, emit) async {
      final currentState = state;
      if (currentState is! NursingCaseLoaded) {
        return;
      }
      if (currentState.addOnServicesState is AddOnServicesLoaded) {
        return; // don't refetch
      }
      emit(currentState.copyWith(
          addOnServicesState: const AddOnServicesLoading()));
      final failureOrServices = await getNursingAddOnServices();

      failureOrServices.fold(
        (failure) {
          // NOTE: Using default services in case of failure
          // Change this if backend is ready
          final newState = currentState.copyWith(
              addOnServicesState: AddOnServicesLoaded(_getDefaultServices()));
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

  List<AddOnService> _getDefaultServices() {
    return const [
      AddOnService(id: 1, name: 'Medical Escort', price: 20.0),
      AddOnService(id: 2, name: 'Inject', price: 15.0),
      AddOnService(id: 3, name: 'Blood Glucose Check', price: 10.0),
    ];
  }

  String _mapFailureToMessage(Failure failure) {
    // Need to handle different types of failures here, such as ServerFailure, CacheFailure, etc.
    return failure.message;
  }
}
