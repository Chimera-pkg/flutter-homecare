import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/repositories/personal_issue_repository.dart';

class UpdatePersonalIssue {
  final PersonalIssueRepository repository;

  UpdatePersonalIssue(this.repository);

  Future<void> call(int id, PersonalIssue data) async {
    await repository.updatePersonalIssue(id, data);
  }
}
