import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/add_on_services_state.dart';

abstract class NursingCaseState extends Equatable {
  const NursingCaseState();

  @override
  List<Object> get props => [];
}

class NursingCaseInitial extends NursingCaseState {}

class NursingCaseLoading extends NursingCaseState {}

class NursingCaseLoaded extends NursingCaseState {
  final NursingCase nursingCase;
  final AddOnServicesState addOnServicesState;

  const NursingCaseLoaded(
      {required this.nursingCase,
      this.addOnServicesState = const AddOnServicesInitial()});

  NursingCaseLoaded copyWith({
    NursingCase? nursingCase,
    AddOnServicesState? addOnServicesState,
  }) {
    return NursingCaseLoaded(
      nursingCase: nursingCase ?? this.nursingCase,
      addOnServicesState: addOnServicesState ?? this.addOnServicesState,
    );
  }

  @override
  List<Object> get props => [nursingCase, addOnServicesState];
}

class NursingCaseError extends NursingCaseState {
  final String message;

  const NursingCaseError(this.message);

  @override
  List<Object> get props => [message];
}
