import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/pages/form/diabetes_history_page.dart';
import 'package:m2health/features/diabetes/pages/form/lifestyle_self_care_page.dart';
import 'package:m2health/features/diabetes/pages/form/physical_signs_page.dart';
import 'package:m2health/features/diabetes/pages/form/risk_factor_page.dart';
import 'package:m2health/route/app_routes.dart';

class DiabetesFormPage extends StatefulWidget {
  const DiabetesFormPage({super.key});

  @override
  State<DiabetesFormPage> createState() => _DiabetesFormPageState();
}

class _DiabetesFormPageState extends State<DiabetesFormPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final cubit = context.read<DiabetesFormCubit>();
    final success = await cubit.submitForm();
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.state.errorMessage ?? 'Failed to submit form.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    GoRouter.of(context).goNamed(AppRoutes.diabeticProfileSummary);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null && !state.isSubmitted) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text(state.errorMessage ?? 'Failed to load form data.'),
            ),
          );
        }

        return PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildDiabetesHistoryPage(context, state),
            _buildRiskFactorsPage(context, state),
            _buildLifestylePage(context, state),
            _buildPhysicalSignsPage(context, state),
          ],
        );
      },
    );
  }

  Widget _buildDiabetesHistoryPage(
      BuildContext context, DiabetesFormState state) {
    return DiabetesHistoryFormPage(
      initialData: state.diabetesHistory,
      onChange: (newData) {
        context.read<DiabetesFormCubit>().updateDiabetesHistory(newData);
      },
      onSave: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      saveButtonText: 'Next',
      onPressBack: () => Navigator.of(context).pop(), // Handle back
    );
  }

  Widget _buildRiskFactorsPage(BuildContext context, DiabetesFormState state) {
    return RiskFactorsFormPage(
      initialData: state.riskFactors,
      onChange: (newData) {
        context
            .read<DiabetesFormCubit>()
            .updateMedicalHistoryRiskFactors(newData);
      },
      onSave: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      saveButtonText: 'Next',
      onPressBack: () => _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ), // Handle back
    );
  }

  Widget _buildLifestylePage(BuildContext context, DiabetesFormState state) {
    return LifestyleSelfCareFormPage(
      initialData: state.lifestyleSelfCare,
      onChange: (newData) {
        context.read<DiabetesFormCubit>().updateLifestyleSelfCare(newData);
      },
      onSave: () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      saveButtonText: 'Next',
      onPressBack: () => _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ), // Handle back
    );
  }

  Widget _buildPhysicalSignsPage(
      BuildContext context, DiabetesFormState state) {
    return PhysicalSignsFormPage(
      initialData: state.physicalSigns,
      onChange: (newData) {
        context.read<DiabetesFormCubit>().updatePhysicalSigns(newData);
      },
      onSave: _submitForm,
      saveButtonText: 'Submit',
      onPressBack: () => _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ), // Handle back
    );
  }
}
