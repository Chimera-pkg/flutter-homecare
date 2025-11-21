import 'package:go_router/go_router.dart';
import 'package:m2health/features/diabetes/diabetic_care_routes.dart';
import 'package:m2health/features/booking_appointment/nursing/presentation/pages/nursing_services_page.dart';
import 'package:m2health/features/precision/precision_nutrition_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/features/booking_appointment/pharmacy/presentation/pages/pharmacy_services_page.dart';
import '../features/precision/screens/precision_nutrition_page.dart';
import '../features/diabetes/diabetic_care.dart';
import '../features/home_health_screening/presentation/pages/home_health_screening.dart';
import '../core/presentation/views/remote_patient_monitoring.dart';
import '../core/presentation/views/second_opinion.dart';
import 'app_routes.dart';

class DashboardRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.pharmaServices,
      builder: (context, state) {
        return PharmacyServicesPage();
      },
    ),
    GoRoute(
      path: AppRoutes.nursingServices,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        return const NursingService();
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
