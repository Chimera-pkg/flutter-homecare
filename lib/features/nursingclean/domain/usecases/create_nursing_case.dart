import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursingclean/domain/repositories/nursing_repository.dart';

class CreateNursingCase {
  final NursingRepository repository;

  CreateNursingCase(this.repository);

  Future<Either<Failure, Unit>> call(NursingCase nursingCase) async {
    return await repository.createNursingCase(nursingCase);
  }
}
