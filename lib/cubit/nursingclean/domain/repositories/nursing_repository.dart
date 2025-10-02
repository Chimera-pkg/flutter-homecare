import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_service_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';

abstract class NursingRepository {
  Future<List<NursingServiceEntity>> getNursingServices();
  // Future<List<NursingCase>> getNursingCase();
  // Future<void> createNursingCase(NursingCase nursingCase);
  Future<List<Map<String, dynamic>>> getMedicalRecords();
  Future<void> updateNursingCase(String id, Map<String, dynamic> data);
  Future<List<ProfessionalEntity>> getProfessionals(String serviceType);
  Future<void> toggleFavorite(int professionalId, bool isFavorite);

  Future<Either<Failure, NursingCase>> getNursingCase();
  Future<Either<Failure, Unit>> createNursingCase(NursingCase data);
  Future<Either<Failure, List<AddOnService>>> getNursingAddOnServices();
}
