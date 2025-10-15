import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/precision/screens/assessment/forms/main_concern_screen.dart';
import 'package:m2health/cubit/precision/screens/assessment/nutrition_assessment_detail_screen.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

class PrecisionNutritionRoutes {
  static List<GoRoute> routes = [
    GoRoute(
        path: 'assessment/form',
        name: AppRoutes.precisionNutritionAssessmentForm,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const MainConcernScreen();
        }),
    GoRoute(
        path: 'assessment/detail',
        name: AppRoutes.precisionNutritionAssessmentDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const NutritionAssessmentDetailScreen();
        }),
  ];
}
