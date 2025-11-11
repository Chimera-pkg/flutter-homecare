import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class UpdatePersonalIssue {
  final NursingRepository repository;

  UpdatePersonalIssue(this.repository);

  Future<void> call(int id, PersonalIssue data) async {
    await repository.updatePersonalIssue(id, data);
  }
}
