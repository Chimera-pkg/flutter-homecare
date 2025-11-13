import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
}

class SignUpCubit extends Cubit<SignUpState> {
  final Dio _dio;
  // late final SSOService _ssoService;

  SignUpCubit()
      : _dio = Dio(),
        super(SignUpInitial()) {
    _dio.interceptors.add(const OmegaDioLogger());
    // _ssoService = SSOService(_dio);
  }

  Future<void> signUp(
    String email,
    String password,
    String username,
    String role,
  ) async {
    print('=== SIGN UP REQUEST ===');
    print('Email: $email');
    print('Username: $username');
    print('Role: $role');

    if (email.isEmpty ||
        !EmailValidator.validate(email) ||
        password.isEmpty ||
        username.isEmpty ||
        role.isEmpty) {
      emit(SignUpFailure('Please fill in all fields correctly.'));
      return;
    }
    emit(SignUpLoading());

    // Build the appropriate URL based on the selected role
    String mUrl;
    switch (role.toLowerCase()) {
      case 'pharmacist':
        mUrl = '${Const.API_REGISTER}/pharmacist';
        break;
      case 'radiologist':
        mUrl = '${Const.API_REGISTER}/radiologist';
        break;
      case 'patient':
        mUrl = '${Const.API_REGISTER}/patient';
        break;
      case 'nurse':
        mUrl = '${Const.API_REGISTER}/nurse';
        break;
      default:
        emit(SignUpFailure(
            'Invalid role selected. Please choose a valid role.'));
        return;
    }

    print('Registration URL: $mUrl');

    try {
      var response = await _dio.post(
        mUrl,
        data: {"email": email, "password": password, "username": username},
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      print('=== SIGN UP RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _sendVerificationEmail(email); // Not awaited, fire-and-forget
        emit(SignUpSuccess());
      } else if (response.statusCode == 422) {
        // Validation errors
        String errorMessage = 'Registration failed';
        if (response.data != null) {
          if (response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else if (response.data['errors'] != null) {
            var errors = response.data['errors'];
            if (errors is List && errors.isNotEmpty) {
              errorMessage = errors[0]['message'] ?? errorMessage;
            } else if (errors is Map) {
              // Handle field-specific errors
              List<String> errorMessages = [];
              errors.forEach((field, messages) {
                if (messages is List) {
                  errorMessages.addAll(messages.cast<String>());
                }
              });
              if (errorMessages.isNotEmpty) {
                errorMessage = errorMessages.join(', ');
              }
            }
          }
        }
        emit(SignUpFailure(errorMessage));
      } else {
        String errorMessage = 'Registration failed';
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        emit(SignUpFailure(errorMessage));
      }
    } catch (e) {
      print('=== SIGN UP ERROR ===');
      print('Error: $e');
      emit(SignUpFailure(
          'Network error. Please check your connection and try again.'));
    }
  }

  Future<void> _sendVerificationEmail(String email) async {
    try {
      print('=== SENDING VERIFICATION EMAIL ===');
      await _dio.post(
        '${Const.API_REGISTER}/send-email-verification',
        data: {"email": email},
      );
      print('Verification email request sent successfully.');
    } catch (e) {
      print('=== FAILED TO SEND VERIFICATION EMAIL ===');
      print('Error: $e');
    }
  }

  Future<void> getUser(String token, String role) async {
    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());

    dio.options.headers["Authorization"] = "Bearer ${token}";
    try {
      var response = await dio.get(Const.URL_API + "/$role/profile",
          options: Options(validateStatus: (status) {
        return true;
      }));

      if (response.statusCode != 200) {
        emit(SignUpFailure(response.data['message']));
        return;
      }

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }

  // // Google Sign-In method
  // Future<void> signUpWithGoogle(String role) async {
  //   print('=== GOOGLE SIGN UP ===');
  //   print('Role: $role');

  //   if (role.isEmpty) {
  //     emit(
  //         SignUpFailure('Please select a role before signing up with Google.'));
  //     return;
  //   }

  //   emit(SignUpLoading());

  //   try {
  //     final result = await _ssoService.signInWithGoogle(role);

  //     if (result['success'] == true) {
  //       print('Google Sign-Up successful');
  //       emit(SignUpSuccess());
  //     } else {
  //       emit(SignUpFailure(result['message'] ?? 'Google Sign-In failed'));
  //     }
  //   } catch (e) {
  //     print('Google Sign-In Error: $e');
  //     emit(SignUpFailure('Google Sign-In failed. Please try again.'));
  //   }
  // }

  // // WeChat Sign-In method
  // Future<void> signUpWithWeChat(String role) async {
  //   print('=== WECHAT SIGN UP ===');
  //   print('Role: $role');

  //   if (role.isEmpty) {
  //     emit(
  //         SignUpFailure('Please select a role before signing up with WeChat.'));
  //     return;
  //   }
  //   emit(SignUpLoading());

  //   try {
  //     final result = await _ssoService.signInWithWeChat(role);

  //     if (result['success'] == true) {
  //       print('WeChat Sign-Up successful');
  //       emit(SignUpSuccess());
  //     } else {
  //       emit(SignUpFailure(result['message'] ?? 'WeChat Sign-In failed'));
  //     }
  //   } catch (e) {
  //     print('WeChat Sign-In Error: $e');
  //     emit(SignUpFailure('WeChat Sign-In failed. Please try again.'));
  //   }
  // }

  // // Facebook Sign-In method (keeping existing icon functionality)
  // Future<void> signUpWithFacebook(String role) async {
  //   print('=== FACEBOOK SIGN UP ===');
  //   print('Role: $role');

  //   if (role.isEmpty) {
  //     emit(SignUpFailure(
  //         'Please select a role before signing up with Facebook.'));
  //     return;
  //   }

  //   emit(SignUpLoading());

  //   try {
  //     final result = await _ssoService.signInWithFacebook(role);

  //     if (result['success'] == true) {
  //       print('Facebook Sign-Up successful');
  //       emit(SignUpSuccess());
  //     } else {
  //       emit(SignUpFailure(result['message'] ?? 'Facebook Sign-In failed'));
  //     }
  //   } catch (e) {
  //     print('Facebook Sign-In Error: $e');
  //     emit(SignUpFailure('Facebook Sign-In failed. Please try again.'));
  //   }
  // }
}
