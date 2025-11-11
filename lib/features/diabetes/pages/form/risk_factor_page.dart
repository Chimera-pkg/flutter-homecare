import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/widgets/diabetes_form_widget.dart';

class RiskFactorsFormPage extends StatefulWidget {
  final RiskFactors initialData;
  final ValueChanged<RiskFactors> onChange;
  final VoidCallback onSave;
  final String saveButtonText;
  final VoidCallback? onPressBack;

  const RiskFactorsFormPage({
    super.key,
    required this.initialData,
    required this.onChange,
    required this.onSave,
    this.saveButtonText = 'Save',
    this.onPressBack,
  });

  @override
  State<RiskFactorsFormPage> createState() => RiskFactorsPageState();
}

class RiskFactorsPageState extends State<RiskFactorsFormPage> {
  late RiskFactors _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.initialData;
  }

  String? validate() {
    final factors = context.read<DiabetesFormCubit>().state.riskFactors;
    if (factors.hasHypertension == null ||
        factors.hasDyslipidemia == null ||
        factors.hasCardiovascularDisease == null ||
        factors.hasNeuropathy == null ||
        factors.hasEyeDisease == null ||
        factors.hasKidneyDisease == null ||
        factors.hasFamilyHistory == null ||
        factors.smokingStatus == null) {
      return 'Please answer all questions on this page.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const yesNoOptions = ['Yes', 'No'];
    final List<Map<String, dynamic>> riskFactorItems = [
      {
        "name": 'Hypertension',
        "icon": "assets/icons/ic_hypertension.png",
        "options": yesNoOptions
      },
      {
        "name": 'Dyslipidemia',
        "icon": "assets/icons/ic_fat.png",
        "options": yesNoOptions
      },
      {
        "name": 'Cardiovascular Disease',
        "icon": "assets/icons/ic_cardiovascular.png",
        "options": yesNoOptions
      },
      {
        "name": 'Eye Disease (Retinopathy)',
        "icon": "assets/icons/ic_eyes.png",
        "options": yesNoOptions
      },
      {
        "name": 'Neuropathy',
        "icon": "assets/icons/ic_neuropathy.png",
        "options": yesNoOptions
      },
      {
        "name": 'Kidney Disease',
        "icon": "assets/icons/ic_kidney.png",
        "options": yesNoOptions
      },
      {
        "name": 'Family History of Diabetes',
        "icon": "assets/icons/ic_family.png",
        "options": yesNoOptions
      },
      {
        "name": 'Smoking',
        "icon": "assets/icons/ic_smoking.png",
        "options": ['Current', 'Former', 'Never']
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Medical History & Risk Factors",
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
            const FormSectionHeader('Medical History & Risk Factors'),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: riskFactorItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 10,
                mainAxisExtent: 136,
              ),
              itemBuilder: (context, index) {
                final item = riskFactorItems[index];
                return RiskFactorCard(
                  name: item['name'],
                  iconPath: item['icon'],
                  options: item['options'],
                  groupValue: _getGroupValue(item['name'], _currentData),
                  onChanged: (value) {
                    _updateRiskFactor(context, item['name'], value);
                  },
                );
              },
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

  String? _getGroupValue(String name, RiskFactors factors) {
    switch (name) {
      case 'Hypertension':
        return factors.hasHypertension == null
            ? null
            : (factors.hasHypertension! ? 'Yes' : 'No');
      case 'Dyslipidemia':
        return factors.hasDyslipidemia == null
            ? null
            : (factors.hasDyslipidemia! ? 'Yes' : 'No');
      case 'Cardiovascular Disease':
        return factors.hasCardiovascularDisease == null
            ? null
            : (factors.hasCardiovascularDisease! ? 'Yes' : 'No');
      case 'Neuropathy':
        return factors.hasNeuropathy == null
            ? null
            : (factors.hasNeuropathy! ? 'Yes' : 'No');
      case 'Eye Disease (Retinopathy)':
        return factors.hasEyeDisease == null
            ? null
            : (factors.hasEyeDisease! ? 'Yes' : 'No');
      case 'Kidney Disease':
        return factors.hasKidneyDisease == null
            ? null
            : (factors.hasKidneyDisease! ? 'Yes' : 'No');
      case 'Family History of Diabetes':
        return factors.hasFamilyHistory == null
            ? null
            : (factors.hasFamilyHistory! ? 'Yes' : 'No');
      case 'Smoking':
        return factors.smokingStatus;
      default:
        return null;
    }
  }

  void _updateRiskFactor(BuildContext context, String name, String? value) {
    bool? boolValue = value == 'Yes' ? true : (value == 'No' ? false : null);
    RiskFactors newFactors;
    switch (name) {
      case 'Hypertension':
        newFactors = _currentData.copyWith(hasHypertension: boolValue);
        break;
      case 'Dyslipidemia':
        newFactors = _currentData.copyWith(hasDyslipidemia: boolValue);
        break;
      case 'Cardiovascular Disease':
        newFactors = _currentData.copyWith(hasCardiovascularDisease: boolValue);
        break;
      case 'Neuropathy':
        newFactors = _currentData.copyWith(hasNeuropathy: boolValue);
        break;
      case 'Eye Disease (Retinopathy)':
        newFactors = _currentData.copyWith(hasEyeDisease: boolValue);
        break;
      case 'Kidney Disease':
        newFactors = _currentData.copyWith(hasKidneyDisease: boolValue);
        break;
      case 'Family History of Diabetes':
        newFactors = _currentData.copyWith(hasFamilyHistory: boolValue);
        break;
      case 'Smoking':
        newFactors = _currentData.copyWith(smokingStatus: value);
        break;
      default:
        newFactors = _currentData;
    }
    setState(() {
      _currentData = newFactors;
    });
    widget.onChange(newFactors);
  }
}

/// A card specifically for displaying a risk factor with radio button options.
class RiskFactorCard extends StatelessWidget {
  final String name;
  final String iconPath;
  final List<String> options;
  final String? groupValue;
  final ValueChanged<String?> onChanged;

  const RiskFactorCard({
    super.key,
    required this.name,
    required this.iconPath,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FormSubHeader(name, iconPath: iconPath),
        Wrap(
          direction: Axis.vertical,
          spacing: -10,
          children: options.map((value) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: primaryColor,
                ),
                Text(value),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
