import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/medical_record/domain/repositories/medical_record_repository.dart';

class DeleteMedicalRecord {
  final MedicalRecordRepository repository;

  DeleteMedicalRecord(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteMedicalRecord(id);
  }
}