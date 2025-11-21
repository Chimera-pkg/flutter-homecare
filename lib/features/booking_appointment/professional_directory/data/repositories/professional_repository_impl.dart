import 'package:m2health/features/booking_appointment/professional_directory/data/datasources/professional_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';

class ProfessionalRepositoryImpl implements ProfessionalRepository {
  ProfessionalRemoteDatasource remoteDataSource;

  ProfessionalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProfessionalEntity>> getProfessionals(String role, {List<int>? serviceIds}) async {
    final professionals = await remoteDataSource.getProfessionals(role, serviceIds: serviceIds);
    return professionals;
  }

  @override
  Future<ProfessionalEntity> getProfessionalDetail(String role, int id) async {
    return await remoteDataSource.getProfessionalDetail(role, id);
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    await remoteDataSource.toggleFavorite(professionalId, isFavorite);
  }
}
