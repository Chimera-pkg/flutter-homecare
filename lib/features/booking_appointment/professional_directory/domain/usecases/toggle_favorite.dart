import 'package:m2health/features/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class ToggleFavorite {
  final ProfessionalRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(int professionalId, bool isFavorite) async {
    await repository.toggleFavorite(professionalId, isFavorite);
  }
}
