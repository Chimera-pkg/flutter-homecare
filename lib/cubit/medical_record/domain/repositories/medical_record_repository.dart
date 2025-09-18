import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';

abstract class MedicalRecordRepository {
  Future<Either<Failure, List<MedicalRecord>>> getMedicalRecords();
}
