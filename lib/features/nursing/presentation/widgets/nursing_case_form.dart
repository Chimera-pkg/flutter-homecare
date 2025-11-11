import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/features/nursing/domain/entities/nursing_issue.dart';
import 'package:m2health/features/nursing/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/features/nursing/presentation/bloc/nursing_case/nursing_case_event.dart';

class NursingCaseForm extends StatefulWidget {
  const NursingCaseForm({super.key});

  @override
  State<NursingCaseForm> createState() => _NursingCaseFormState();
}

class _NursingCaseFormState extends State<NursingCaseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              //   final nursingCase = NursingCase(
              //     title: _titleController.text,
              //     description: _descriptionController.text,
              //     images: [],
              //   );
              //   context
              //       .read<NursingCaseBloc>()
              //       .add(CreateNursingCaseEvent(nursingCase));
              // }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
