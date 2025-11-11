import 'package:m2health/features/pharmacist/domain/entities/pharmacist_case.dart';
import 'package:m2health/features/pharmacist/domain/repositories/pharmacist_repository.dart';

class GetPharmacistCases {
  final PharmacistRepository repository;

  GetPharmacistCases(this.repository);

  Future<List<PharmacistCase>> call() async {
    return await repository.getPharmacistCases();
  }
}
