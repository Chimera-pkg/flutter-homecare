import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class PhysicalSignsPage extends StatefulWidget {
  const PhysicalSignsPage({super.key});

  @override
  State<PhysicalSignsPage> createState() => _PhysicalSignsPageState();
}

class _PhysicalSignsPageState extends State<PhysicalSignsPage> {
  final _eyesExamDateController = TextEditingController();
  final _eyesFindingsController = TextEditingController();
  final _kidneyEgfrController = TextEditingController();
  final _kidneyAcrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final signs = context.read<DiabetesFormCubit>().state.physicalSigns;
    _eyesExamDateController.text = signs.eyesLastExamDate ?? '';
    _eyesFindingsController.text = signs.eyesFindings ?? '';
    _kidneyEgfrController.text = signs.kidneysEgfr ?? '';
    _kidneyAcrController.text = signs.kidneysUrineAcr ?? '';
  }

  @override
  void dispose() {
    _eyesExamDateController.dispose();
    _eyesFindingsController.dispose();
    _kidneyEgfrController.dispose();
    _kidneyAcrController.dispose();
    super.dispose();
  }

  void _updateState() {
    final oldState = context.read<DiabetesFormCubit>().state.physicalSigns;
    context.read<DiabetesFormCubit>().updatePhysicalSigns(oldState.copyWith(
          eyesLastExamDate: _eyesExamDateController.text,
          eyesFindings: _eyesFindingsController.text,
          kidneysEgfr: _kidneyEgfrController.text,
          kidneysUrineAcr: _kidneyAcrController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        final signs = state.physicalSigns;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader('Physical Signs (If Have)'),
              const FormSubHeader('Eyes:',
                  iconPath: "assets/icons/ic_eyes.png"),
              TextFormField(
                controller: _eyesExamDateController,
                onChanged: (_) => _updateState(),
                decoration:
                    const FormInputDecoration(labelText: 'Last Exam Date'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _eyesFindingsController,
                onChanged: (_) => _updateState(),
                decoration: const FormInputDecoration(labelText: 'Findings'),
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Kidneys:',
                  iconPath: "assets/icons/ic_kidney.png"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyEgfrController,
                      onChanged: (_) => _updateState(),
                      decoration: const FormInputDecoration(labelText: 'eGFR'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _kidneyAcrController,
                      onChanged: (_) => _updateState(),
                      decoration:
                          const FormInputDecoration(labelText: 'Urine ACR'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Feet:',
                  iconPath: "assets/icons/ic_feet.png"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _FeetSection(
                      title: 'Skin:',
                      options: const ['Normal', 'Dry', 'Ulcer', 'Infection'],
                      groupValue: signs.feetSkinStatus,
                      onChanged: (v) => context
                          .read<DiabetesFormCubit>()
                          .updatePhysicalSigns(
                              signs.copyWith(feetSkinStatus: v)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _FeetSection(
                      title: 'Deformity:',
                      options: const ['None', 'Bunions', 'Claw toes'],
                      groupValue: signs.feetDeformityStatus,
                      onChanged: (v) => context
                          .read<DiabetesFormCubit>()
                          .updatePhysicalSigns(
                              signs.copyWith(feetDeformityStatus: v)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A specialized widget for the "Feet" section with radio buttons.
class _FeetSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const _FeetSection({
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormSubHeader(title),
        ...options.map((option) {
          return Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: primaryColor,
              ),
              Expanded(child: Text(option)),
            ],
          );
        }),
      ],
    );
  }
}
