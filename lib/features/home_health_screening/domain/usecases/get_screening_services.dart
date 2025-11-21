import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';

class GetScreeningServices {
  final HomeHealthScreeningRepository repository;

  GetScreeningServices(this.repository);

  Future<Either<Failure, List<ScreeningCategory>>> call() async {
    return await repository.getScreeningServices();
  }
}