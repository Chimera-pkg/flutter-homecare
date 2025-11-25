import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/auth/data/datasources/google_auth_source.dart';
import 'package:m2health/utils.dart';

enum AuthResultStatus { success, requiresRole, failure, cancelled }

class AuthResult {
  final AuthResultStatus status;
  final String? message;
  final dynamic data;
  final String? idToken;

  AuthResult({
    required this.status,
    this.message,
    this.data,
    this.idToken,
  });
}

class AuthRepository {
  final Dio dio;
  final GoogleAuthSource googleAuthSource;

  AuthRepository({required this.dio, required this.googleAuthSource});

  // =========================================================
  //  GOOGLE AUTH FLOW
  // =========================================================
  Future<AuthResult> authenticateWithGoogle(
      {String? role, String? idToken}) async {
    try {
      // 1. Get token if not provided
      final String? currentIdToken =
          idToken ?? await googleAuthSource.getGoogleIdToken();
      if (currentIdToken == null) {
        return AuthResult(
            status: AuthResultStatus.cancelled, message: "Cancelled");
      }

      // 2. Prepare payload
      final Map<String, dynamic> payload = {'idToken': currentIdToken};
      if (role != null) payload['role'] = role.toLowerCase();

      // 3. Make API call
      final response = await dio.post(
        '${Const.URL_API}/auth/google', // Corrected URL
        data: payload,
        options: Options(validateStatus: (status) => status! < 500),
      );

      // 4. Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveSession(response.data);
        return AuthResult(
            status: AuthResultStatus.success, data: response.data);
      }

      // Not registered yet, requires role selection
      if (response.statusCode == 400 &&
          response.data['requiresRegistration'] == true) {
        return AuthResult(
          status: AuthResultStatus.requiresRole,
          idToken: currentIdToken, // Pass back the token
        );
      }

      return AuthResult(
          status: AuthResultStatus.failure,
          message: response.data['message'] ?? 'Google authentication failed');
    } catch (e) {
      await googleAuthSource.signOut();
      return AuthResult(
          status: AuthResultStatus.failure, message: e.toString());
    }
  }

  // =======================
  //  TRADITIONAL AUTH FLOW
  // =======================

  Future<AuthResult> login(String email, String password) async {
    try {
      final payload = {
        "email": email,
        "password": password,
      };
      final response = await dio.post(
        Const.API_LOGIN,
        data: payload,
      );

      await _saveSession(response.data);
      if (response.data['user']['role'] != 'admin') {
        await _fetchUserProfile(response.data['token']['token']);
      }
      return AuthResult(status: AuthResultStatus.success);
    } catch (e, stackTrace) {
      var errorMessage = e.toString();
      log('Login error',
          error: e, stackTrace: stackTrace, name: 'AuthRepository');
      if (e is DioException && e.response != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
        log('DioException response data: ${e.response?.data}',
            name: 'AuthRepository');
      }
      return AuthResult(
          status: AuthResultStatus.failure, message: errorMessage);
    }
  }

  Future<AuthResult> register(
      String email, String password, String username, String role) async {
    try {
      String endpoint = '${Const.API_REGISTER}/$role';
      final payload = {
        "email": email,
        "password": password,
        "username": username,
      };
      final response = await dio.post(
        endpoint,
        data: payload,
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await _sendVerificationEmail(email);
        return AuthResult(status: AuthResultStatus.success);
      }

      return AuthResult(
          status: AuthResultStatus.failure,
          message: response.data['message'] ?? 'Registration failed');
    } catch (e) {
      return AuthResult(
          status: AuthResultStatus.failure, message: e.toString());
    }
  }

  // =========================================================
  //  HELPERS
  // =========================================================
  Future<void> _saveSession(Map<String, dynamic> data) async {
    if (data['token'] != null) {
      // Handle nested token object if structure is {token: {token: "..."}}
      final tokenStr =
          data['token'] is Map ? data['token']['token'] : data['token'];
      await Utils.setSpString(Const.TOKEN, tokenStr);
    }
    if (data['user'] != null) {
      await Utils.setSpBool(Const.IS_LOGED_IN, true);
      await Utils.setSpString(Const.USERNAME, data['user']['username']);
      await Utils.setSpString(Const.ROLE, data['user']['role']);
      await Utils.setSpString(Const.USER_ID, data['user']['id'].toString());
    }
  }

  Future<void> _fetchUserProfile(String token) async {
    try {
      final response = await dio.get('${Const.URL_API}/profiles',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      if (response.statusCode == 200 && response.data['data'] != null) {
        // Save profile specific data
        await Utils.setSpString(
            'profile_id', response.data['data']['id'].toString());
      }
    } catch (_) {} // Ignore profile fetch errors for now
  }

  Future<void> _sendVerificationEmail(String email) async {
    try {
      log('=== SENDING VERIFICATION EMAIL ===', name: 'AuthRepository');
      await dio.post(
        '${Const.API_REGISTER}/send-email-verification',
        data: {"email": email},
      );
      log('Verification email request sent successfully.',
          name: 'AuthRepository');
    } catch (e) {
      log('=== FAILED TO SEND VERIFICATION EMAIL ===', name: 'AuthRepository');
      log('Error: $e', name: 'AuthRepository');
    }
  }
}
