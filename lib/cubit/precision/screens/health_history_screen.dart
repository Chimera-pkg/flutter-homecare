import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/precision_widgets.dart';
import '../precision_cubit.dart';
import 'self_rated_health_screen.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({Key? key}) : super(key: key);

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  String? _selectedGender;
  final _conditionController = TextEditingController();
  final _medicationController = TextEditingController();
  final _familyHistoryController = TextEditingController();

  final List<String> _specialConsiderations = [
    'Liver Disease',
    'Lung Disease',
    'Children',
    'Kidney Disease',
    'Aging Adult',
    'Pregnant',
  ];

  final Map<String, bool> _selectedConsiderations = {};

  final _availableGenders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    // Initialize all considerations as false
    for (String consideration in _specialConsiderations) {
      _selectedConsiderations[consideration] = false;
    }

    // Initialize all fields based on existing state if available
    final healthProfile = context.read<PrecisionCubit>().state.healthProfile;
    if (healthProfile == null) return;

    _ageController.text = healthProfile.age.toString();
    _selectedGender = _availableGenders.contains(healthProfile.gender)
        ? healthProfile.gender
        : null;
    _conditionController.text = healthProfile.knownCondition ?? '';
    _medicationController.text = healthProfile.medicationHistory ?? '';
    _familyHistoryController.text = healthProfile.familyHistory ?? '';
    for (String consideration in healthProfile.specialConsiderations) {
      if (_selectedConsiderations.containsKey(consideration)) {
        _selectedConsiderations[consideration] = true;
      }
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _conditionController.dispose();
    _medicationController.dispose();
    _familyHistoryController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate()) {
      // Create HealthProfile and update cubit
      final healthProfile = HealthProfile(
        age: int.parse(_ageController.text),
        gender: _selectedGender!,
        knownCondition: _conditionController.text.isEmpty
            ? null
            : _conditionController.text,
        specialConsiderations: _selectedConsiderations.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
        medicationHistory: _medicationController.text.isEmpty
            ? null
            : _medicationController.text,
        familyHistory: _familyHistoryController.text.isEmpty
            ? null
            : _familyHistoryController.text,
      );

      context.read<PrecisionCubit>().updateHealthProfile(healthProfile);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SelfRatedHealthScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Basic Info & Health History'),
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
                      // Age & Gender Section
                      const Text(
                        'Age & Gender',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Age',
                        hintText: 'E.g 34 years old',
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid age';
                          }
                          return null;
                        },
                      ),

                      CustomDropdown(
                        label: 'Gender',
                        value: _selectedGender,
                        items: _availableGenders,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Known Condition Section
                      const Text(
                        'Known Condition (Optional)',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Known Condition (Optional)',
                        hintText: 'Write your condition history here',
                        controller: _conditionController,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 24),

                      // Special Considerations Section
                      const Text(
                        'Patient with Special Consideration',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _specialConsiderations.length,
                        itemBuilder: (context, index) {
                          final consideration = _specialConsiderations[index];
                          return CustomCheckbox(
                            label: consideration,
                            value:
                                _selectedConsiderations[consideration] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _selectedConsiderations[consideration] =
                                    value ?? false;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Medication History Section
                      const Text(
                        'Medication & supplement history',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Medication & supplement history',
                        hintText: 'E.g: Avoid Clopidogrel, Ondansetron, etc',
                        controller: _medicationController,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 24),

                      // Family Health History Section
                      const Text(
                        'Family health history',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Family health history',
                        hintText:
                            'Write other biomarkers here (minimum 10 characters)',
                        controller: _familyHistoryController,
                        maxLines: 3,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 10) {
                            return 'Please enter at least 10 characters';
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
