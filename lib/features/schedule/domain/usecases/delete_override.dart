import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';

class DeleteOverride {
  final ScheduleRepository repository;
  DeleteOverride(this.repository);

  Future<Either<Failure, Unit>> call(String date) async {
    return await repository.deleteOverride(date);
  }
}