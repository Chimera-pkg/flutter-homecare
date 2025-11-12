import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';

class GetPersonalIssues {
  final PersonalIssueRepository repository;

 GetPersonalIssues(this.repository);

  Future<Either<Failure, List<PersonalIssue>>> call(String serviceType) async {
    return await repository.getPersonalIssues(serviceType);
  }
}
