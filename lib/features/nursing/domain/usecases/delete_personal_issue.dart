import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class DeletePersonalIssue {
  final NursingRepository repository;

  DeletePersonalIssue(this.repository);

  Future<Either<Failure, Unit>> call(int issueId) async {
    return await repository.deletePersonalIssue(issueId);
  }
}
