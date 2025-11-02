import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/form/medical_record_form_cubit.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/form/medical_record_form_state.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/cubit/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/service_locator.dart';

class MedicalRecordFormPage extends StatelessWidget {
  final MedicalRecord? recordToEdit;

  const MedicalRecordFormPage({super.key, this.recordToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MedicalRecordFormCubit(
          createMedicalRecord: sl(),
          updateMedicalRecord: sl(),
        );
        if (recordToEdit != null) {
          cubit.initializeForm(recordToEdit!);
        }
        return cubit;
      },
      child: MedicalRecordFormView(
        isEditMode: recordToEdit != null,
      ),
    );
  }
}

class MedicalRecordFormView extends StatelessWidget {
  final bool isEditMode;
  const MedicalRecordFormView({super.key, required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Medical Record' : 'Add New Medical Record',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<MedicalRecordFormCubit, MedicalRecordFormState>(
        listener: (context, state) {
          if (state.status == FormSubmissionStatus.success) {
            context.read<MedicalRecordBloc>().add(FetchMedicalRecords());
            Navigator.of(context).pop();
          } else if (state.status == FormSubmissionStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.errorMessage ?? 'Submission Failed'),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state.status == FormSubmissionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _FormBody(isEditMode: isEditMode);
        },
      ),
      bottomNavigationBar: _SubmitButton(isEditMode: isEditMode),
    );
  }
}

class _FormBody extends StatelessWidget {
  final bool isEditMode;
  const _FormBody({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _TitleInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.title
                  : null),
          const SizedBox(height: 16),
          _DiseaseNameInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.diseaseName
                  : null),
          const SizedBox(height: 16),
          _DiseaseHistoryInput(
              initialValue: isEditMode
                  ? context.read<MedicalRecordFormCubit>().state.diseaseHistory
                  : null),
          const SizedBox(height: 24),
          const _FieldLabel('Patient with Special Consideration'),
          _SpecialConsiderationCheckboxes(),
          const SizedBox(height: 24),
          // NOTE: Treatment Info disabled, need to confirm with PM
          // const Text(
          //   'Treatment Information',
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 16),
          // _TreatmentInfoInput(
          //     initialValue: isEditMode
          //         ? context.read<MedicalRecordFormCubit>().state.treatmentInfo
          //         : null),
          // const SizedBox(height: 24),
          _FilePicker(),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  final String? initialValue;
  const _TitleInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Title *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'e.g. Annual Checkup',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<MedicalRecordFormCubit>().titleChanged(value),
        ),
      ],
    );
  }
}

class _DiseaseNameInput extends StatelessWidget {
  final String? initialValue;
  const _DiseaseNameInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Disease Name *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'e.g. Diphtheria, Pneumonia, etc.',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) =>
              context.read<MedicalRecordFormCubit>().diseaseNameChanged(value),
        ),
      ],
    );
  }
}

class _DiseaseHistoryInput extends StatelessWidget {
  final String? initialValue;
  const _DiseaseHistoryInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Disease History Description *'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'Write your disease history here...',
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 10,
          onChanged: (value) => context
              .read<MedicalRecordFormCubit>()
              .diseaseHistoryChanged(value),
        ),
      ],
    );
  }
}

class _SpecialConsiderationCheckboxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
      builder: (context, state) {
        return Wrap(
          spacing: 8.0,
          runSpacing: 0.0,
          children: MedicalRecordFormCubit.predefinedSpecialConsiderations
              .map((option) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width / 2) - 24,
              child: CheckboxListTile(
                title: Text(option),
                value: state.specialConsiderations.contains(option),
                onChanged: (bool? value) {
                  context
                      .read<MedicalRecordFormCubit>()
                      .toggleSpecialConsideration(option);
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: Const.aqua,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TreatmentInfoInput extends StatelessWidget {
  final String? initialValue;
  const _TreatmentInfoInput({this.initialValue});

  @override
  Widget build(BuildContext context) {
    // --- CHANGED ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Treatment Info'),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(
            hintText: 'Describe treatment plan...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) => context
              .read<MedicalRecordFormCubit>()
              .treatmentInfoChanged(value),
        ),
      ],
    );
  }
}

class _FilePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Medical Report File'),
        BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Pick File'),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png'],
                    );
                    if (!context.mounted) {
                      log('Context not mounted after file picker',
                          name: 'MedicalRecordFormPage');
                      return;
                    }
                    if (result != null && result.files.single.path != null) {
                      context
                          .read<MedicalRecordFormCubit>()
                          .filePicked(File(result.files.single.path!));
                    }
                  },
                ),
                if (state.pickedFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('File: ${p.basename(state.pickedFile!.path)}'),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isEditMode;
  const _SubmitButton({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalRecordFormCubit, MedicalRecordFormState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: state.isFormValid
                ? () => context.read<MedicalRecordFormCubit>().submitForm()
                : null,
            child: Text(
              state.status == FormSubmissionStatus.loading
                  ? 'Submitting...'
                  : (isEditMode ? 'Update' : 'Submit'),
            ),
          ),
        );
      },
    );
  }
}
