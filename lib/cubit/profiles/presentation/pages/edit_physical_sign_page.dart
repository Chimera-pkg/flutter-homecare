import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_cubit.dart';
import 'package:m2health/cubit/diabetes/bloc/diabetes_form_state.dart';
import 'package:m2health/cubit/diabetes/pages/form/physical_signs_page.dart';

class EditPhysicalSignPage extends StatefulWidget {
  const EditPhysicalSignPage({super.key});

  @override
  State<EditPhysicalSignPage> createState() => _EditPhysicalSignPageState();
}

class _EditPhysicalSignPageState extends State<EditPhysicalSignPage> {
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
              title: const Text("Physical Sign"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return PhysicalSignsFormPage(
          initialData: state.physicalSigns,
          onChange: (updatedPhysicalSigns) {
            context
                .read<DiabetesFormCubit>()
                .updatePhysicalSigns(updatedPhysicalSigns);
          },
          onSave: () {
            // Trigger the async save function
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
