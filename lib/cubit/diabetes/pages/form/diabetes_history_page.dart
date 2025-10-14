import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class DiabetesHistoryPage extends StatefulWidget {
  const DiabetesHistoryPage({super.key});

  @override
  State<DiabetesHistoryPage> createState() => _DiabetesHistoryPageState();
}

class _DiabetesHistoryPageState extends State<DiabetesHistoryPage> {
  final _otherDiabetesTypeController = TextEditingController();
  final _yearDiagnosisController = TextEditingController();
  final _lastHbA1cController = TextEditingController();
  final _oralMedicationsController = TextEditingController();
  final _insulinTypeDoseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers from the cubit's state
    final history = context.read<DiabetesFormCubit>().state.diabetesHistory;
    _otherDiabetesTypeController.text =
        history.hasOtherDiabetesType ? history.diabetesType ?? '' : '';
    _yearDiagnosisController.text = history.yearOfDiagnosis?.toString() ?? '';
    _lastHbA1cController.text = history.lastHbA1c?.toString() ?? '';
    _oralMedicationsController.text = history.oralMedication ?? '';
    _insulinTypeDoseController.text = history.insulinTypeDose ?? '';
  }

  @override
  void dispose() {
    _otherDiabetesTypeController.dispose();
    _yearDiagnosisController.dispose();
    _lastHbA1cController.dispose();
    _oralMedicationsController.dispose();
    _insulinTypeDoseController.dispose();
    super.dispose();
  }

  void _updateState() {
    final oldHistory = context.read<DiabetesFormCubit>().state.diabetesHistory;
    context.read<DiabetesFormCubit>().updateDiabetesHistory(
          oldHistory.copyWith(
            yearOfDiagnosis: int.tryParse(_yearDiagnosisController.text),
            lastHbA1c: double.tryParse(_lastHbA1cController.text),
            oralMedication: _oralMedicationsController.text,
            insulinTypeDose: _insulinTypeDoseController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    const diabetesTypes = ['Type 1', 'Type 2', 'Gestational'];

    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        final history = state.diabetesHistory;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormSectionHeader('Diabetes History'),
              const FormSubHeader('Type of Diabetes:',
                  iconPath: "assets/icons/ic_diabetes_type.png"),
              Wrap(
                spacing: 0.0,
                runSpacing: -10.0,
                children: diabetesTypes.map((type) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: type,
                        activeColor: primaryColor,
                        groupValue: history.diabetesType,
                        onChanged: (v) {
                          context
                              .read<DiabetesFormCubit>()
                              .updateDiabetesHistory(
                                  history.copyWith(diabetesType: v));
                        },
                      ),
                      Text(type),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              const Text('Other:'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _otherDiabetesTypeController,
                onChanged: (_) => _updateState(),
                decoration: const FormInputDecoration()
                    .copyWith(hintText: 'Please enter your type of diabetes'),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormSubHeader('Year of Diagnosis:',
                            iconPath: "assets/icons/ic_calendar.png"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _yearDiagnosisController,
                          onChanged: (_) => _updateState(),
                          decoration: const FormInputDecoration()
                              .copyWith(hintText: 'e.g 2021'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormSubHeader('Last HbA1c:',
                            iconPath: "assets/icons/ic_blood_measurement.png"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastHbA1cController,
                          onChanged: (_) => _updateState(),
                          decoration: const FormInputDecoration()
                              .copyWith(hintText: 'E.g 5.0%'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const FormSubHeader('Current Treatment:',
                  iconPath: "assets/icons/ic_medical_checklist.png"),
              FormCheckbox(
                title: 'Diet & Exercise',
                value: history.hasTreatmentDiet,
                onChanged: (v) {
                  context.read<DiabetesFormCubit>().updateDiabetesHistory(
                      history.copyWith(hasTreatmentDiet: v));
                },
              ),
              FormCheckbox(
                title: 'Oral Medications',
                value: history.hasTreatmentOral,
                onChanged: (v) {
                  context.read<DiabetesFormCubit>().updateDiabetesHistory(
                      history.copyWith(hasTreatmentOral: v));
                },
              ),
              if (history.hasTreatmentOral)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _oralMedicationsController,
                    onChanged: (_) => _updateState(),
                    decoration: const FormInputDecoration()
                        .copyWith(hintText: 'List medications...'),
                  ),
                ),
              FormCheckbox(
                title: 'Insulin',
                value: history.hasTreatmentInsulin,
                onChanged: (v) {
                  context.read<DiabetesFormCubit>().updateDiabetesHistory(
                      history.copyWith(hasTreatmentInsulin: v));
                },
              ),
              if (history.hasTreatmentInsulin)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 8, top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _insulinTypeDoseController,
                    onChanged: (_) => _updateState(),
                    decoration: const FormInputDecoration()
                        .copyWith(hintText: 'Type & dose'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
