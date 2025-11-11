import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursingclean/domain/entities/professional_entity.dart';

abstract class ProfessionalDetailState extends Equatable {
  const ProfessionalDetailState();

  @override
  List<Object> get props => [];
}

class ProfessionalDetailInitial extends ProfessionalDetailState {}

class ProfessionalDetailLoading extends ProfessionalDetailState {}

class ProfessionalDetailLoaded extends ProfessionalDetailState {
  final ProfessionalEntity professional;

  const ProfessionalDetailLoaded(this.professional);

  @override
  List<Object> get props => [professional];
}

class ProfessionalDetailError extends ProfessionalDetailState {
  final String message;

  const ProfessionalDetailError(this.message);

  @override
  List<Object> get props => [message];
}
