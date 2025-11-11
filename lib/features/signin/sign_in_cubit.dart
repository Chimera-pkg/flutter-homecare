import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/utils.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final RegExp emailRegex =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$');

  Future<void> signIn(String email, String pass) async {
    if (email.isEmpty || !emailRegex.hasMatch(email) || pass.isEmpty) {
      emit(SignInError('Please fill in both Email and Password correctly.'));
      return;
    }

    emit(SignInLoading());

    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    try {
      var response = await dio
          .post(Const.API_LOGIN, data: {"email": email, "password": pass},
              options: Options(validateStatus: (status) {
        return true;
      }));

      if (response.statusCode != 200) {
        emit(SignInError(response.data['message']));
        return;
      }

      Utils.setSpBool(Const.IS_LOGED_IN, true);
      Utils.setSpString(Const.TOKEN, response.data['token']['token']);
      Utils.setSpString(Const.EXPIRES_AT, response.data['token']['expiresAt']);
      Utils.setSpString(Const.USERNAME, response.data['user']['username']);
      Utils.setSpString(Const.ROLE, response.data['user']['role']);
      Utils.setSpString(Const.USER_ID, response.data['user']['id'].toString());

      // Simpan nama pengguna ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', response.data['user']['username']);
      debugPrint('Username saved: ${response.data['user']['username']}');

      if (response.data['user']['role'] == 'admin') {
        emit(SignInSuccess());
      } else {
        getUser(response.data['token']['token'], response.data['user']['role']);
      }
    } catch (e, stackStrace) {
      log('Failed to sign in',
          error: e, stackTrace: stackStrace, name: 'SignInCubit');
      emit(SignInError(e.toString()));
    }
  }

  Future<void> getUser(String token, String role) async {
    var dio = Dio();
    dio.interceptors.add(const OmegaDioLogger());
    dio.options.headers["Authorization"] = "Bearer ${token}";
    try {
      var response = await dio.get(Const.URL_API + "/profiles",
          options: Options(validateStatus: (status) {
        return true;
      }));

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode != 200) {
        final errorMessage =
            response.data['message'] ?? 'Failed to get user profile';
        emit(SignInError(errorMessage));
        return;
      }

      // Check if response has the expected structure
      if (response.data == null) {
        emit(SignInError('No response data received'));
        return;
      }

      final responseData = response.data;
      if (responseData['data'] == null) {
        emit(SignInError('Profile data not found in response'));
        return;
      }

      final profileData = responseData['data'];
      if (profileData['id'] == null) {
        emit(SignInError('Profile ID not found'));
        return;
      }

      // Successfully got profile data
      print('Profile retrieved successfully:');
      print('Profile ID: ${profileData['id']}');
      print('User ID: ${profileData['user_id']}');
      print('Username: ${profileData['username']}');
      print('Email: ${profileData['email']}');

      // Optional: Save additional profile information
      await Utils.setSpString('profile_id', profileData['id'].toString());
      if (profileData['username'] != null) {
        await Utils.setSpString('profile_username', profileData['username']);
      }

      emit(SignInSuccess());
    } catch (e) {
      print('Exception in getUser: $e');
      emit(SignInError('Failed to get user profile: ${e.toString()}'));
    }
  }
}
