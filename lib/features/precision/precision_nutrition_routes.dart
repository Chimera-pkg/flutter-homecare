import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/precision/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/precision/screens/assessment/forms/main_concern_screen.dart';
import 'package:m2health/features/precision/screens/assessment/nutrition_assessment_detail_screen.dart';
import 'package:m2health/features/precision/screens/implementation/implementation_journey_page.dart';
import 'package:m2health/features/precision/screens/plan/nutrition_plan_page.dart';
import 'package:m2health/features/precision/screens/plan/weekly_meal_plan_detail_page.dart';
import 'package:m2health/features/precision/screens/plan/weekly_meal_plan_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';

final GlobalKey<NavigatorState> _nutritionPlanKey = GlobalKey<NavigatorState>();

class PrecisionNutritionRoutes {
  static List<RouteBase> routes = [
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
    ShellRoute(
        parentNavigatorKey: rootNavigatorKey,
        navigatorKey: _nutritionPlanKey,
        builder: (context, state, child) {
          return BlocProvider(
            // Providing NutritionPlanCubit to the subtree
            create: (context) => NutritionPlanCubit()..loadNutritionPlan(),
            child: child,
          );
        },
        routes: [
          GoRoute(
              path: 'plan',
              name: AppRoutes.precisionNutritionPlan,
              builder: (context, state) {
                return const NutritionPlanPage();
              }),
          GoRoute(
              path: 'plan/weekly',
              name: AppRoutes.weeklyMealPlan,
              builder: (context, state) {
                return const WeeklyMealPlanPage();
              }),
          GoRoute(
              path: 'plan/weekly/detail',
              name: AppRoutes.weeklyMealPlanDetail,
              builder: (context, state) {
                final day = state.uri.queryParameters['day'] ?? 'Monday';
                return WeeklyMealPlanDetailPage(day: day);
              }),
        ]),
    GoRoute(
        path: 'implementation-journey',
        name: AppRoutes.implementationJourney,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return const ImplementationJourneyPage();
        }),
  ];
}
