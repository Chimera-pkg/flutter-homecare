import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/precision_widgets.dart';
import '../precision_cubit.dart';
import 'nutrition_habits_screen.dart';

class LifestyleHabitsScreen extends StatefulWidget {
  const LifestyleHabitsScreen({Key? key}) : super(key: key);

  @override
  State<LifestyleHabitsScreen> createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends State<LifestyleHabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  double _sleepHours = 7.0;
  final _activityLevelController = TextEditingController();
  final _exerciseFrequencyController = TextEditingController();
  final _stressLevelController = TextEditingController();
  final _smokingAlcoholController = TextEditingController();

  @override
  void dispose() {
    _activityLevelController.dispose();
    _exerciseFrequencyController.dispose();
    _stressLevelController.dispose();
    _smokingAlcoholController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final lifestyleHabits =
        context.read<PrecisionCubit>().state.lifestyleHabits;
    if (lifestyleHabits == null) return;
    _sleepHours = lifestyleHabits.sleepHours;
    _activityLevelController.text = lifestyleHabits.activityLevel;
    _exerciseFrequencyController.text = lifestyleHabits.exerciseFrequency;
    _stressLevelController.text = lifestyleHabits.stressLevel;
    _smokingAlcoholController.text = lifestyleHabits.smokingAlcoholHabits;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Create LifestyleHabits and update cubit
      final lifestyleHabits = LifestyleHabits(
        sleepHours: _sleepHours,
        activityLevel: _activityLevelController.text,
        exerciseFrequency: _exerciseFrequencyController.text,
        stressLevel: _stressLevelController.text,
        smokingAlcoholHabits: _smokingAlcoholController.text,
      );

      context.read<PrecisionCubit>().updateLifestyleHabits(lifestyleHabits);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NutritionHabitsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lifestyle & Habits'),
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
                      // Sleep Hours Section
                      const Text(
                        'How many hours of sleep do you get per night?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: const Color(0xFF00B4D8),
                                inactiveTrackColor: Colors.grey.shade300,
                                thumbColor: const Color(0xFF00B4D8),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 12,
                                  elevation: 4,
                                ),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: _sleepHours,
                                min: 0.0,
                                max: 24.0,
                                divisions: 48,
                                onChanged: (value) {
                                  setState(() {
                                    _sleepHours = value;
                                  });
                                },
                              ),
                            ),
                            Text(
                              '${_sleepHours.toStringAsFixed(1)} hours per day',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF00B4D8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Activity Level Section
                      CustomTextField(
                        label: 'Describe your typical daily activity level',
                        hintText: 'E.g Working behind the desk 8 hours per day',
                        controller: _activityLevelController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your activity level';
                          }
                          return null;
                        },
                      ),

                      // Exercise Frequency Section
                      CustomTextField(
                        label: 'How often do you exercise per week?',
                        hintText: 'E.g: Around 30 minutes per day',
                        controller: _exerciseFrequencyController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your exercise frequency';
                          }
                          return null;
                        },
                      ),

                      // Stress Level Section
                      CustomTextField(
                        label: 'Stress levels',
                        hintText: 'E.g: Intermediate stress level',
                        controller: _stressLevelController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your stress level';
                          }
                          return null;
                        },
                      ),

                      // Smoking & Alcohol Section
                      CustomTextField(
                        label: 'Smoking or alcohol habits?',
                        hintText: 'E.g: Heavy smoking',
                        controller: _smokingAlcoholController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your smoking/alcohol habits';
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
