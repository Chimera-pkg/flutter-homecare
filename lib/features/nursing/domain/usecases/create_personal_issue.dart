import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class CreatePersonalIssue {
  final NursingRepository repository;

  CreatePersonalIssue(this.repository);

  Future<Either<Failure, Unit>> call(PersonalIssue issue) async {
    return await repository.createPersonalIssue(issue);
  }
}