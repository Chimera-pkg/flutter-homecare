import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/cubit/nursingclean/data/mappers/nursing_case_mapper.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource remoteDataSource;
  final NursingCaseMapper mapper;

  NursingRepositoryImpl({required this.remoteDataSource, required this.mapper});

  @override
  Future<List<NursingServiceEntity>> getNursingServices() async {
    final nursingServiceModels = await remoteDataSource.getNursingServices();
    return nursingServiceModels;
  }

  @override
  Future<Either<Failure, NursingCase>> getNursingCase() async {
    try {
      final nursingCaseModels =
          await remoteDataSource.getNursingPersonalCases();
      final nursingCaseEntity = mapper.mapModelsToEntity(nursingCaseModels);
      return Right(nursingCaseEntity);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure("User is not authenticated"));
      }
      return Left(Failure(e.message ?? 'A network error occurred'));
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createNursingCase(
      NursingCase nursingCase) async {
    try {
      final nursingCaseModels = mapper.mapEntityToModels(nursingCase);

      // NOTE: This is suboptimal. The API should ideally support batch creation.
      for (final model in nursingCaseModels) {
        await remoteDataSource.createNursingCase(model);
      }
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    return await remoteDataSource.getMedicalRecords();
  }

  @override
  Future<void> updateNursingCase(String id, Map<String, dynamic> data) async {
    await remoteDataSource.updateNursingCase(id, data);
  }

  @override
  Future<List<ProfessionalEntity>> getProfessionals(String serviceType) async {
    final professionals = await remoteDataSource.getProfessionals(serviceType);
    return professionals
        .map((professional) => ProfessionalEntity(
              id: professional['id'] ?? 0,
              name: professional['name'] ?? 'Unknown Provider',
              avatar: professional['avatar'] ?? '',
              experience: professional['experience'] ?? 0,
              rating: (professional['rating'] ?? 0.0).toDouble(),
              about: professional['about'] ?? 'No description available',
              workingInformation: professional['working_information'] ?? '',
              daysHour: professional['days_hour'] ?? 'Not specified',
              mapsLocation:
                  professional['maps_location'] ?? 'Location not available',
              certification: professional['certification'] ?? '',
              userId: professional['user_id'] ?? 0,
              user: professional['user'],
              createdAt: professional['created_at'] ?? '',
              updatedAt: professional['updated_at'] ?? '',
              isFavorite: professional['isFavorite'] ?? false,
              role: professional['role'] ?? 'nurse',
              providerType: professional['provider_type'] ?? 'nurse',
            ))
        .toList();
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    await remoteDataSource.toggleFavorite(professionalId, isFavorite);
  }

  @override
  Future<Either<Failure, List<AddOnService>>> getNursingAddOnServices() async {
    try {
      final addOnServices = await remoteDataSource.getAddOnServices();
      return Right(addOnServices);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
