// schedule/domain/usecases/update_override.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateOverride {
  final ScheduleRepository repository;
  UpdateOverride(this.repository);

  Future<Either<Failure, ProviderAvailabilityOverride>> call(
      UpdateOverrideParams params) async {
    return await repository.updateOverride(params);
  }
}

class UpdateOverrideParams extends Equatable {
  final int id;
  final DateTime startDatetime;
  final DateTime endDatetime;

  const UpdateOverrideParams({
    required this.id,
    required this.startDatetime,
    required this.endDatetime,
  });

  @override
  List<Object?> get props => [id, startDatetime, endDatetime];
}