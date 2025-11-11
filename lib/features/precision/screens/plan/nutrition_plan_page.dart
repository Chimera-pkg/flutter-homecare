import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/precision/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/features/precision/screens/plan/weekly_meal_plan_page.dart';
import 'package:m2health/features/precision/widgets/precision_widgets.dart';
import 'package:m2health/route/app_routes.dart';

class NutritionPlanPage extends StatelessWidget {
  const NutritionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Precision Nutrition Plan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => GoRouter.of(context).pop(),
          ),
          bottom: const TabBar(
            indicatorColor: Const.aqua,
            labelColor: Const.aqua,
            labelStyle: TextStyle(fontSize: 16),
            tabs: [
              Tab(text: 'Dietary Plan'),
              Tab(text: 'Supplements'),
              Tab(text: 'Lifestyle'),
            ],
          ),
        ),
        body: BlocBuilder<NutritionPlanCubit, NutritionPlanState>(
          builder: (context, state) {
            if (state.status == NutritionPlanStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == NutritionPlanStatus.failure) {
              return Center(
                  child: Text(state.errorMessage ?? 'An error occurred'));
            }
            if (state.status == NutritionPlanStatus.success) {
              return const TabBarView(
                children: [
                  _DietaryPlanView(),
                  _SupplementsView(),
                  _LifestyleView(),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryButton(
            text: 'Request Plan Update',
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

class _DietaryPlanView extends StatelessWidget {
  const _DietaryPlanView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NutritionPlanCubit>().state;
    final plan = state.dietaryPlan;

    if (plan == null) return const SizedBox.shrink();

    const purple = Color(0xFF5782F1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: purple),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GOAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: purple,
                        ),
                      ),
                      Text(plan.goal),
                      const SizedBox(height: 8),
                      const Text('STRATEGY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          )),
                      Text(plan.strategy),
                      const SizedBox(height: 8),
                      const Text('DAILY CALORY TARGET',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: purple,
                          )),
                      Text('${plan.dailyCaloryTarget} kcal'),
                    ],
                  ),
                ),
                // Replace with your actual illustration
                Image.asset('assets/images/ilu_nutrition_diet.png',
                    width: 160, height: 160),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Recommended Foods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...plan.recommendedFoods
              .map((food) => _InfoCard(text: food, isRecommended: true)),
          const SizedBox(height: 24),
          const Text('Foods to Limit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...plan.foodsToLimit
              .map((food) => _InfoCard(text: food, isRecommended: false)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Meal Plan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRoutes.weeklyMealPlan);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Const.aqua,
                    textStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('View All')),
            ],
          ),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: state.weeklyMealPlan.keys
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final day = entry.value;
                return _DayCard(day: day, index: index);
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class _SupplementsView extends StatelessWidget {
  const _SupplementsView();

  @override
  Widget build(BuildContext context) {
    final supplements = context.watch<NutritionPlanCubit>().state.supplements;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: supplements.length,
      itemBuilder: (context, index) {
        final supplement = supplements[index];
        return _InfoCard(
          text: supplement.name,
          subtext: supplement.dosage,
          isRecommended: true,
        );
      },
    );
  }
}

class _LifestyleView extends StatelessWidget {
  const _LifestyleView();

  @override
  Widget build(BuildContext context) {
    final adjustments =
        context.watch<NutritionPlanCubit>().state.lifestyleAdjustments;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: adjustments.length,
      itemBuilder: (context, index) {
        final adjustment = adjustments[index];
        return _InfoCard(
          text: adjustment.title,
          subtext: adjustment.description,
          isRecommended: true,
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final String? subtext;
  final bool isRecommended;

  const _InfoCard(
      {required this.text, this.subtext, required this.isRecommended});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
                if (subtext != null) ...[
                  const SizedBox(height: 2),
                  Text(subtext!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color:
                  isRecommended ? Colors.green.shade200 : Colors.red.shade200,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final String day;
  final int index;
  const _DayCard({required this.day, required this.index});

  @override
  Widget build(BuildContext context) {
    final imagePath = weeklyFoodImagePaths[index];
    return GestureDetector(
      onTap: () => GoRouter.of(context).pushNamed(
        AppRoutes.weeklyMealPlanDetail,
        queryParameters: {'day': day},
      ),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.4), BlendMode.darken))),
        child: Center(
          child: Text(
            day.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
