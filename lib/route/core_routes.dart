import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/appointment/appointment_module.dart';
import 'package:m2health/main.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/views/dashboard.dart';
import 'package:m2health/views/favourites.dart';
import 'package:m2health/views/medical_store.dart';
import 'package:m2health/cubit/profiles/presentation/profile_page.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

class CoreRoutes {
  static List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => Dashboard(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.appointment,
              builder: (context, state) => AppointmentPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.medicalStore,
              builder: (context, state) => MedicalStorePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favourite,
              builder: (context, state) => FavouritesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ];
}