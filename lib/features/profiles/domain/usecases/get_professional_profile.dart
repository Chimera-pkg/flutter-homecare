import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/features/profiles/domain/repositories/profile_repository.dart';

class GetProfessionalProfile {
  final ProfileRepository repository;

  GetProfessionalProfile(this.repository);

  Future<Either<Failure, ProfessionalProfile>> call(String role) async {
    return await repository.getProfessionalProfile(role);
  }
}