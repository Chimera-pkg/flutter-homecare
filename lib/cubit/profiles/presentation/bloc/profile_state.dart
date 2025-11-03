import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/profiles/domain/entities/professional_profile.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSaving extends ProfileState {}

class PatientProfileLoaded extends ProfileState {
  final Profile profile;

  const PatientProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfessionalProfileLoaded extends ProfileState {
  final ProfessionalProfile profile;

  const ProfessionalProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileSuccess extends ProfileState {
  final String message;

  const ProfileSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUnauthenticated extends ProfileState {}
