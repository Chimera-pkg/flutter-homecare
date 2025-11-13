import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';

class CreatePersonalIssue {
  final PersonalIssueRepository repository;

  CreatePersonalIssue(this.repository);

  Future<Either<Failure, Unit>> call(PersonalIssue issue) async {
    return await repository.createPersonalIssue(issue);
  }
}