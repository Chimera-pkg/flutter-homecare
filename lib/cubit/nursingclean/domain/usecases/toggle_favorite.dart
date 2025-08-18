import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class ToggleFavorite {
  final NursingRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(int professionalId, bool isFavorite) async {
    await repository.toggleFavorite(professionalId, isFavorite);
  }
}
