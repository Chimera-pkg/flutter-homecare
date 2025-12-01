import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:m2health/features/auth/data/repositories/auth_repository.dart';

// States
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {} // Needs email verification

class SignUpSSOSuccess extends SignUpState {} // Automatically logged in

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}

class SignUpCancelled extends SignUpState {}

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository}) : super(SignUpInitial());

  // Traditional SignUp
  Future<void> signUp(
      String email, String password, String username, String role) async {
    if (email.isEmpty ||
        !EmailValidator.validate(email) ||
        password.isEmpty ||
        username.isEmpty ||
        role.isEmpty) {
      emit(SignUpFailure('Please fill in all fields correctly.'));
      return;
    }
    emit(SignUpLoading());

    final result = await authRepository.register(
        email, password, username, role.toLowerCase());

    if (result.status == AuthResultStatus.success) {
      emit(SignUpSuccess());
    } else {
      emit(SignUpFailure(result.message ?? 'Registration failed'));
    }
  }

  // Google SignUp
  Future<void> signUpWithGoogle(String role) async {
    if (role.isEmpty) {
      emit(SignUpFailure('Please select a role first.'));
      return;
    }
    emit(SignUpLoading());

    final result = await authRepository.authenticateWithGoogle(role: role);

    switch (result.status) {
      case AuthResultStatus.success:
        emit(SignUpSSOSuccess());
        break;
      case AuthResultStatus.requiresRole:
        // This case should ideally not happen from the sign-up page
        // as a role is already provided. But if it does, treat as an error.
        emit(SignUpFailure(
            'This Google account is already partially registered. Please sign in instead.'));
        break;
      case AuthResultStatus.failure:
        emit(SignUpFailure(result.message ?? 'Google Sign-Up failed'));
        break;
      case AuthResultStatus.cancelled:
        emit(SignUpInitial()); // Or a new SignUpCancelled state
        break;
    }
  }
}
