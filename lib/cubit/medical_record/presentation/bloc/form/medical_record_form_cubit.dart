import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/update_medical_record.dart';
import 'medical_record_form_state.dart';

class MedicalRecordFormCubit extends Cubit<MedicalRecordFormState> {
  final CreateMedicalRecord createMedicalRecord;
  final UpdateMedicalRecord updateMedicalRecord;

  MedicalRecordFormCubit({
    required this.createMedicalRecord,
    required this.updateMedicalRecord,
  }) : super(const MedicalRecordFormState());

  static const List<String> predefinedSpecialConsiderations = [
    'Liver Disease',
    'Kidney Disease',
    'Lung Disease',
    'Aging Adult',
    'Children',
    'Pregnant',
  ];

  void initializeForm(MedicalRecord record) {
    final considerations = record.specialConsideration
            ?.split(', ')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    emit(state.copyWith(
      initialRecord: record,
      title: record.title,
      diseaseName: record.diseaseName,
      diseaseHistory: record.diseaseHistory ?? '',
      specialConsiderations: considerations,
      treatmentInfo: record.treatmentInfo ?? '',
    ));
  }

  void titleChanged(String value) {
    emit(state.copyWith(title: value, status: FormSubmissionStatus.initial));
  }

  void diseaseNameChanged(String value) {
    emit(state.copyWith(
        diseaseName: value, status: FormSubmissionStatus.initial));
  }

  void diseaseHistoryChanged(String value) {
    emit(state.copyWith(
        diseaseHistory: value, status: FormSubmissionStatus.initial));
  }

  void toggleSpecialConsideration(String option) {
    final currentList = List<String>.from(state.specialConsiderations);
    if (currentList.contains(option)) {
      currentList.remove(option);
    } else {
      currentList.add(option);
    }
    emit(state.copyWith(
        specialConsiderations: currentList,
        status: FormSubmissionStatus.initial));
  }

  void treatmentInfoChanged(String value) {
    emit(state.copyWith(
        treatmentInfo: value, status: FormSubmissionStatus.initial));
  }

  void filePicked(File file) {
    emit(
        state.copyWith(pickedFile: file, status: FormSubmissionStatus.initial));
  }

  Future<void> submitForm() async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: FormSubmissionStatus.loading));

    final considerationsString = state.specialConsiderations.join(', ');

    try {
      if (state.isEditMode) {
        final params = UpdateRecordParams(
          id: state.initialRecord!.id,
          title: state.title,
          diseaseName: state.diseaseName,
          diseaseHistory: state.diseaseHistory,
          specialConsideration: considerationsString,
          treatmentInfo: state.treatmentInfo,
          file: state.pickedFile,
        );
        final result = await updateMedicalRecord(params);
        result.fold(
          (failure) => emit(state.copyWith(
              status: FormSubmissionStatus.failure,
              errorMessage: failure.message)),
          (record) =>
              emit(state.copyWith(status: FormSubmissionStatus.success)),
        );
      } else {
        final params = CreateRecordParams(
          title: state.title,
          diseaseName: state.diseaseName,
          diseaseHistory: state.diseaseHistory,
          specialConsideration: considerationsString,
          treatmentInfo: state.treatmentInfo,
          file: state.pickedFile,
        );
        final result = await createMedicalRecord(params);
        result.fold(
          (failure) => emit(state.copyWith(
              status: FormSubmissionStatus.failure,
              errorMessage: failure.message)),
          (record) =>
              emit(state.copyWith(status: FormSubmissionStatus.success)),
        );
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormSubmissionStatus.failure, errorMessage: e.toString()));
    }
  }
}
