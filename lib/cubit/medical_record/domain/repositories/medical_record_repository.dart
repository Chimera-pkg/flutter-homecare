import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/update_medical_record.dart';

abstract class MedicalRecordRepository {
  Future<Either<Failure, List<MedicalRecord>>> getMedicalRecords();
  Future<Either<Failure, MedicalRecord>> createMedicalRecord(
      CreateRecordParams params);
  Future<Either<Failure, MedicalRecord>> updateMedicalRecord(
      UpdateRecordParams params);
  Future<Either<Failure, void>> deleteMedicalRecord(int id);
}
