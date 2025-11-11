import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/data/datasources/schedule_datasource.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:m2health/features/schedule/domain/usecases/index.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDatasource remoteDatasource;

  ScheduleRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ProviderAvailability>>> getAvailabilities() async {
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
      final result =
          await remoteDatasource.updateAvailability(params.id, data);
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
  Future<Either<Failure, List<ProviderAvailabilityOverride>>>
      getOverrides() async {
    try {
      final result = await remoteDatasource.getOverrides();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderAvailabilityOverride>> addOverride(
      AddOverrideParams params) async {
    try {
      final data = {
        'start_datetime': params.startDatetime.toIso8601String(),
        'end_datetime': params.endDatetime.toIso8601String(),
        'is_available': true, // Logic is "replace", so always true
      };
      final result = await remoteDatasource.addOverride(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderAvailabilityOverride>> updateOverride(
      UpdateOverrideParams params) async {
    try {
      final data = {
        'start_datetime': params.startDatetime.toIso8601String(),
        'end_datetime': params.endDatetime.toIso8601String(),
      };
      final result = await remoteDatasource.updateOverride(params.id, data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOverride(int id) async {
    try {
      await remoteDatasource.deleteOverride(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TimeSlot>>> getAvailableSlots(
      GetAvailableSlotsParams params) async {
    try {
      final result = await remoteDatasource.getAvailableSlots(params.date, params.timezone);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}