import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/schedule/domain/repositories/schedule_repository.dart';

class DeleteOverride {
  final ScheduleRepository repository;
  DeleteOverride(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteOverride(id);
  }
}