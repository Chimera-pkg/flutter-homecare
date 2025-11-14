import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class TokenExpirationInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if the error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please log in again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      sl<AuthCubit>().loggedOut();
    }

    // Continue with the error so the specific Cubit can also handle it (e.g., stop loading spinners)
    super.onError(err, handler);
  }
}
