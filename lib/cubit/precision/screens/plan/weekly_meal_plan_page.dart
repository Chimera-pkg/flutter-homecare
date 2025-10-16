import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/precision/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';
import 'package:m2health/route/app_routes.dart';

const weeklyFoodImagePaths = [
  'assets/images/food_chicken_breast.jpg',
  'assets/images/food_salmon.png',
  'assets/images/food_steak.png',
  'assets/images/food_oatmeal.png',
  'assets/images/food_vegetables.png',
  'assets/images/food_bread.png',
  'assets/images/food_beans.png',
];

class WeeklyMealPlanPage extends StatelessWidget {
  const WeeklyMealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final weeklyPlan = context.read<NutritionPlanCubit>().state.weeklyMealPlan;
    final days = weeklyPlan.keys.toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Weekly Meal Plan'),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final imagePath = weeklyFoodImagePaths[index];
          const description = 'Breakfast • Lunch • Dinner';

          return GestureDetector(
            onTap: () => GoRouter.of(context).pushNamed(
              AppRoutes.weeklyMealPlanDetail,
              queryParameters: {'day': day},
            ),
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
