import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/precision_widgets.dart';
import '../../../bloc/nutrition_assessment_cubit.dart';
import 'lifestyle_habits_screen.dart';

class SelfRatedHealthScreen extends StatelessWidget {
  const SelfRatedHealthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Self-Rated Health'),
      body: BlocBuilder<NutritionAssessmentCubit, NutritionAssessmentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Spacer(),

                // Emoji Display
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getEmoji(state.selfRatedHealth),
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Health Rating Text
                Text(
                  _getHealthRatingText(state.selfRatedHealth),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Slider
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
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 24),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: state.selfRatedHealth,
                          min: 1.0,
                          max: 5.0,
                          divisions: 4,
                          onChanged: (value) {
                            context
                                .read<NutritionAssessmentCubit>()
                                .updateSelfRatedHealth(value);
                          },
                        ),
                      ),

                      // Slider Labels
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terrible',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Excellent',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Next Button
                PrimaryButton(
                  text: 'Next',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LifestyleHabitsScreen(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getEmoji(double rating) {
    if (rating <= 1.5) return '😰';
    if (rating <= 2.5) return '😕';
    if (rating <= 3.5) return '😐';
    if (rating <= 4.5) return '🙂';
    return '😊';
  }

  String _getHealthRatingText(double rating) {
    if (rating <= 1.5) return "It's terrible";
    if (rating <= 2.5) return "It's bad";
    if (rating <= 3.5) return "Neutral";
    if (rating <= 4.5) return "It's good";
    return "It's very good";
  }
}
