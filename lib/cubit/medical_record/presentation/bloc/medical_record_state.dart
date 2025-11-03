// medical_record/presentation/bloc/medical_record_state.dart

import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';

enum ListStatus { initial, loading, success, failure }

enum DeleteStatus { initial, loading, success, failure }

class MedicalRecordState extends Equatable {
  const MedicalRecordState({
    this.listStatus = ListStatus.initial,
    this.deleteStatus = DeleteStatus.initial,
    this.medicalRecords = const <MedicalRecord>[],
    this.listError,
    this.deleteError,
  });

  final ListStatus listStatus;
  final List<MedicalRecord> medicalRecords;
  final String? listError;

  final DeleteStatus deleteStatus;
  final String? deleteError;

  MedicalRecordState copyWith({
    ListStatus? listStatus,
    DeleteStatus? deleteStatus,
    List<MedicalRecord>? medicalRecords,
    String? listError,
    String? deleteError,
  }) {
    return MedicalRecordState(
      listStatus: listStatus ?? this.listStatus,
      // Reset delete status on list status change
      deleteStatus: (listStatus != null)
          ? DeleteStatus.initial
          : (deleteStatus ?? this.deleteStatus),
      medicalRecords: medicalRecords ?? this.medicalRecords,
      listError: listError ?? this.listError,
      deleteError: deleteError ?? this.deleteError,
    );
  }

  @override
  List<Object?> get props => [
        listStatus,
        deleteStatus,
        medicalRecords,
        listError,
        deleteError,
      ];
}
