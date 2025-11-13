import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';

enum FormSubmissionStatus { initial, loading, success, failure }

class MedicalRecordFormState extends Equatable {
  const MedicalRecordFormState({
    this.initialRecord,
    this.title = '',
    this.diseaseName = '',
    this.diseaseHistory = '',
    this.specialConsiderations = const <String>[],
    this.treatmentInfo = '',
    this.pickedFile,
    this.status = FormSubmissionStatus.initial,
    this.errorMessage,
  });

  final MedicalRecord? initialRecord;
  final String title;
  final String diseaseName;
  final String diseaseHistory;
  final List<String> specialConsiderations;
  final String treatmentInfo;
  final File? pickedFile;
  final FormSubmissionStatus status;
  final String? errorMessage;

  bool get isEditMode => initialRecord != null;

  bool get isFormValid =>
      title.isNotEmpty && diseaseName.isNotEmpty && diseaseHistory.isNotEmpty;

  MedicalRecordFormState copyWith({
    MedicalRecord? initialRecord,
    String? title,
    String? diseaseName,
    String? diseaseHistory,
    List<String>? specialConsiderations,
    String? treatmentInfo,
    File? pickedFile,
    FormSubmissionStatus? status,
    String? errorMessage,
  }) {
    return MedicalRecordFormState(
      initialRecord: initialRecord ?? this.initialRecord,
      title: title ?? this.title,
      diseaseName: diseaseName ?? this.diseaseName,
      diseaseHistory: diseaseHistory ?? this.diseaseHistory,
      specialConsiderations:
          specialConsiderations ?? this.specialConsiderations,
      treatmentInfo: treatmentInfo ?? this.treatmentInfo,
      pickedFile: pickedFile ?? this.pickedFile,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        initialRecord,
        title,
        diseaseName,
        diseaseHistory,
        specialConsiderations,
        treatmentInfo,
        pickedFile,
        status,
        errorMessage,
      ];
}
