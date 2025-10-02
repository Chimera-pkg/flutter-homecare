import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/get_medical_records.dart';
import 'medical_record_event.dart';
import 'medical_record_state.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final GetMedicalRecords getMedicalRecords;

  MedicalRecordBloc({required this.getMedicalRecords})
      : super(MedicalRecordInitial()) {
    on<FetchMedicalRecords>((event, emit) async {
      emit(MedicalRecordLoading());

      final failureOrRecords = await getMedicalRecords();

      failureOrRecords.fold(
        (failure) => emit(MedicalRecordError(failure.message)),
        (records) => emit(MedicalRecordLoaded(records)),
      );
    });
  }
}
