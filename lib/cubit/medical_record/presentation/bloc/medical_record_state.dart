import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';

abstract class MedicalRecordState extends Equatable {
  const MedicalRecordState();

  @override
  List<Object> get props => [];
}

class MedicalRecordInitial extends MedicalRecordState {}

class MedicalRecordLoading extends MedicalRecordState {}

class MedicalRecordLoaded extends MedicalRecordState {
  final List<MedicalRecord> medicalRecords;

  const MedicalRecordLoaded(this.medicalRecords);

  @override
  List<Object> get props => [medicalRecords];
}

class MedicalRecordError extends MedicalRecordState {
  final String message;

  const MedicalRecordError(this.message);

  @override
  List<Object> get props => [message];
}
