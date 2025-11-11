import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class GetProfessionalDetail {
  final NursingRepository repository;

  GetProfessionalDetail(this.repository);

  Future<ProfessionalEntity> call(String serviceType, int id) async {
    return await repository.getProfessionalDetail(serviceType, id);
  }
}
