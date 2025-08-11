import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class GetMedicalRecords {
  final NursingRepository repository;

  GetMedicalRecords(this.repository);

  Future<List<Map<String, dynamic>>> call() async {
    return await repository.getMedicalRecords();
  }
}
