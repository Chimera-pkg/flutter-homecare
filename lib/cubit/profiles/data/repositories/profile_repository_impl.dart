import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, Profile>> get() async {
    try {
      final profile = await remoteDatasource.getProfile();
      log('Profile fetched: $profile', name: 'ProfileRepositoryImpl');
      return Right(profile);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> update(UpdateProfileParams params) async {
    try {
      final profileData = {
        'username': params.username,
        'email': params.email,
        'age': params.age,
        'weight': params.weight,
        'height': params.height,
        'phone_number': params.phoneNumber,
        'home_address': params.homeAddress,
        'gender': params.gender,
        'job_title': params.jobTitle,
        'about_me': params.aboutMe,
        'working_hours': params.workHours,
        'workplace': params.workPlace,
      };

      await remoteDatasource.updateProfile(profileData, params.avatar);

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
