import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/nursing/pages/nursing_services.dart';
import 'package:m2health/views/pharmacist_services.dart';
import '../cubit/precision/precision_page.dart';
import '../views/diabetic_care.dart';
import '../views/home_health_screening.dart';
import '../views/remote_patient_monitoring.dart';
import '../views/second_opinion.dart';
import 'app_routes.dart';

class DashboardRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.pharmaServices,
      builder: (context, state) {
        return PharmaServices();
      },
    ),
    GoRoute(
      path: AppRoutes.nursingServices,
      builder: (context, state) {
        return NursingService(); // From nursing module
      },
    ),
    GoRoute(
      path: AppRoutes.diabeticCare,
      builder: (context, state) {
        return DiabeticCare();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      builder: (context, state) {
        return HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.homeHealthScreening,
      builder: (context, state) {
        return HomeHealth();
      },
    ),
    GoRoute(
      path: AppRoutes.remotePatientMonitoring,
      builder: (context, state) {
        return RemotePatientMonitoring();
      },
    ),
    GoRoute(
      path: AppRoutes.secondOpinionMedical,
      builder: (context, state) {
        return OpinionMedical();
      },
    ),
    GoRoute(
      path: AppRoutes.precisionNutrition,
      builder: (context, state) {
        return const PrecisionNutritionPage();
      },
    ),
  ];
}
