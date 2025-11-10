import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/cubit/schedule/domain/repositories/schedule_repository.dart';

class GetAvailabilities {
  final ScheduleRepository repository;
  GetAvailabilities(this.repository);

  Future<Either<Failure, List<ProviderAvailability>>> call() async {
    return await repository.getAvailabilities();
  }
}