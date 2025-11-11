// nursingclean/presentation/bloc/nursing_case/nursing_case_state.dart
import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';

// Enum to manage different statuses cleanly
enum NursingCaseStatus { initial, loading, success, failure, unauthenticated }

class NursingCaseState extends Equatable {
  // Status for the main nursing case operations
  final NursingCaseStatus nursingCaseStatus;
  final NursingCase nursingCase;
  final String? nursingCaseError;

  // Status for the add-on services
  final NursingCaseStatus addOnServicesStatus;
  final List<AddOnService> addOnServices;
  final String? addOnServicesError;

  // Persistent data
  final NurseServiceType? serviceType;

  const NursingCaseState({
    this.nursingCaseStatus = NursingCaseStatus.initial,
    this.nursingCase = const NursingCase(
      issues: [],
      addOnServices: [],
      estimatedBudget: 0,
    ),
    this.nursingCaseError,
    this.addOnServicesStatus = NursingCaseStatus.initial,
    this.addOnServices = const [],
    this.addOnServicesError,
    this.serviceType,
  });

  // Factory for a clean initial state
  factory NursingCaseState.initial() {
    return const NursingCaseState(
      nursingCaseStatus: NursingCaseStatus.initial,
      nursingCase: NursingCase(
        issues: [],
        addOnServices: [],
        estimatedBudget: 0,
      ),
      nursingCaseError: null,
      addOnServicesStatus: NursingCaseStatus.initial,
      addOnServices: [],
      addOnServicesError: null,
      serviceType: null,
    );
  }

  NursingCaseState copyWith({
    NursingCaseStatus? nursingCaseStatus,
    NursingCase? nursingCase,
    String? nursingCaseError,
    NursingCaseStatus? addOnServicesStatus,
    List<AddOnService>? addOnServices,
    String? addOnServicesError,
    NurseServiceType? serviceType,
  }) {
    return NursingCaseState(
      nursingCaseStatus: nursingCaseStatus ?? this.nursingCaseStatus,
      nursingCase: nursingCase ?? this.nursingCase,
      nursingCaseError: nursingCaseError ?? this.nursingCaseError,
      addOnServicesStatus: addOnServicesStatus ?? this.addOnServicesStatus,
      addOnServices: addOnServices ?? this.addOnServices,
      addOnServicesError: addOnServicesError ?? this.addOnServicesError,
      serviceType: serviceType ?? this.serviceType,
    );
  }

  @override
  List<Object?> get props => [
        nursingCaseStatus,
        nursingCase,
        nursingCaseError,
        addOnServicesStatus,
        addOnServices,
        addOnServicesError,
        serviceType,
      ];
}
