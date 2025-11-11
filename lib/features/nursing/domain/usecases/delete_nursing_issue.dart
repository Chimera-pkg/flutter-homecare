import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class DeleteNursingIssue {
  final NursingRepository repository;

  DeleteNursingIssue(this.repository);

  Future<Either<Failure, Unit>> call(int issueId) async {
    return await repository.deleteNursingIssue(issueId);
  }
}