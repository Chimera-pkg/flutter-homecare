import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/cubit/schedule/domain/repositories/schedule_repository.dart';

class AddOverride {
  final ScheduleRepository repository;
  AddOverride(this.repository);

  Future<Either<Failure, ProviderAvailabilityOverride>> call(
      AddOverrideParams params) async {
    return await repository.addOverride(params);
  }
}

class AddOverrideParams extends Equatable {
  final DateTime startDatetime;
  final DateTime endDatetime;

  const AddOverrideParams({
    required this.startDatetime,
    required this.endDatetime,
  });

  @override
  List<Object?> get props => [startDatetime, endDatetime];
}