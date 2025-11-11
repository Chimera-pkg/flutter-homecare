import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class GetPersonalIssues {
  final NursingRepository repository;

 GetPersonalIssues(this.repository);

  Future<Either<Failure, List<PersonalIssue>>> call() async {
    return await repository.getPersonalIssues();
  }
}
