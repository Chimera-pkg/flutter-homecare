import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ENUMS & MODELS ---

enum NutritionPlanStatus { initial, loading, success, failure }

class DietaryPlan extends Equatable {
  final String goal;
  final String strategy;
  final int dailyCaloryTarget;
  final List<String> recommendedFoods;
  final List<String> foodsToLimit;

  const DietaryPlan({
    required this.goal,
    required this.strategy,
    required this.dailyCaloryTarget,
    required this.recommendedFoods,
    required this.foodsToLimit,
  });

  @override
  List<Object?> get props =>
      [goal, strategy, dailyCaloryTarget, recommendedFoods, foodsToLimit];
}

class Supplement extends Equatable {
  final String name;
  final String dosage;

  const Supplement({required this.name, required this.dosage});

  @override
  List<Object?> get props => [name, dosage];
}

class LifestyleAdjustment extends Equatable {
  final String title;
  final String description;

  const LifestyleAdjustment({required this.title, required this.description});

  @override
  List<Object?> get props => [title, description];
}

class FoodItem extends Equatable {
  final String name;
  final String imageUrl;
  final int calories;
  final int grams;
  final int protein;
  final int carbs;
  final int fat;

  const FoodItem({
    required this.name,
    required this.imageUrl,
    required this.calories,
    required this.grams,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  List<Object?> get props =>
      [name, imageUrl, calories, grams, protein, carbs, fat];
}

class DailyMealPlan extends Equatable {
  final List<FoodItem> breakfast;
  final List<FoodItem> lunch;
  final List<FoodItem> dinner;

  const DailyMealPlan({
    this.breakfast = const [],
    this.lunch = const [],
    this.dinner = const [],
  });

  @override
  List<Object?> get props => [breakfast, lunch, dinner];
}

// --- STATE ---

class NutritionPlanState extends Equatable {
  final NutritionPlanStatus status;
  final DietaryPlan? dietaryPlan;
  final List<Supplement> supplements;
  final List<LifestyleAdjustment> lifestyleAdjustments;
  final Map<String, DailyMealPlan> weeklyMealPlan;
  final String? errorMessage;

  const NutritionPlanState({
    this.status = NutritionPlanStatus.initial,
    this.dietaryPlan,
    this.supplements = const [],
    this.lifestyleAdjustments = const [],
    this.weeklyMealPlan = const {},
    this.errorMessage,
  });

  NutritionPlanState copyWith({
    NutritionPlanStatus? status,
    DietaryPlan? dietaryPlan,
    List<Supplement>? supplements,
    List<LifestyleAdjustment>? lifestyleAdjustments,
    Map<String, DailyMealPlan>? weeklyMealPlan,
    String? errorMessage,
  }) {
    return NutritionPlanState(
      status: status ?? this.status,
      dietaryPlan: dietaryPlan ?? this.dietaryPlan,
      supplements: supplements ?? this.supplements,
      lifestyleAdjustments: lifestyleAdjustments ?? this.lifestyleAdjustments,
      weeklyMealPlan: weeklyMealPlan ?? this.weeklyMealPlan,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        dietaryPlan,
        supplements,
        lifestyleAdjustments,
        weeklyMealPlan,
        errorMessage
      ];
}

// --- CUBIT ---

class NutritionPlanCubit extends Cubit<NutritionPlanState> {
  NutritionPlanCubit() : super(const NutritionPlanState());

  Future<void> loadNutritionPlan() async {
    emit(state.copyWith(status: NutritionPlanStatus.loading));
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Dummy Data
      const dietaryPlan = DietaryPlan(
        goal: 'Weight loss',
        strategy: 'Low-carb, high-protein',
        dailyCaloryTarget: 1800,
        recommendedFoods: [
          'Chicken breast, eggs, salmon',
          'Leafy greens, broccoli',
          'Chia seeds, almonds',
          'Greek yogurt (unsweetened)',
        ],
        foodsToLimit: [
          'White bread, rice, pasta',
          'Sweetened beverages',
          'Fried foods',
        ],
      );

      const supplements = [
        Supplement(name: 'Probiotics Complex', dosage: '1 daily with meal'),
        Supplement(
            name: 'Omega-3 (Fish Oi l)', dosage: '2 capsules after breakfast'),
        Supplement(name: 'Vitamin D', dosage: 'once weekly'),
      ];

      const lifestyleAdjustments = [
        LifestyleAdjustment(
            title: 'Target: 7-8 hrs/night',
            description: 'No screens 30 mins before bed'),
        LifestyleAdjustment(
            title: 'Daily Breathing Practice',
            description: 'Use calm/headspace app'),
        LifestyleAdjustment(
            title: 'Brisk Walking 4x/week', description: '30 mins'),
      ];

      final weeklyMealPlan = {
        'Monday': const DailyMealPlan(
          breakfast: [
            FoodItem(
                name: 'Tuna Salad',
                imageUrl: 'https://i.imgur.com/ZrEnTyG.png',
                calories: 294,
                grams: 100,
                protein: 25,
                carbs: 32,
                fat: 17),
            FoodItem(
                name: 'Oatmeal',
                imageUrl: 'https://i.imgur.com/NXCm0pc.png',
                calories: 157,
                grams: 100,
                protein: 15,
                carbs: 22,
                fat: 7),
            FoodItem(
                name: 'Pancakes',
                imageUrl: 'https://i.imgur.com/3m7THGu.png',
                calories: 317,
                grams: 100,
                protein: 20,
                carbs: 47,
                fat: 5),
          ],
          lunch: [
            FoodItem(
                name: 'Grilled Chicken Salad',
                imageUrl:
                    'https://hips.hearstapps.com/hmg-prod/images/grilled-chicken-salad-lead-6628169550105.jpg?resize=1800:*',
                calories: 350,
                grams: 150,
                protein: 40,
                carbs: 10,
                fat: 18),
          ],
          dinner: [
            FoodItem(
                name: 'Baked Salmon',
                imageUrl:
                    'https://food.fnr.sndimg.com/content/dam/images/food/fullset/2019/12/20/0/FNK_Baked-Salmon_H_s4x3.jpg.rend.hgtvcom.1280.1280.suffix/1576855635102.webp',
                calories: 412,
                grams: 180,
                protein: 45,
                carbs: 5,
                fat: 24),
          ],
        ),
        'Tuesday': const DailyMealPlan(
          breakfast: [
            FoodItem(
                name: 'Oatmeal',
                imageUrl:
                    'https://food.fnr.sndimg.com/content/dam/images/food/fullset/2019/12/20/0/FNK_Baked-Salmon_H_s4x3.jpg.rend.hgtvcom.1280.1280.suffix/1576855635102.webp',
                calories: 157,
                grams: 100,
                protein: 15,
                carbs: 22,
                fat: 7),
          ],
        ),
        'Wednesday': const DailyMealPlan(),
        'Thursday': const DailyMealPlan(),
        'Friday': const DailyMealPlan(),
        'Saturday': const DailyMealPlan(),
        'Sunday': const DailyMealPlan(),
      };

      emit(state.copyWith(
        status: NutritionPlanStatus.success,
        dietaryPlan: dietaryPlan,
        supplements: supplements,
        lifestyleAdjustments: lifestyleAdjustments,
        weeklyMealPlan: weeklyMealPlan,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: NutritionPlanStatus.failure,
          errorMessage: 'Failed to load nutrition plan.'));
    }
  }
}
