import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase();
    result.fold(
      (failure) {
        switch (failure) {
          case UnauthorizedFailure(message: _):
            emit(ProfileUnauthenticated());
          default:
            emit(ProfileError(failure.message));
        }
      },
      (profile) => emit(ProfileLoaded(profile)),
    );
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
}
