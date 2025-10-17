import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/medical_record/data/datasources/medical_record_remote_data_source.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/repositories/medical_record_repository.dart';

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
}
