import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class GetProfessionalDetail {
  final ProfessionalRepository repository;

  GetProfessionalDetail(this.repository);

  Future<ProfessionalEntity> call(String serviceType, int id) async {
    return await repository.getProfessionalDetail(serviceType, id);
  }
}
