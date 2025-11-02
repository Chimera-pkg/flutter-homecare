import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/medical_record/data/datasources/medical_record_remote_data_source.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/repositories/medical_record_repository.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/update_medical_record.dart';

class MedicalRecordRepositoryImpl implements MedicalRecordRepository {
  final MedicalRecordRemoteDataSource remoteDataSource;

  MedicalRecordRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MedicalRecord>>> getMedicalRecords() async {
    try {
      final remoteRecords = await remoteDataSource.getMedicalRecords();
      return Right(remoteRecords);
    } on Exception {
      return const Left(ServerFailure('Failed to fetch medical records'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedicalRecord(int id) async {
    try {
      await remoteDataSource.deleteMedicalRecord(id);
      return const Right(null);
    } on Exception {
      return const Left(ServerFailure('Failed to delete medical record'));
    }
  }

  @override
  Future<Either<Failure, MedicalRecord>> createMedicalRecord(
      CreateRecordParams params) async {
    try {
      final newRecord = await remoteDataSource.createMedicalRecord(params);
      return Right(newRecord);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicalRecord>> updateMedicalRecord(
      UpdateRecordParams params) async {
    try {
      final updatedRecord = await remoteDataSource.updateMedicalRecord(params);
      return Right(updatedRecord);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
