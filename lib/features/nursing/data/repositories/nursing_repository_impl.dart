import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/features/nursing/data/models/personal_issue.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class NursingRepositoryImpl implements NursingRepository {
  final NursingRemoteDataSource remoteDataSource;

  NursingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    return await remoteDataSource.getMedicalRecords();
  }

  @override
  Future<Either<Failure, List<PersonalIssue>>> getPersonalIssues() async {
    try {
      final issues = await remoteDataSource.getPersonalIssues();
      return Right(issues);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createPersonalIssue(
      PersonalIssue issue) async {
    try {
      final model = PersonalIssueModel.fromEntity(issue);
      await remoteDataSource.createPersonalIssue(model);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePersonalIssue(
      int id, PersonalIssue issue) async {
    try {
      final model = PersonalIssueModel.fromEntity(issue);
      await remoteDataSource.updatePersonalIssue(id, model);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePersonalIssue(int issueId) async {
    try {
      await remoteDataSource.deletePersonalIssue(issueId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
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
}
