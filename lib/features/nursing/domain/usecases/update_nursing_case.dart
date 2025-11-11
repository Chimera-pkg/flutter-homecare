import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class UpdateNursingCase {
  final NursingRepository repository;

  UpdateNursingCase(this.repository);

  Future<void> call(String id, Map<String, dynamic> data) async {
    await repository.updateNursingCase(id, data);
  }
}
