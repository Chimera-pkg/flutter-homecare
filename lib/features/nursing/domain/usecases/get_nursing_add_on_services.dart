import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/nursing/const.dart';
import 'package:m2health/features/nursing/domain/entities/add_on_service.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';

class GetNursingAddOnServices {
  final NursingRepository repository;

  GetNursingAddOnServices(this.repository);

  Future<Either<Failure, List<AddOnService>>> call(
      NurseServiceType serviceType) async {
    return await repository.getNursingAddOnServices(serviceType);
  }
}
