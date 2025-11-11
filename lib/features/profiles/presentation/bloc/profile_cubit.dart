import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/profiles/domain/usecases/index.dart';
import 'package:m2health/features/profiles/presentation/bloc/profile_state.dart';
import 'package:m2health/utils.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;
  final GetProfessionalProfile getProfessionalProfileUseCase;
  final UpdateProfessionalProfile updateProfessionalProfileUseCase;

  String? _currentRole;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getProfessionalProfileUseCase,
    required this.updateProfessionalProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    final role = await Utils.getSpString(Const.ROLE);
    _currentRole = role;

    if (role == null) {
      emit(ProfileUnauthenticated());
      return;
    }

    if (['nurse', 'pharmacist', 'radiologist'].contains(role)) {
      final result = await getProfessionalProfileUseCase(role);
      result.fold(
        (failure) {
          if (failure is UnauthorizedFailure) {
            emit(ProfileUnauthenticated());
          } else {
            emit(ProfileError(failure.message));
          }
        },
        (profile) {
          log('Professional profile loaded: $profile', name: 'ProfileCubit');
          emit(ProfessionalProfileLoaded(profile));
        },
      );
    } else {
      final result = await getProfileUseCase();
      result.fold(
        (failure) {
          if (failure is UnauthorizedFailure) {
            emit(ProfileUnauthenticated());
          } else {
            emit(ProfileError(failure.message));
          }
        },
        (profile) => emit(PatientProfileLoaded(profile)),
      );
    }
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(ProfileSaving());
    final result = await updateProfileUseCase(params);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {
        emit(const ProfileSuccess('Profile updated successfully!'));
        loadProfile();
      },
    );
  }

  Future<void> updateProfessionalProfile(
      UpdateProfessionalProfileParams params) async {
    if (_currentRole == null) {
      emit(const ProfileError("Cannot update profile: role unknown."));
      return;
    }
    emit(ProfileSaving());

    final fullParams = params.copyWith(role: _currentRole);

    final result = await updateProfessionalProfileUseCase(fullParams);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {
        emit(const ProfileSuccess('Profile updated successfully!'));
        loadProfile();
      },
    );
  }
}
