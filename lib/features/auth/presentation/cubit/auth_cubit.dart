import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/utils.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  AuthState._({this.status = AuthStatus.unknown});

  AuthState.unknown() : this._();
  AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unknown()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final isLoggedIn = await Utils.isUserLoggedIn();
    if (isLoggedIn) {
      emit(AuthState.authenticated());
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  // Call this from SignInPage after successful login
  void loggedIn() {
    emit(AuthState.authenticated());
  }

  // Call this when logging out
  Future<void> loggedOut() async {
    await Utils.clearSp(); // Helper to clear session data
    emit(AuthState.unauthenticated());
  }
}