import 'package:dartz/dartz.dart';
import 'package:m2health/cubit/wellness_genomics/domain/entities/wellness_genomics.dart';
import 'package:m2health/cubit/wellness_genomics/domain/repositories/wellness_genomics_repository.dart';

class GetWellnessGenomics {
  final WellnessGenomicsRepository repository;

  GetWellnessGenomics(this.repository);

  Future<Option<WellnessGenomics>> call() async {
    return await repository.getWellnessGenomics();
  }
}
