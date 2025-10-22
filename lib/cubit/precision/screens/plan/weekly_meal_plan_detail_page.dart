import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/precision/bloc/nutrition_plan_cubit.dart';
import 'package:m2health/cubit/precision/widgets/precision_widgets.dart';

class WeeklyMealPlanDetailPage extends StatefulWidget {
  final String day;
  const WeeklyMealPlanDetailPage({super.key, required this.day});

  @override
  State<WeeklyMealPlanDetailPage> createState() =>
      _WeeklyMealPlanDetailPageState();
}

class _WeeklyMealPlanDetailPageState extends State<WeeklyMealPlanDetailPage> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Breakfast', 'Lunch', 'Dinner'];

  @override
  Widget build(BuildContext context) {
    final dailyPlan =
        context.read<NutritionPlanCubit>().state.weeklyMealPlan[widget.day];

    if (dailyPlan == null) {
      return const Scaffold(
          body: Center(child: Text('No plan found for this day.')));
    }

    final List<List<FoodItem>> mealLists = [
      dailyPlan.breakfast,
      dailyPlan.lunch,
      dailyPlan.dinner
    ];

    return Scaffold(
      appBar: CustomAppBar(title: '${widget.day} Meal Plan'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: _MealTypeSelector(
              selectedIndex: _selectedTabIndex,
              tabs: _tabs,
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            ),
          ),
          Expanded(
            child: _MealListView(
              key: ValueKey(
                  _selectedTabIndex), // Ensure list rebuilds on tab change
              foods: mealLists[_selectedTabIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealTypeSelector extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final ValueChanged<int> onTabSelected;

  const _MealTypeSelector(
      {required this.selectedIndex,
      required this.tabs,
      required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Const.aqua.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Const.aqua : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MealListView extends StatelessWidget {
  final List<FoodItem> foods;
  const _MealListView({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const Center(child: Text("No meals planned for this time."));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return _FoodItemCard(food: food);
      },
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem food;
  const _FoodItemCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Const.aqua.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  food.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 60),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${food.calories} kcal • ${food.grams} G',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NutrientInfoWithBar(
                value: food.protein,
                maxValue:
                    45, // Reference amount of very high protein in single meal
                label: 'Protein',
                color: Colors.teal.shade300,
              ),
              _NutrientInfoWithBar(
                value: food.carbs,
                maxValue:
                    75, // Reference amount of very high carbs in single meal
                label: 'Carbs',
                color: Colors.orange.shade300,
              ),
              _NutrientInfoWithBar(
                value: food.fat,
                maxValue:
                    50, // Reference amount of very high fat in single meal
                label: 'Fat',
                color: Colors.purple.shade300,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _NutrientInfoWithBar extends StatelessWidget {
  final String label;
  final Color color;
  final int value;
  final int maxValue;

  const _NutrientInfoWithBar({
    required this.label,
    required this.color,
    required this.value,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercentage = (value / maxValue).clamp(0.0, 1.0);
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 6,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Background track
                Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Filled bar
                FractionallySizedBox(
                  heightFactor: fillPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value g',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
