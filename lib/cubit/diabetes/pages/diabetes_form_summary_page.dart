import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/widgets/diabetes_form_widget.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_page.dart';
import 'package:m2health/route/app_routes.dart';

class DiabetesFormSummaryPage extends StatelessWidget {
  const DiabetesFormSummaryPage({super.key});

  Future<void> _refreshData(BuildContext context) async {
    await context.read<DiabetesFormCubit>().loadForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diabetes Form',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DiabetesHistorySection(state: state),
                  const SizedBox(height: 24),
                  _RiskFactorsSection(state: state),
                  const SizedBox(height: 24),
                  _LifestyleSection(state: state),
                  const SizedBox(height: 24),
                  _PhysicalSignsSection(state: state),
                  const SizedBox(height: 32),
                  const _ActionButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _SummaryCard({required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor.withValues(alpha: 0.15),
        border: Border.all(color: backgroundColor, width: 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String? iconPath;
  final IconData? icon;
  final Color? valueColor;

  const _SummaryItem({
    required this.label,
    required this.value,
    this.iconPath,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.red.shade400, size: 20),
          const SizedBox(width: 8)
        ],
        if (iconPath != null) ...[
          Image.asset(iconPath!, width: 24, height: 24),
          const SizedBox(width: 8)
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _DiabetesHistorySection extends StatelessWidget {
  final DiabetesFormState state;
  const _DiabetesHistorySection({required this.state});

  String _buildTreatmentString(DiabetesHistory history) {
    List<String> treatments = [];

    if (history.hasTreatmentDiet) {
      treatments.add('Diet & Exercise');
    }
    if (history.hasTreatmentOral) {
      treatments
          .add('Oral Medications: ${_getValueText(history.oralMedication)}');
    }
    if (history.hasTreatmentInsulin) {
      treatments.add('Insulin: ${_getValueText(history.insulinTypeDose)}');
    }
    return treatments.isEmpty ? 'None' : treatments.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final history = state.diabetesHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Diabetes History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFF35C5CF),
          child: Column(
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_diabetes_type.png',
                label: 'Type of Diabetes',
                value: history.diabetesType ?? 'Not specified',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      iconPath: 'assets/icons/ic_calendar.png',
                      label: 'Year of Diagnosis',
                      value: _getValueText(history.yearOfDiagnosis?.toString()),
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      iconPath: 'assets/icons/ic_blood_measurement.png',
                      label: 'Last HbA1c',
                      value: history.lastHbA1c != null
                          ? '${history.lastHbA1c}%'
                          : '-',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                iconPath: 'assets/icons/ic_medical_checklist.png',
                label: 'Current Treatment',
                value: _buildTreatmentString(history),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskFactorsSection extends StatelessWidget {
  final DiabetesFormState state;
  const _RiskFactorsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final factors = state.riskFactors;
    String boolToString(bool? value) =>
        value == true ? 'Yes' : (value == false ? 'No' : '-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Medical History & Risk Factors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFB393FF),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 60,
            ),
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_hypertension.png',
                label: 'Hypertension',
                value: boolToString(factors.hasHypertension),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_fat.png',
                label: 'Dyslipidemia',
                value: boolToString(factors.hasDyslipidemia),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_cardiovascular.png',
                label: 'Cardiovascular Disease',
                value: boolToString(factors.hasCardiovascularDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: 'Eye Disease (Retinopathy)',
                value: boolToString(factors.hasEyeDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_neuropathy.png',
                label: 'Neuropathy',
                value: boolToString(factors.hasNeuropathy),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: 'Kidney Disease',
                value: boolToString(factors.hasKidneyDisease),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_family.png',
                label: 'Family History',
                value: boolToString(factors.hasFamilyHistory),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_smoking.png',
                label: 'Smoking',
                value: _getValueText(factors.smokingStatus),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LifestyleSection extends StatelessWidget {
  final DiabetesFormState state;
  const _LifestyleSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final lifestyle = state.lifestyleSelfCare;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Lifestyle & Self-Care',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFFF9A9A),
          child: Column(
            children: [
              _SummaryItem(
                icon: Icons.bloodtype,
                label: 'Recent Hypoglycemia',
                value: _getValueText(lifestyle.recentHypoglycemia),
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                icon: Icons.directions_run,
                label: 'Physical Activity',
                value: _getValueText(lifestyle.physicalActivity),
              ),
              const SizedBox(height: 16),
              _SummaryItem(
                icon: Icons.restaurant,
                label: 'Diet Quality',
                value: _getValueText(lifestyle.dietQuality),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhysicalSignsSection extends StatelessWidget {
  final DiabetesFormState state;
  const _PhysicalSignsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final signs = state.physicalSigns;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Physical Signs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _SummaryCard(
          backgroundColor: const Color(0xFFF79E1B),
          child: GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 60,
            ),
            children: [
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: 'Eyes (Last Exam)',
                value: _getValueText(signs.eyesLastExamDate),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_eyes.png',
                label: 'Eyes (Findings)',
                value: _getValueText(signs.eyesFindings),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: 'Kidneys (eGFR)',
                value: _getValueText(signs.kidneysEgfr),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_kidney.png',
                label: 'Kidneys (Urine ACR)',
                value: _getValueText(signs.kidneysUrineAcr),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_feet.png',
                label: 'Feet (Skin)',
                value: _getValueText(signs.feetSkinStatus),
              ),
              _SummaryItem(
                iconPath: 'assets/icons/ic_feet.png',
                label: 'Feet (Deformity)',
                value: _getValueText(signs.feetDeformityStatus),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        SecondaryButton(
          text: 'Edit Information',
          icon: Icons.edit,
          onPressed: () async {
            await GoRouter.of(context).pushNamed(AppRoutes.diabeticProfileForm);

            // Force a refresh to discard any unsaved changes and get the latest data from the server.
            if (!context.mounted) return;
            await context.read<DiabetesFormCubit>().loadForm();
          },
        ),
        PrimaryButton(
          text: 'Next',
          onPressed: () async {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PersonalPage(
                title: "Nurse Services Case",
                serviceType: "Nurse",
              ),
            ));
          },
        ),
      ],
    );
  }
}

String _getValueText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return '-';
  }
  return value;
}
