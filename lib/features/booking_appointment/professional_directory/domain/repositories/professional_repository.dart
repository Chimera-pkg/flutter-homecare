import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

abstract class ProfessionalRepository {
  Future<List<ProfessionalEntity>> getProfessionals(String role, {List<int>? serviceIds});
  Future<ProfessionalEntity> getProfessionalDetail(String role, int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}