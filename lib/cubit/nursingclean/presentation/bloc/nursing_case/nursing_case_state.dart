import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/nursingclean/const.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/presentation/bloc/nursing_case/add_on_services_state.dart';

abstract class NursingCaseState extends Equatable {
  const NursingCaseState();

  @override
  List<Object?> get props => [];
}

class NursingCaseInitial extends NursingCaseState {
  const NursingCaseInitial();
}

class NursingCaseLoading extends NursingCaseState {
  const NursingCaseLoading();
}

class NursingCaseUnauthenticated extends NursingCaseState {
  const NursingCaseUnauthenticated();
}

class NursingCaseLoaded extends NursingCaseState {
  final NursingCase nursingCase;
  final AddOnServicesState addOnServicesState;
  final NurseServiceType? serviceType;

  const NursingCaseLoaded({
    required this.nursingCase,
    this.addOnServicesState = const AddOnServicesInitial(),
    this.serviceType,
  });

  NursingCaseLoaded copyWith({
    NursingCase? nursingCase,
    AddOnServicesState? addOnServicesState,
    NurseServiceType? serviceType,
  }) {
    return NursingCaseLoaded(
      nursingCase: nursingCase ?? this.nursingCase,
      addOnServicesState: addOnServicesState ?? this.addOnServicesState,
      serviceType: serviceType ?? this.serviceType,
    );
  }

  @override
  List<Object?> get props => [nursingCase, addOnServicesState, serviceType];
}

class NursingCaseError extends NursingCaseState {
  final String message;

  const NursingCaseError(this.message);

  @override
  List<Object> get props => [message];
}
