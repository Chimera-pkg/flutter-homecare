import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';

abstract class NursingRepository {
  Future<List<Map<String, dynamic>>> getMedicalRecords();

  Future<Either<Failure, List<PersonalIssue>>> getPersonalIssues();
  Future<Either<Failure, Unit>> createPersonalIssue(PersonalIssue issue);
  Future<Either<Failure, Unit>> updatePersonalIssue(int id, PersonalIssue issue);
  Future<Either<Failure, Unit>> deletePersonalIssue(int issueId);

  Future<List<ProfessionalEntity>> getProfessionals(String serviceType);
  Future<ProfessionalEntity> getProfessionalDetail(String serviceType, int id);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);

  Future<Either<Failure, List<AddOnService>>> getNursingAddOnServices(
      NurseServiceType serviceType);
}
