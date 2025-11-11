import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class GetOverrides {
  final ScheduleRepository repository;
  GetOverrides(this.repository);

  Future<Either<Failure, List<ProviderAvailabilityOverride>>> call() async {
    return await repository.getOverrides();
  }
}