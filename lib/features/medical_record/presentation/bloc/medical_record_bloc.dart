// medical_record/presentation/bloc/medical_record_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/delete_medical_record.dart';
import 'package:m2health/features/medical_record/domain/usecases/get_medical_records.dart';
import 'medical_record_event.dart';
import 'medical_record_state.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final GetMedicalRecords getMedicalRecords;
  final DeleteMedicalRecord deleteMedicalRecord;

  MedicalRecordBloc({
    required this.getMedicalRecords,
    required this.deleteMedicalRecord,
  }) : super(const MedicalRecordState()) {
    on<FetchMedicalRecords>(_onFetchMedicalRecords);
    on<DeleteMedicalRecordEvent>(_onDeleteMedicalRecord);
  }

  void _onFetchMedicalRecords(
    FetchMedicalRecords event,
    Emitter<MedicalRecordState> emit,
  ) async {
    emit(state.copyWith(listStatus: ListStatus.loading));
  
    final failureOrRecords = await getMedicalRecords();

    failureOrRecords.fold(
      (failure) => emit(state.copyWith(
        listStatus: ListStatus.failure,
        listError: failure.message,
      )),
      (records) => emit(state.copyWith(
        listStatus: ListStatus.success,
        medicalRecords: records,
      )),
    );
  }

  void _onDeleteMedicalRecord(
    DeleteMedicalRecordEvent event,
    Emitter<MedicalRecordState> emit,
  ) async {
    emit(state.copyWith(deleteStatus: DeleteStatus.loading));

    final failureOrSuccess = await deleteMedicalRecord(event.record.id);

    failureOrSuccess.fold(
      (failure) {
        emit(state.copyWith(
          deleteStatus: DeleteStatus.failure,
          deleteError: failure.message,
        ));
      },
      (_) {
        final updatedList = List<MedicalRecord>.from(state.medicalRecords)
          ..remove(event.record);

        emit(state.copyWith(
          deleteStatus: DeleteStatus.success,
          medicalRecords: updatedList,
        ));
      },
    );
  }
}
