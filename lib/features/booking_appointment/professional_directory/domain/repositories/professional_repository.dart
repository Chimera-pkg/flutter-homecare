import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';

abstract class ProfessionalRepository {
  Future<List<ProfessionalEntity>> getProfessionals(String serviceType);
  Future<ProfessionalEntity> getProfessionalDetail(String serviceType, int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
}