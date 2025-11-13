import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class UpdateAvailability {
  final ScheduleRepository repository;
  UpdateAvailability(this.repository);

  Future<Either<Failure, ProviderAvailability>> call(
      UpdateAvailabilityParams params) async {
    return await repository.updateAvailability(params);
  }
}

class UpdateAvailabilityParams extends Equatable {
  final int id;
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? timezone;

  const UpdateAvailabilityParams({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.timezone,
  });

  @override
  List<Object?> get props => [id, dayOfWeek, startTime, endTime, timezone];

  UpdateAvailabilityParams copyWith({
    int? id,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? timezone,
  }) {
    return UpdateAvailabilityParams(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timezone: timezone ?? this.timezone,
    );
  }
}