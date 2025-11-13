// schedule/domain/usecases/update_override.dart
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateOverride {
  final ScheduleRepository repository;
  UpdateOverride(this.repository);

  Future<Either<Failure, Unit>> call(
      ProviderAvailabilityOverride params) async {
    return await repository.updateOverride(params);
  }
}
