import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/pages/form/risk_factor_page.dart';

class EditMedicalHistoryNRiskFactorPage extends StatefulWidget {
  const EditMedicalHistoryNRiskFactorPage({super.key});

  @override
  State<EditMedicalHistoryNRiskFactorPage> createState() =>
      _EditMedicalHistoryNRiskFactorPageState();
}

class _EditMedicalHistoryNRiskFactorPageState
    extends State<EditMedicalHistoryNRiskFactorPage> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<DiabetesFormCubit>().state;
    log('Initializing EditMedicalHistoryNRiskFactorPage with state: ${state.riskFactors}',
        name: 'EditMedicalHistoryNRiskFactorPage');
    context.read<DiabetesFormCubit>().loadForm();
  }

  Future<void> _onSave(BuildContext context) async {
    final cubit = context.read<DiabetesFormCubit>();

    setState(() {
      _isSaving = true;
    });

    final bool success = await cubit.submitForm();

    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Updated successfully!'),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(cubit.state.errorMessage ?? 'Failed to save data.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiabetesFormCubit, DiabetesFormState>(
      builder: (context, state) {
        log('Building Risk Factors Form Page with state: ${state}',
            name: 'EditMedicalHistoryNRiskFactorPage');

        if (state.isLoading && !_isSaving) {
          log('State is loading, showing CircularProgressIndicator',
              name: 'EditMedicalHistoryNRiskFactorPage');
          return Scaffold(
            appBar: AppBar(
              title: const Text("Medical History & Risk Factors"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => GoRouter.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return RiskFactorsFormPage(
          initialData: state.riskFactors,
          onChange: (updatedRiskFactors) {
            context
                .read<DiabetesFormCubit>()
                .updateMedicalHistoryRiskFactors(updatedRiskFactors);
          },
          onSave: () {
            if (!_isSaving) {
              _onSave(context);
            }
          },
          saveButtonText: _isSaving ? 'Saving...' : 'Save',
          onPressBack: () => GoRouter.of(context).pop(),
        );
      },
    );
  }
}
