import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../precision_cubit.dart';
import '../widgets/precision_widgets.dart';

class NutritionAssessmentDetailScreen extends StatelessWidget {
  const NutritionAssessmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PrecisionCubit>().state;
    final healthProfile = state.healthProfile;
    final lifestyleHabits = state.lifestyleHabits;
    final nutritionHabits = state.nutritionHabits;

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Nutrition Assessment Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Basic Info & Health History'),
            if (healthProfile != null) _BasicInfoCard(profile: healthProfile),
            const SizedBox(height: 24),
            const _SectionTitle('Lifestyle & Habits'),
            if (lifestyleHabits != null)
              _LifestyleHabitsCard(habits: lifestyleHabits),
            const SizedBox(height: 24),
            const _SectionTitle('Nutrition Habits'),
            if (nutritionHabits != null)
              _NutritionHabitsCard(habits: nutritionHabits),
            const SizedBox(height: 24),
            const _SectionTitle('Self-Rated Health'),
            _SelfRatedHealthCard(rating: state.selfRatedHealth),
            const SizedBox(height: 24),
            const _SectionTitle('Biomarker Upload'),
            _BiomarkerUploadCard(uploadedFiles: state.uploadedFiles),
            const SizedBox(height: 32),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _DetailItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24, color: iconColor ?? const Color(0xFF00B4D8)),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  final HealthProfile profile;
  const _BasicInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage:
                    AssetImage('assets/illustration/avatar_placeholder.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _DetailItem(
                        label: 'Age',
                        value: '${profile.age} years old',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _DetailItem(
                        label: 'Gender',
                        value: profile.gender,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Consideration',
                  value: profile.specialConsiderations.join(', ').isEmpty
                      ? '-'
                      : profile.specialConsiderations.join(', '),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: 'Known Condition',
                  value: profile.knownCondition ?? '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  label: 'Medical History',
                  value: profile.medicationHistory ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  label: 'Family History',
                  value: profile.familyHistory ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LifestyleHabitsCard extends StatelessWidget {
  final LifestyleHabits habits;
  const _LifestyleHabitsCard({required this.habits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.nightlight_round,
                  label: 'Sleep',
                  value: '${habits.sleepHours.toStringAsFixed(1)} hrs/night',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.fitness_center,
                  label: 'Exercise',
                  value: habits.exerciseFrequency,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.watch_later_outlined,
                  label: 'Activity',
                  value: habits.activityLevel,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'Stress Levels',
                  value: habits.stressLevel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.smoking_rooms,
            label: 'Smoking/Alcohol',
            value: habits.smokingAlcoholHabits,
          ),
        ],
      ),
    );
  }
}

class _NutritionHabitsCard extends StatelessWidget {
  final NutritionHabits habits;
  const _NutritionHabitsCard({required this.habits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.restaurant_menu,
                  label: 'Meal Frequency',
                  value: habits.mealFrequency,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.no_food,
                  label: 'Allergies',
                  value: habits.foodSensitivities,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.favorite_border,
                  label: 'Favorite Foods',
                  value: habits.favoriteFoods,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.do_not_disturb_on_outlined,
                  label: 'Avoided Foods',
                  value: habits.avoidedFoods,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.water_drop_outlined,
                  label: 'Water Intake',
                  value: habits.waterIntake,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DetailItem(
                  icon: Icons.history,
                  label: 'Past Diets',
                  value: habits.pastDiets,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelfRatedHealthCard extends StatelessWidget {
  final double rating;
  const _SelfRatedHealthCard({required this.rating});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DetailItem(
            label: 'Status',
            value: _getHealthRatingText(rating),
          ),
          Text(
            _getEmoji(rating),
            style: const TextStyle(fontSize: 40),
          ),
        ],
      ),
    );
  }
}

class _BiomarkerUploadCard extends StatelessWidget {
  final List<String> uploadedFiles;
  const _BiomarkerUploadCard({required this.uploadedFiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _DetailItem(
            icon: Icons.description_outlined,
            iconColor: Colors.red.shade400,
            label: 'Medical Report',
            value: uploadedFiles.isNotEmpty
                ? 'Uploaded (${uploadedFiles.join(", ")})'
                : 'Not Uploaded',
          ),
          const SizedBox(height: 16),
          _DetailItem(
            icon: Icons.watch,
            iconColor: Colors.red.shade400,
            label: 'Connected Device',
            value: 'No',
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: 'Edit Information',
                icon: Icons.edit,
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SecondaryButton(
                text: 'Download (PDF)',
                icon: Icons.download,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('PDF download not implemented yet.')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          text: 'Back to Precision Nutrition Page',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
