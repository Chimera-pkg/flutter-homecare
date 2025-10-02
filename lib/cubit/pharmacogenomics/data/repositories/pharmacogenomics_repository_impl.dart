import 'package:m2health/cubit/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/cubit/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class PharmacogenomicsRepositoryImpl implements PharmacogenomicsRepository {
  final PharmacogenomicsRemoteDataSource remoteDataSource;

  PharmacogenomicsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Pharmacogenomics>> getPharmacogenomics() async {
    print('[DEBUG] Repository: fetching pharmacogenomics');
    final result = await remoteDataSource.getPharmacogenomics();
    print(
        '[DEBUG] Repository: fetched pharmacogenomics, count: ${result.length}');
    return result;
  }

  @override
  Future<Pharmacogenomics> getPharmacogenomicById(int id) async {
    return await remoteDataSource.getPharmacogenomicById(id);
  }

  @override
  Future<void> createPharmacogenomic(String gene, String genotype,
      String phenotype, String medicationGuidance) async {
    await remoteDataSource.createPharmacogenomic(
      gene,
      genotype,
      phenotype,
      medicationGuidance
    );
  }

  @override
  Future<void> updatePharmacogenomic(int id, String gene, String genotype,
      String phenotype, String medicationGuidance) async {
    await remoteDataSource.updatePharmacogenomic(
      id,
      gene,
      genotype,
      phenotype,
      medicationGuidance
    );
  }

  @override
  Future<void> deletePharmacogenomic(int id) async {
    await remoteDataSource.deletePharmacogenomic(id);
  }
}
