import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/cubit/schedule/domain/repositories/schedule_repository.dart';

class AddAvailability {
  final ScheduleRepository repository;
  AddAvailability(this.repository);

  Future<Either<Failure, ProviderAvailability>> call(
      AddAvailabilityParams params) async {
    return await repository.addAvailability(params);
  }
}

class AddAvailabilityParams extends Equatable {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String? timezone;

  const AddAvailabilityParams({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.timezone,
  });

  @override
  List<Object?> get props => [dayOfWeek, startTime, endTime, timezone];

  AddAvailabilityParams copyWith({
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? timezone,
  }) {
    return AddAvailabilityParams(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timezone: timezone ?? this.timezone,
    );
  }
}