import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/precision_widgets.dart';
import '../../../bloc/nutrition_assessment_cubit.dart';
import 'health_history_screen.dart';

class MainConcernScreen extends StatelessWidget {
  const MainConcernScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NutritionAssessmentCubit(),
      child: const MainConcernView(),
    );
  }
}

class MainConcernView extends StatelessWidget {
  const MainConcernView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Precision Nutrition Assessment'),
      body: BlocBuilder<NutritionAssessmentCubit, NutritionAssessmentState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What is your main concern?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose the area that best describes your primary health goal',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),

                // Selection Cards
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SelectionCard(
                          title: 'Sub-Health',
                          description:
                              'Improve overall wellness and energy levels',
                          imagePath: 'assets/illustration/foodies.png',
                          isSelected: state.mainConcern == 'Sub-Health',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Sub-Health'),
                        ),
                        SelectionCard(
                          title: 'Chronic Disease',
                          description:
                              'Manage and improve chronic health conditions',
                          imagePath: 'assets/illustration/planning.png',
                          isSelected: state.mainConcern == 'Chronic Disease',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Chronic Disease'),
                        ),
                        SelectionCard(
                          title: 'Anti-aging',
                          description:
                              'Optimize health and vitality as you age',
                          imagePath: 'assets/illustration/implement.png',
                          isSelected: state.mainConcern == 'Anti-aging',
                          onTap: () => context
                              .read<NutritionAssessmentCubit>()
                              .setMainConcern('Anti-aging'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Next Button
                PrimaryButton(
                  text: 'Next',
                  onPressed: state.mainConcern != null
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealthHistoryScreen(),
                            ),
                          )
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
