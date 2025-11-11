import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/features/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/features/diabetes/pages/form/lifestyle_self_care_page.dart';

class EditLifestyleNSelfcarePage extends StatefulWidget {
  const EditLifestyleNSelfcarePage({super.key});

  @override
  State<EditLifestyleNSelfcarePage> createState() =>
      _EditLifestyleNSelfcarePageState();
}

class _EditLifestyleNSelfcarePageState
    extends State<EditLifestyleNSelfcarePage> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
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
        if (state.isLoading && !_isSaving) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Lifestyle & Selfcare"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return LifestyleSelfCareFormPage(
          initialData: state.lifestyleSelfCare,
          onChange: (updatedLifestyle) {
            context
                .read<DiabetesFormCubit>()
                .updateLifestyleSelfCare(updatedLifestyle);
          },
          onSave: () {
            if (!_isSaving) {
              _onSave(context);
            }
          },
          saveButtonText: _isSaving ? 'Saving...' : 'Save',
          onPressBack: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
