import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/diabetes/diabetic_care_routes.dart';
import 'package:m2health/cubit/nursing/pages/nursing_services.dart';
import 'package:m2health/cubit/precision/precision_nutrition_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/views/pharmacist_services.dart';
import '../cubit/precision/precision_page.dart';
import '../cubit/diabetes/diabetic_care.dart';
import '../views/home_health_screening.dart';
import '../views/remote_patient_monitoring.dart';
import '../views/second_opinion.dart';
import 'app_routes.dart';

class DashboardRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.pharmaServices,
      builder: (context, state) {
        return PharmaServices();
      },
    ),
    GoRoute(
      path: AppRoutes.nursingServices,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return NursingService(); // From nursing module
      },
    ),
    GoRoute(
      path: AppRoutes.diabeticCare,
      parentNavigatorKey: rootNavigatorKey,
      routes: DiabeticCareRoutes.routes,
      builder: (context, state) {
        return const DiabeticCare();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.remotePatientMonitoring,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return RemotePatientMonitoring();
      },
    ),
    GoRoute(
      path: AppRoutes.secondOpinionMedical,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return OpinionMedical();
      },
    ),
    GoRoute(
      path: AppRoutes.precisionNutrition,
      parentNavigatorKey: rootNavigatorKey,
      routes: PrecisionNutritionRoutes.routes,
      builder: (context, state) {
        return const PrecisionNutritionPage();
      },
    ),
  ];
}
