import 'package:m2health/features/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class DeletePharmacogenomic {
  final PharmacogenomicsRepository repository;

  DeletePharmacogenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deletePharmacogenomic(id);
  }
}