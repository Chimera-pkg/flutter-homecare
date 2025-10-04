import 'package:equatable/equatable.dart';

abstract class MedicalRecordEvent extends Equatable {
  const MedicalRecordEvent();

  @override
  List<Object> get props => [];
}

class FetchMedicalRecords extends MedicalRecordEvent {}