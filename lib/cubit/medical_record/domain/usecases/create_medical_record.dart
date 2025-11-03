import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/repositories/medical_record_repository.dart';

class CreateMedicalRecord {
  final MedicalRecordRepository repository;

  CreateMedicalRecord(this.repository);

  Future<Either<Failure, MedicalRecord>> call(CreateRecordParams params) async {
    return await repository.createMedicalRecord(params);
  }
}

class CreateRecordParams extends Equatable {
  final String title;
  final String diseaseName;
  final String diseaseHistory;
  final String? specialConsideration;
  final String? treatmentInfo;
  final File? file;

  const CreateRecordParams({
    required this.title,
    required this.diseaseName,
    required this.diseaseHistory,
    this.specialConsideration,
    this.treatmentInfo,
    this.file,
  });

  @override
  List<Object?> get props => [
        title,
        diseaseName,
        diseaseHistory,
        specialConsideration,
        treatmentInfo,
        file
      ];
}
