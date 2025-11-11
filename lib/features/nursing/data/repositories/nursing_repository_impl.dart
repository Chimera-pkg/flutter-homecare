import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/features/nursing/data/mappers/nursing_case_mapper.dart';
import 'package:m2health/features/nursing/data/models/nursing_personal_case.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_issue.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource remoteDataSource;
  final NursingCaseMapper mapper;

  NursingRepositoryImpl({required this.remoteDataSource, required this.mapper});


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
      return Left(ServerFailure(e.message ?? 'A network error occurred'));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createNursingCase(
      NursingCase nursingCase) async {
    try {
      final nursingCaseModels = mapper.mapEntityToModels(nursingCase);

      for (final model in nursingCaseModels) {
        await remoteDataSource.createNursingCase(model);
      }
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
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
    return professionals;
  }

  @override
  Future<ProfessionalEntity> getProfessionalDetail(
      String serviceType, int id) async {
    return await remoteDataSource.getProfessionalDetail(serviceType, id);
  }

  @override
  Future<void> toggleFavorite(int professionalId, bool isFavorite) async {
    await remoteDataSource.toggleFavorite(professionalId, isFavorite);
  }

  @override
  Future<Either<Failure, List<AddOnService>>> getNursingAddOnServices(
      NurseServiceType serviceType) async {
    try {
      final addOnServices =
          await remoteDataSource.getAddOnServices(serviceType.apiValue);
      return Right(addOnServices);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NursingIssue>> addNursingIssue(
      NursingIssue issue, NursingCase currentCase) async {
    try {
      final model = NursingPersonalCaseModel(
        title: issue.title,
        description: issue.description,
        images: issue.images,
        mobilityStatus: currentCase.mobilityStatus?.apiValue,
        careType: currentCase.careType,
        addOn: currentCase.addOnServices,
        estimatedBudget: currentCase.estimatedBudget,
        relatedHealthRecordId: currentCase.relatedHealthRecordId,
      );

      final createdModel = await remoteDataSource.createNursingCase(model);

      final createdIssue = NursingIssue(
        id: createdModel.id,
        title: createdModel.title,
        description: createdModel.description ?? '',
        images: createdModel.images ?? [],
        imageUrls: createdModel.imageUrls ?? [],
      );
      return Right(createdIssue);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNursingIssue(int issueId) async {
    try {
      await remoteDataSource.deleteNursingIssue(issueId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
