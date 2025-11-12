import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';

class DeletePersonalIssue {
  final PersonalIssueRepository repository;

  DeletePersonalIssue(this.repository);

  Future<Either<Failure, Unit>> call(int issueId) async {
    return await repository.deletePersonalIssue(issueId);
  }
}
