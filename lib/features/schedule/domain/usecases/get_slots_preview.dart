import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class GetSlotsPreview {
  final ScheduleRepository repository;
  GetSlotsPreview(this.repository);

  Future<Either<Failure, List<TimeSlot>>> call(
      GetSlotsPreviewParams params) async {
    return await repository.getSlotsPreview(params);
  }
}

class GetSlotsPreviewParams extends Equatable {
  final String date; // "YYYY-MM-DD"
  final String? timezone;

  const GetSlotsPreviewParams({
    required this.date,
    this.timezone,
  });

  @override
  List<Object?> get props => [date, timezone];
}