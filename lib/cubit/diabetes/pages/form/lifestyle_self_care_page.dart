import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class LifestyleSelfCarePage extends StatefulWidget {
  const LifestyleSelfCarePage({super.key});

  @override
  State<LifestyleSelfCarePage> createState() => LifestyleSelfCarePageState();
}

class LifestyleSelfCarePageState extends State<LifestyleSelfCarePage> {
  String? validate() {
    final lifestyle = context.read<DiabetesFormCubit>().state.lifestyleSelfCare;
    if (lifestyle.recentHypoglycemia == null ||
        lifestyle.physicalActivity == null ||
        lifestyle.dietQuality == null) {
      return 'Please answer all questions on this page.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        final lifestyle = state.lifestyleSelfCare;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader('Lifestyle & Self-Care'),
              FormRadioGroup(
                icon: Icons.bloodtype,
                title: 'Recent Hypoglycemia:',
                options: const ['None', 'Mild', 'Severe'],
                groupValue: lifestyle.recentHypoglycemia,
                onChanged: (v) => context
                    .read<DiabetesFormCubit>()
                    .updateLifestyleSelfCare(
                        lifestyle.copyWith(recentHypoglycemia: v)),
              ),
              FormRadioGroup(
                icon: Icons.directions_run,
                title: 'Physical Activity:',
                options: const ['Regular', 'Occasional', 'Sedentary'],
                groupValue: lifestyle.physicalActivity,
                onChanged: (v) => context
                    .read<DiabetesFormCubit>()
                    .updateLifestyleSelfCare(
                        lifestyle.copyWith(physicalActivity: v)),
              ),
              FormRadioGroup(
                icon: Icons.restaurant,
                title: 'Diet Quality:',
                options: const ['Healthy', 'Needs Improvement'],
                groupValue: lifestyle.dietQuality,
                onChanged: (v) => context
                    .read<DiabetesFormCubit>()
                    .updateLifestyleSelfCare(
                        lifestyle.copyWith(dietQuality: v)),
              ),
            ],
          ),
        );
      },
    );
  }
}
