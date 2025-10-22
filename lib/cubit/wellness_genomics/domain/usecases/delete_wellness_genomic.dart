import 'package:m2health/cubit/wellness_genomics/domain/repositories/wellness_genomics_repository.dart';

class DeleteWellnessGenomic {
  final WellnessGenomicsRepository repository;

  DeleteWellnessGenomic(this.repository);

  Future<void> call(int id) async {
    await repository.deleteWellnessGenomic(id);
  }
}
