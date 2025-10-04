import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';

class GetNursingAddOnServices {
  final NursingRepository repository;

  GetNursingAddOnServices(this.repository);

  Future<Either<Failure, List<AddOnService>>> call() async {
    return await repository.getNursingAddOnServices();
  }
}