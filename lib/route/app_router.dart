import 'package:flutter/material.dart';
import 'package:m2health/cubit/precision/precision_nutrition_routes.dart';
import 'package:m2health/route/appointment_routes.dart';
import 'package:m2health/route/auth_routes.dart';
import 'package:m2health/route/core_routes.dart';
import 'package:m2health/route/dashboard_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/locations/location_page.dart';
import 'package:m2health/cubit/pharmacist_profile/pharmacist_profile_page.dart';
import 'package:m2health/cubit/personal/personal_page.dart';
import 'package:m2health/route/profile_detail_routes.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  navigatorKey: _rootNavigatorKey,
  routes: [
    ...CoreRoutes.routes, // NavBar Routes
    ...AuthRoutes.routes,
    ...DashboardRoutes.routes,
    ...AppointmentRoutes.routes,
    ...ProfileDetailRoutes.routes,
    ...PrecisionNutritionRoutes.routes,

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
