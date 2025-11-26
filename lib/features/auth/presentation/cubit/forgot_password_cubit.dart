import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/auth/data/repositories/auth_repository.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordOtpSent extends ForgotPasswordState {
  final String email;
  ForgotPasswordOtpSent(this.email);
}

class ForgotPasswordOtpVerified extends ForgotPasswordState {
  final String email;
  final String resetToken;
  ForgotPasswordOtpVerified(this.email, this.resetToken);
}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  ForgotPasswordFailure(this.message);
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordCubit({required this.authRepository})
      : super(ForgotPasswordInitial());

  Future<void> requestOtp(String email) async {
    emit(ForgotPasswordLoading());
    final result = await authRepository.requestOtp(email);
    if (result.status == AuthResultStatus.success) {
      emit(ForgotPasswordOtpSent(email));
    } else {
      emit(ForgotPasswordFailure(result.message ?? 'Failed to send OTP'));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(ForgotPasswordLoading());
    final result = await authRepository.verifyOtp(email, otp);
    if (result.status == AuthResultStatus.success) {
      String resetToken = otp;
      if (result.data != null && result.data is Map) {
        resetToken =
            result.data['resetToken'] ?? result.data['token'] ?? otp;
      }
      emit(ForgotPasswordOtpVerified(email, resetToken));
    } else {
      emit(ForgotPasswordFailure(result.message ?? 'Invalid OTP'));
    }
  }

  Future<void> resetPassword(
      String resetToken, String password, String passwordConfirmation) async {
    emit(ForgotPasswordLoading());
    final result = await authRepository.resetPassword(
        resetToken, password, passwordConfirmation);
    if (result.status == AuthResultStatus.success) {
      emit(ForgotPasswordSuccess());
    } else {
      emit(ForgotPasswordFailure(result.message ?? 'Failed to reset password'));
    }
  }
  
  void resetState() {
    emit(ForgotPasswordInitial());
  }
}
