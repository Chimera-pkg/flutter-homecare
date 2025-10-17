import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/repositories/profile_repository.dart';

class UpdateProfile {
  ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, Unit>> call(UpdateProfileParams params) async {
    return await repository.update(params);
  }
}

class UpdateProfileParams {
  final String? username;
  final String? email;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress;
  final String? gender;
  final File? avatar;

  // Professional details
  final String? jobTitle;
  final String? aboutMe;
  final String? workHours;
  final String? workPlace;

  UpdateProfileParams({
    this.username,
    this.email,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.avatar,
    this.jobTitle,
    this.aboutMe,
    this.workHours,
    this.workPlace,
  });
}
