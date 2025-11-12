import 'package:m2health/route/auth_routes.dart';
import 'package:m2health/route/core_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/locations/location_page.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/features/profiles/profile_detail_routes.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: rootNavigatorKey,
  routes: [
    ...CoreRoutes.routes, // NavBar Routes
    ...AuthRoutes.routes,
    ...ProfileDetailRoutes.routes,

    GoRoute(
      path: '/locations',
      builder: (context, state) => LocationPage(),
    ),
  ],
  // errorPageBuilder: (context, state) {
  //   return MaterialPage(child: HomePage());
  // },
);
