import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_service_entity.dart';

abstract class NursingServicesState extends Equatable {
  const NursingServicesState();

  @override
  List<Object> get props => [];
}

class NursingServicesInitial extends NursingServicesState {}

class NursingServicesLoading extends NursingServicesState {}

class NursingServicesLoaded extends NursingServicesState {
  final List<NursingServiceEntity> nursingServices;

  const NursingServicesLoaded(this.nursingServices);

  @override
  List<Object> get props => [nursingServices];
}

class NursingServicesError extends NursingServicesState {
  final String message;

  const NursingServicesError(this.message);

  @override
  List<Object> get props => [message];
}
