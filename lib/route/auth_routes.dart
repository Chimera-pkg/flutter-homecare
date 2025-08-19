import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/signin/sign_in_page.dart';
import 'package:m2health/cubit/signup/sign_up_page.dart';
import 'package:m2health/route/app_routes.dart';

class AuthRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => SignUpPage(),
    ),

    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        return SignInPage();
      },
    ),
  ];
}