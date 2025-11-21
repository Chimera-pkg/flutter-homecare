import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class GetProfessionals {
  final ProfessionalRepository repository;

  GetProfessionals(this.repository);

  Future<List<ProfessionalEntity>> call(String serviceType, {List<int>? serviceIds}) async {
    return await repository.getProfessionals(serviceType, serviceIds: serviceIds);
  }
}
