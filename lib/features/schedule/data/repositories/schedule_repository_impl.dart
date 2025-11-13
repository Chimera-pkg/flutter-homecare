import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/data/datasources/schedule_datasource.dart';
import 'package:m2health/features/schedule/data/models/provider_availability_override_model.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:m2health/features/schedule/domain/usecases/index.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDatasource remoteDatasource;

  ScheduleRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ProviderAvailability>>>
      getAvailabilities() async {
    try {
      final result = await remoteDatasource.getAvailabilities();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderAvailability>> addAvailability(
      AddAvailabilityParams params) async {
    try {
      final data = {
        'day_of_week': params.dayOfWeek,
        'start_time': params.startTime,
        'end_time': params.endTime,
        if (params.timezone != null) 'timezone': params.timezone,
      };
      final result = await remoteDatasource.addAvailability(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderAvailability>> updateAvailability(
      UpdateAvailabilityParams params) async {
    try {
      final data = {
        'day_of_week': params.dayOfWeek,
        'start_time': params.startTime,
        'end_time': params.endTime,
        if (params.timezone != null) 'timezone': params.timezone,
      };
      final result = await remoteDatasource.updateAvailability(params.id, data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAvailability(int id) async {
    try {
      await remoteDatasource.deleteAvailability(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderAvailabilityOverride>>> getAllOverrides() async {
    try {
      final result = await remoteDatasource.getAllOverrides();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOverride(
      ProviderAvailabilityOverride params) async {
    try {
      final model = ProviderAvailabilityOverrideModel.fromEntity(params);
      await remoteDatasource.updateOverride(model);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOverride(String date) async {
    try {
      await remoteDatasource.deleteOverrideByDate(date);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlot>>> getSlotsPreview(
      GetSlotsPreviewParams params) async {
    try {
      final result = await remoteDatasource.getAvailableSlots(
          params.date, params.timezone);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
