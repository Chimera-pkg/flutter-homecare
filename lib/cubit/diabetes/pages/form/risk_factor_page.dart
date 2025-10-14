import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';

class RiskFactorsPage extends StatefulWidget {
  const RiskFactorsPage({super.key});

  @override
  State<RiskFactorsPage> createState() => RiskFactorsPageState();
}

class RiskFactorsPageState extends State<RiskFactorsPage> {
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

    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        final factors = state.riskFactors;
        return SingleChildScrollView(
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
                    groupValue: _getGroupValue(item['name'], factors),
                    onChanged: (value) {
                      _updateRiskFactor(context, item['name'], value, factors);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
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

  void _updateRiskFactor(BuildContext context, String name, String? value,
      RiskFactors oldFactors) {
    bool? boolValue = value == 'Yes' ? true : (value == 'No' ? false : null);
    RiskFactors newFactors;
    switch (name) {
      case 'Hypertension':
        newFactors = oldFactors.copyWith(hasHypertension: boolValue);
        break;
      case 'Dyslipidemia':
        newFactors = oldFactors.copyWith(hasDyslipidemia: boolValue);
        break;
      case 'Cardiovascular Disease':
        newFactors = oldFactors.copyWith(hasCardiovascularDisease: boolValue);
        break;
      case 'Neuropathy':
        newFactors = oldFactors.copyWith(hasNeuropathy: boolValue);
        break;
      case 'Eye Disease (Retinopathy)':
        newFactors = oldFactors.copyWith(hasEyeDisease: boolValue);
        break;
      case 'Kidney Disease':
        newFactors = oldFactors.copyWith(hasKidneyDisease: boolValue);
        break;
      case 'Family History of Diabetes':
        newFactors = oldFactors.copyWith(hasFamilyHistory: boolValue);
        break;
      case 'Smoking':
        newFactors = oldFactors.copyWith(smokingStatus: value);
        break;
      default:
        newFactors = oldFactors;
    }
    context
        .read<DiabetesFormCubit>()
        .updateMedicalHistoryRiskFactors(newFactors);
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
