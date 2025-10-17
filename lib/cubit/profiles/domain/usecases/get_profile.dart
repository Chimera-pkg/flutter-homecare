import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/domain/repositories/profile_repository.dart';

class GetProfile {
  ProfileRepository repository;

  GetProfile(this.repository);

  Future<Either<Failure, Profile>> call() async {
    return await repository.get();
  }
}