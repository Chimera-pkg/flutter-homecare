import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/precision/screens/main_concern_screen.dart';
import 'package:m2health/cubit/precision/screens/nutrition_assessment_detail_screen.dart';
import 'package:m2health/route/app_routes.dart';

class PrecisionNutritionRoutes {
  static List<GoRoute> routes = [
    GoRoute(
        path: AppRoutes.precisionNutritionAssessmentForm,
        builder: (context, state) {
          return const MainConcernScreen();
        }),
    GoRoute(
        path: AppRoutes.precisionNutritionAssessmentDetail,
        builder: (context, state) {
          return const NutritionAssessmentDetailScreen();
        }),
  ];
}
