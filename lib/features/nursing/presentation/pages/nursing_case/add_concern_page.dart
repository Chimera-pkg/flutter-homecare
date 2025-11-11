import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/nursing/domain/entities/personal_issue.dart';
import 'package:m2health/features/nursing/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/features/nursing/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/features/personal/personal_cubit.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'dart:io';

class AddConcernPage extends StatefulWidget {
  const AddConcernPage({super.key});
  @override
  State<AddConcernPage> createState() => _AddConcernPageState();
}

class _AddConcernPageState extends State<AddConcernPage> {
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<File?> _images = List.filled(3, null); // To hold up to 3 images

  Future<void> setImageAt(int index, File? image) async {
    setState(() {
      _images[index] = image;
    });
  }

  void _submitData() {
    final issueTitle = _issueTitleController.text;
    final description = _descriptionController.text;

    if (issueTitle.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Issue title and description are required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newIssue = PersonalIssue(
      title: issueTitle,
      description: description,
      images: _images.whereType<File>().toList(),
      imageUrls: const [], // Set imageUrls to empty list
    );

    context.read<NursingCaseBloc>().add(AddPersonalIssueEvent(newIssue));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _issueTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add an Issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tell us your concerns',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 338,
              height: 50,
              child: TextField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  hintText: 'Issue Title',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 338,
              height: 129,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText:
                      'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                spacing: 30,
                children: [
                  ...List.generate(_images.length, (index) {
                    return ImagePreview(
                      imageFile: _images[index],
                      onChooseImage: (image) => setImageAt(index, image),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          width: 352,
          height: 58,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Const.aqua,
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showAddConcernPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider.value(
      value: context.read<PersonalCubit>(),
      child: const AddConcernPage(),
    ),
  );
}
