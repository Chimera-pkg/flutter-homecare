import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/precision_widgets.dart';
import '../precision_cubit.dart';
import 'biomarker_upload_screen.dart';

class NutritionHabitsScreen extends StatefulWidget {
  const NutritionHabitsScreen({Key? key}) : super(key: key);

  @override
  State<NutritionHabitsScreen> createState() => _NutritionHabitsScreenState();
}

class _NutritionHabitsScreenState extends State<NutritionHabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealFrequencyController = TextEditingController();
  final _foodSensitivitiesController = TextEditingController();
  final _favoriteFoodsController = TextEditingController();
  final _avoidedFoodsController = TextEditingController();
  final _waterIntakeController = TextEditingController();
  final _pastDietsController = TextEditingController();

  @override
  void dispose() {
    _mealFrequencyController.dispose();
    _foodSensitivitiesController.dispose();
    _favoriteFoodsController.dispose();
    _avoidedFoodsController.dispose();
    _waterIntakeController.dispose();
    _pastDietsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final nutritionHabits =
        context.read<PrecisionCubit>().state.nutritionHabits;
    if (nutritionHabits == null) return;
    _mealFrequencyController.text = nutritionHabits.mealFrequency;
    _foodSensitivitiesController.text = nutritionHabits.foodSensitivities;
    _favoriteFoodsController.text = nutritionHabits.favoriteFoods;
    _avoidedFoodsController.text = nutritionHabits.avoidedFoods;
    _waterIntakeController.text = nutritionHabits.waterIntake;
    _pastDietsController.text = nutritionHabits.pastDiets;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Create NutritionHabits and update cubit
      final nutritionHabits = NutritionHabits(
        mealFrequency: _mealFrequencyController.text,
        foodSensitivities: _foodSensitivitiesController.text,
        favoriteFoods: _favoriteFoodsController.text,
        avoidedFoods: _avoidedFoodsController.text,
        waterIntake: _waterIntakeController.text,
        pastDiets: _pastDietsController.text,
      );

      context.read<PrecisionCubit>().updateNutritionHabits(nutritionHabits);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BiomarkerUploadScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Nutrition Habits'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Frequency Section
                      CustomTextField(
                        label: 'Describe your daily meal frequency',
                        hintText: 'E.g Twice a day',
                        controller: _mealFrequencyController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your meal frequency';
                          }
                          return null;
                        },
                      ),

                      // Food Sensitivities Section
                      CustomTextField(
                        label: 'Known food sensitivities or allergies',
                        hintText: 'E.g: Seafoods such as shrimp',
                        controller: _foodSensitivitiesController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your food sensitivities';
                          }
                          return null;
                        },
                      ),

                      // Favorite Foods Section
                      CustomTextField(
                        label: 'Favorite food types',
                        hintText: 'E.g: Chicken, Healthy Soup, Meatball',
                        controller: _favoriteFoodsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your favorite foods';
                          }
                          return null;
                        },
                      ),

                      // Avoided Foods Section
                      CustomTextField(
                        label: 'Avoided food types',
                        hintText: 'E.g: Seafood',
                        controller: _avoidedFoodsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe foods you avoid';
                          }
                          return null;
                        },
                      ),

                      // Water Intake Section
                      CustomTextField(
                        label: 'Water intake',
                        hintText: 'E.g: 7 glass per day',
                        controller: _waterIntakeController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your water intake';
                          }
                          return null;
                        },
                      ),

                      // Past Diets Section
                      CustomTextField(
                        label: 'Past diets',
                        hintText: 'E.g: Keto, low-carb, plant-based, raw food',
                        controller: _pastDietsController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your past diets';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Next Button
              PrimaryButton(
                text: 'Next',
                onPressed: _onNextPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
