import 'package:m2health/route/appointment_routes.dart';
import 'package:m2health/route/auth_routes.dart';
import 'package:m2health/route/core_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/locations/location_page.dart';
import 'package:m2health/cubit/pharmacist_profile/pharmacist_profile_page.dart';
import 'package:m2health/cubit/personal/personal_page.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/route/profile_detail_routes.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: rootNavigatorKey,
  routes: [
    ...CoreRoutes.routes, // NavBar Routes
    ...AuthRoutes.routes,
    ...AppointmentRoutes.routes,
    ...ProfileDetailRoutes.routes,

    GoRoute(
      path: '/locations',
      builder: (context, state) => LocationPage(),
    ),

    GoRoute(
      path: AppRoutes.pharma_profile,
      builder: (context, state) {
        return PharmacistProfilePage();
      },
    ),
    GoRoute(
      path: AppRoutes.personal,
      builder: (context, state) {
        return const PersonalPage(
          title: 'Personal Page',
          serviceType: 'Default Service',
        );
      },
    ),
  ],
  // errorPageBuilder: (context, state) {
  //   return MaterialPage(child: HomePage());
  // },
);
