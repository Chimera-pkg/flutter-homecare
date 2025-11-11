import 'package:dartz/dartz.dart';
import 'package:m2health/features/pharmacogenomics/domain/entities/pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';

class GetPharmacogenomics {
  final PharmacogenomicsRepository repository;

  GetPharmacogenomics(this.repository);

  Future<Option<Pharmacogenomics>> call() async {
    return await repository.getPharmacogenomics();
  }
}
