import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

abstract class PersonalIssueRepository {
  Future<Either<Failure, List<PersonalIssue>>> getPersonalIssues(String serviceType);
  Future<Either<Failure, Unit>> createPersonalIssue(PersonalIssue issue);
  Future<Either<Failure, Unit>> updatePersonalIssue(int id, PersonalIssue issue);
  Future<Either<Failure, Unit>> deletePersonalIssue(int issueId);
}
