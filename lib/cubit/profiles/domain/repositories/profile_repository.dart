import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> get();
  Future<Either<Failure, Unit>> update(UpdateProfileParams profile);
}
