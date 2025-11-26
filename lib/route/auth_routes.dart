import 'package:go_router/go_router.dart';
import 'package:m2health/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:m2health/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:m2health/features/auth/presentation/pages/reset_password_page.dart';
import 'package:m2health/features/auth/presentation/pages/reset_password_success_page.dart';
import 'package:m2health/features/auth/presentation/pages/sign_in_page.dart';
import 'package:m2health/features/auth/presentation/pages/sign_up_page.dart';
import 'package:m2health/route/app_routes.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        return const SignInPage();
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      builder: (context, state) {
        final email = state.extra as String;
        return OtpVerificationPage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return ResetPasswordPage(
          resetToken: extras['resetToken'] as String,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.resetPasswordSuccess,
      builder: (context, state) => const ResetPasswordSuccessPage(),
    ),
  ];
}
