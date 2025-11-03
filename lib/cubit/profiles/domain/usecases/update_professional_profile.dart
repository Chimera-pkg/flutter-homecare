import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/repositories/profile_repository.dart';

class UpdateProfessionalProfile {
  final ProfileRepository repository;

  UpdateProfessionalProfile(this.repository);

  Future<Either<Failure, Unit>> call(
      UpdateProfessionalProfileParams params) async {
    return await repository.updateProfessionalProfile(params);
  }
}

class UpdateProfessionalProfileParams extends Equatable {
  final String role; // Role is needed to determine endpoint
  final String? name;
  final String? about;
  final String? jobTitle;
  final String? workHours;
  final String? workPlace;
  final File? avatar;

  const UpdateProfessionalProfileParams({
    required this.role,
    this.name,
    this.about,
    this.jobTitle,
    this.workHours,
    this.workPlace,
    this.avatar,
  });

  @override
  List<Object?> get props =>
      [role, name, about, jobTitle, workHours, workPlace, avatar];
      
  UpdateProfessionalProfileParams copyWith({
    String? role,
    String? name,
    String? about,
    String? jobTitle,
    String? workHours,
    String? workPlace,
    File? avatar,
  }) {
    return UpdateProfessionalProfileParams(
      role: role ?? this.role,
      name: name ?? this.name,
      about: about ?? this.about,
      jobTitle: jobTitle ?? this.jobTitle,
      workHours: workHours ?? this.workHours,
      workPlace: workPlace ?? this.workPlace,
      avatar: avatar ?? this.avatar,
    );
  }
}