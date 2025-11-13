import 'package:go_router/go_router.dart';
import 'package:m2health/features/diabetes/pages/diabetes_form_page.dart';
import 'package:m2health/features/diabetes/pages/diabetes_form_summary_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

class DiabeticCareRoutes {
  static List<GoRoute> routes = [
    GoRoute(
        path: 'profile/form',
        name: AppRoutes.diabeticProfileForm,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const DiabetesFormPage();
        }),
    GoRoute(
        path: 'profile/summary',
        name: AppRoutes.diabeticProfileSummary,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const DiabetesFormSummaryPage();
        }),
  ];
}