import 'package:m2health/cubit/pharmacogenomics/data/models/pharmacogenomics_model.dart';

abstract class PharmacogenomicsRemoteDataSource {
  Future<List<PharmacogenomicsModel>> getPharmacogenomics();
  Future<PharmacogenomicsModel> getPharmacogenomicById(int id);
  Future<void> createPharmacogenomic(String gene, String genotype,
      String phenotype, String medicationGuidance);
  Future<void> updatePharmacogenomic(int id, String gene, String genotype,
      String phenotype, String medicationGuidance);
  Future<void> deletePharmacogenomic(int id);
}
