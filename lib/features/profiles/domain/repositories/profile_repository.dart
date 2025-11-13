import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> get();
  Future<Either<Failure, Unit>> update(UpdateProfileParams profile);
  Future<Either<Failure, ProfessionalProfile>> getProfessionalProfile(
      String role);
  Future<Either<Failure, Unit>> updateProfessionalProfile(
      UpdateProfessionalProfileParams params);
}
