import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/domain/repositories/medical_record_repository.dart';

class GetMedicalRecords {
  final MedicalRecordRepository repository;

  GetMedicalRecords(this.repository);

  Future<Either<Failure, List<MedicalRecord>>> call() async {
    return await repository.getMedicalRecords();
  }
}
