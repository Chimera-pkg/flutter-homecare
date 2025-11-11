import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_case.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_issue.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_service_entity.dart';
import 'package:m2health/features/nursing/domain/entities/professional_entity.dart';

abstract class NursingRepository {
  Future<List<NursingServiceEntity>> getNursingServices();
  Future<List<Map<String, dynamic>>> getMedicalRecords();

  Future<Either<Failure, NursingCase>> getNursingCase();
  Future<Either<Failure, Unit>> createNursingCase(NursingCase data);
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<Either<Failure, NursingIssue>> addNursingIssue(
      NursingIssue issue, NursingCase currentCase);
  Future<Either<Failure, Unit>> deleteNursingIssue(int issueId);

  Future<List<ProfessionalEntity>> getProfessionals(String serviceType);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);
  Future<ProfessionalEntity> getProfessionalDetail(String serviceType, int id);

  Future<Either<Failure, List<AddOnService>>> getNursingAddOnServices(
      NurseServiceType serviceType);
}
