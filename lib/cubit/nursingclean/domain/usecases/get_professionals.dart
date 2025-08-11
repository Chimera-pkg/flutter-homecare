import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class GetProfessionals {
  final NursingRepository repository;

  GetProfessionals(this.repository);

  Future<List<ProfessionalEntity>> call(String serviceType) async {
    return await repository.getProfessionals(serviceType);
  }
}
