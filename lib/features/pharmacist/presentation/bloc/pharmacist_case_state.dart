import 'package:equatable/equatable.dart';
import 'package:m2health/features/pharmacist/domain/entities/pharmacist_case.dart';

abstract class PharmacistCaseState extends Equatable {
  const PharmacistCaseState();

  @override
  List<Object> get props => [];
}

class PharmacistCaseInitial extends PharmacistCaseState {}

class PharmacistCaseLoading extends PharmacistCaseState {}

class PharmacistCaseLoaded extends PharmacistCaseState {
  final List<PharmacistCase> cases;

  const PharmacistCaseLoaded(this.cases);

  @override
  List<Object> get props => [cases];
}

class PharmacistCaseError extends PharmacistCaseState {
  final String message;

  const PharmacistCaseError(this.message);

  @override
  List<Object> get props => [message];
}
