import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import 'precision_cubit.dart';

class PrecisionNutritionPage extends StatelessWidget {
  const PrecisionNutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrecisionCubit, PrecisionState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Precision Nutrition'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Timeline
                Container(
                  width: 100,
                  child: const NutritionTimeline(currentStep: 1),
                ),
                const SizedBox(width: 16),

                // Right side - Cards
                Expanded(
                  child: Column(
                    children: [
                      // Step 1: Assessment Card
                      PrecisionNutritionCard(
                        step: "1",
                        title: "Precision Nutrition Assessment",
                        description:
                            "Start your journey with a deep analysis of your genes, metabolism and lifestyle to understand your body's unique needs.",
                        buttonText: state.isSubmitted ? "View" : "Start Now",
                        imagePath: "assets/illustration/foodies.png",
                        backgroundColor: const Color(0xFFE8F3FF),
                        onTap: () {
                          final path = state.isSubmitted
                              ? AppRoutes.precisionNutritionAssessmentDetail
                              : AppRoutes.precisionNutritionAssessmentForm;
                          GoRouter.of(context).goNamed(path);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Step 2: Plan Card
                      PrecisionNutritionCard(
                        step: "2",
                        title: "Precision Nutrition Plan",
                        description:
                            "Receive a personalized nutrition strategy crafted by experts to address your specific health goals and conditions.",
                        buttonText: "Book Now",
                        imagePath: "assets/illustration/planning.png",
                        backgroundColor: const Color(0xFFFFF6E9),
                        onTap: () => _showComingSoonDialog(context),
                      ),

                      const SizedBox(height: 16),

                      // Step 3: Implementation Card
                      PrecisionNutritionCard(
                        step: "3",
                        title: "Precision Nutrition Implementation",
                        description:
                            "Track progress and adapt your plan through continuous support, biomarker monitoring, and smart digital tools.",
                        buttonText: "Start Now",
                        imagePath: "assets/illustration/implement.png",
                        backgroundColor: const Color(0xFFF8F0FF),
                        onTap: () => _showComingSoonDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('This feature will be available soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class PrecisionNutritionCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final String buttonText;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback onTap;

  const PrecisionNutritionCard({
    Key? key,
    required this.step,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.imagePath,
    required this.backgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          step,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}

class NutritionTimeline extends StatelessWidget {
  final int currentStep;

  const NutritionTimeline({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimelineItem(1, "Assessment", currentStep >= 1),
        _buildVerticalLine(currentStep >= 2),
        _buildTimelineItem(2, "Plan", currentStep >= 2),
        _buildVerticalLine(currentStep >= 3),
        _buildTimelineItem(3, "Implementation", currentStep >= 3),
      ],
    );
  }

  Widget _buildTimelineItem(int step, String label, bool isCompleted) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 200,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    step.toString(),
                    style: TextStyle(
                      color: isCompleted ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isCompleted ? Colors.black : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVerticalLine(bool isCompleted) {
    return Container(
      width: 2,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }
}
