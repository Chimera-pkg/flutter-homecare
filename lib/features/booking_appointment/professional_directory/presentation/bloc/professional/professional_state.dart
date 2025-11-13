import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

abstract class ProfessionalState extends Equatable {
  const ProfessionalState();

  @override
  List<Object> get props => [];
}

class ProfessionalInitial extends ProfessionalState {}

class ProfessionalLoading extends ProfessionalState {}

class ProfessionalLoaded extends ProfessionalState {
  final List<ProfessionalEntity> professionals;

  const ProfessionalLoaded(this.professionals);

  @override
  List<Object> get props => [professionals];
}

class ProfessionalError extends ProfessionalState {
  final String message;

  const ProfessionalError(this.message);

  @override
  List<Object> get props => [message];
}
