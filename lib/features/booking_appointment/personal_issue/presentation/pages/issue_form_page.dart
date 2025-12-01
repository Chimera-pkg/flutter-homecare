import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';

class IssueFormPage extends StatefulWidget {
  final PersonalIssue? issue;
  final int maxImages = 3;

  const IssueFormPage({super.key, this.issue});

  @override
  State<IssueFormPage> createState() => _IssueFormPageState();
}

class _IssueFormPageState extends State<IssueFormPage> {
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late List<dynamic> _imageSlots;
  bool get isEditMode => widget.issue != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _issueTitleController.text = widget.issue!.title;
      _descriptionController.text = widget.issue!.description;
      _imageSlots = List<dynamic>.from(widget.issue!.imageUrls);
      if (_imageSlots.length < widget.maxImages) {
        _imageSlots
            .addAll(List.filled(widget.maxImages - _imageSlots.length, null));
      }
    } else {
      _imageSlots = List.filled(widget.maxImages, null);
    }
  }

  void _submitData() async {
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

    final serviceType = context.read<PersonalIssuesCubit>().state.serviceType;

    if (isEditMode) {
      final Map<int, File> newImages = {};
      for (int i = 0; i < _imageSlots.length; i++) {
        if (_imageSlots[i] is File) {
          newImages[i] = _imageSlots[i] as File;
        }
      }
      final issueData = PersonalIssue(
        id: widget.issue!.id,
        type: serviceType,
        title: issueTitle,
        description: description,
        newImages: newImages,
        imageUrls: widget.issue!.imageUrls,
      );
      await context
          .read<PersonalIssuesCubit>()
          .updateIssue(widget.issue!.id!, issueData);
    } else {
      final List<File> images = _imageSlots.whereType<File>().toList();
      final newIssue = PersonalIssue(
        type: serviceType,
        title: issueTitle,
        description: description,
        images: images,
      );
      await context.read<PersonalIssuesCubit>().addIssue(newIssue);
    }
  }

  @override
  void dispose() {
    _issueTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonalIssuesCubit, PersonalIssuesState>(
      listenWhen: (previous, current) =>
          previous.createStatus != current.createStatus ||
          previous.updateStatus != current.updateStatus,
      listener: (context, state) {
        if (state.createStatus == ActionStatus.success ||
            state.updateStatus == ActionStatus.success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditMode
                  ? 'Issue updated successfully'
                  : 'Issue added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.createStatus == ActionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.createErrorMessage ?? 'Failed to add issue',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.updateStatus == ActionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.updateErrorMessage ?? 'Failed to update issue',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditMode ? 'Edit Issue' : 'Add an Issue',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tell us your concerns',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
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
                const SizedBox(height: 10.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText:
                        'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
                    hintStyle:
                        const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16.0),
                const Text('Images',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(widget.maxImages, (index) {
                  dynamic imageSource = _imageSlots[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ImagePreview(
                      initialImageUrl:
                          imageSource is String ? imageSource : null,
                      imageFile: imageSource is File ? imageSource : null,
                      onChooseImage: (file) {
                        if (file != null) {
                          setState(() {
                            _imageSlots[index] = file;
                          });
                        }
                      },
                    ),
                  );
                }),
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
                onPressed: (state.createStatus == ActionStatus.loading ||
                        state.updateStatus == ActionStatus.loading)
                    ? null
                    : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.aqua,
                ),
                child: (state.createStatus == ActionStatus.loading ||
                        state.updateStatus == ActionStatus.loading)
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text(
                        isEditMode ? 'Update' : 'Add',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
