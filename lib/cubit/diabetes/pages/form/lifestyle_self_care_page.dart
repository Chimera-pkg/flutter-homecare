import 'package:flutter/material.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class LifestyleSelfCareFormPage extends StatefulWidget {
  final LifestyleSelfCare initialData;
  final ValueChanged<LifestyleSelfCare> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const LifestyleSelfCareFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<LifestyleSelfCareFormPage> createState() =>
      LifestyleSelfCarePageState();
}

class LifestyleSelfCarePageState extends State<LifestyleSelfCareFormPage> {
  late LifestyleSelfCare _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
  }

  String? validate() {
    if (_currentData.recentHypoglycemia == null ||
        _currentData.physicalActivity == null ||
        _currentData.dietQuality == null) {
      return 'Please answer all questions on this page.';
    }
    return null;
  }

  void updateState(LifestyleSelfCare updatedData) {
    setState(() {
      _currentData = updatedData;
    });
    widget.onChange(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lifestyle & Selfcare",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onPressBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSectionHeader('Lifestyle & Self-Care'),
            FormRadioGroup(
              icon: Icons.bloodtype,
              title: 'Recent Hypoglycemia:',
              options: const ['None', 'Mild', 'Severe'],
              groupValue: _currentData.recentHypoglycemia,
              onChanged: (v) =>
                  updateState(_currentData.copyWith(recentHypoglycemia: v)),
            ),
            FormRadioGroup(
              icon: Icons.directions_run,
              title: 'Physical Activity:',
              options: const ['Regular', 'Occasional', 'Sedentary'],
              groupValue: _currentData.physicalActivity,
              onChanged: (v) =>
                  updateState(_currentData.copyWith(physicalActivity: v)),
            ),
            FormRadioGroup(
              icon: Icons.restaurant,
              title: 'Diet Quality:',
              options: const ['Healthy', 'Needs Improvement'],
              groupValue: _currentData.dietQuality,
              onChanged: (v) =>
                  updateState(_currentData.copyWith(dietQuality: v)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PrimaryButton(
          text: widget.saveButtonText,
          onPressed: () {
            final validationError = validate();
            if (validationError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(validationError),
                    backgroundColor: Colors.red),
              );
              return;
            }
            widget.onSave();
          },
        ),
      ),
    );
  }
}
