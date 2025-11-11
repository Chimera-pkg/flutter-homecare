import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class GetNursingCase {
  final NursingRepository repository;

  GetNursingCase(this.repository);

  Future<Either<Failure, NursingCase>> call() async {
    return await repository.getNursingCase();
  }
}
