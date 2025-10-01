import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class CreatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  CreatePharmacogenomic(this.repository);

  Future<void> call(
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
  ) async {
    await repository.createPharmacogenomic(
      gene,
      genotype,
      phenotype,
      medicationGuidance
    );
  }
}

class UpdatePharmacogenomic {
  final PharmacogenomicsRepository repository;

  UpdatePharmacogenomic(this.repository);

  Future<void> call(
    int id,
    String gene,
    String genotype,
    String phenotype,
    String medicationGuidance,
  ) async {
    await repository.updatePharmacogenomic(
      id,
      gene,
      genotype,
      phenotype,
      medicationGuidance
    );
  }
}

class DeletePharmacogenomic {
  final PharmacogenomicsRepository repository;

  DeletePharmacogenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deletePharmacogenomic(id);
  }
}
