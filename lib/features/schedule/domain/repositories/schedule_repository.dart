import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/usecases/index.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<ProviderAvailability>>> getAvailabilities();
  Future<Either<Failure, ProviderAvailability>> addAvailability(
      AddAvailabilityParams params);
  Future<Either<Failure, ProviderAvailability>> updateAvailability(
      UpdateAvailabilityParams params);
  Future<Either<Failure, Unit>> deleteAvailability(int id);


  Future<Either<Failure, List<ProviderAvailabilityOverride>>> getAllOverrides();
  Future<Either<Failure, Unit>> updateOverride(
      ProviderAvailabilityOverride params);
  Future<Either<Failure, Unit>> deleteOverride(String date);

  Future<Either<Failure, List<TimeSlot>>> getSlotsPreview(
      GetSlotsPreviewParams params);
}
