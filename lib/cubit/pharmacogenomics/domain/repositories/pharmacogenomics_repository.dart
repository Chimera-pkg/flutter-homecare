import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';

abstract class PharmacogenomicsRepository {
  Future<List<Pharmacogenomics>> getPharmacogenomics();
  Future<Pharmacogenomics> getPharmacogenomicById(int id);
  Future<void> createPharmacogenomic(String gene, String genotype,
      String phenotype, String medicationGuidance);
  Future<void> updatePharmacogenomic(int id, String gene, String genotype,
      String phenotype, String medicationGuidance);
  Future<void> deletePharmacogenomic(int id);
}
