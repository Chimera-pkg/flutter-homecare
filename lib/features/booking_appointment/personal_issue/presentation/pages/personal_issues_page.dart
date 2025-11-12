import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_cubit.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/add_issue_page.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/pages/personal_issue_detail_page.dart';

class PersonalIssuesPage extends StatefulWidget {
  final Function(List<PersonalIssue>) onIssuesSelected;

  const PersonalIssuesPage({
    super.key,
    required this.onIssuesSelected,
  });

  @override
  State<PersonalIssuesPage> createState() => _PersonalIssuesPageState();
}

class _PersonalIssuesPageState extends State<PersonalIssuesPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<PersonalIssuesCubit>().loadNursingIssues();
  }

  void _onClickNext(BuildContext context, List<PersonalIssue> issues) {
    widget.onIssuesSelected(issues);
  }

  String getTitle() {
    final serviceType = context.read<PersonalIssuesCubit>().state.serviceType;
    switch (serviceType) {
      case 'nursing':
        return 'Nurse Services Case';
      case 'pharmacy':
        return 'Pharmacist Services Case';
      case 'radiology':
        return 'Radiologist Services Case';
      default:
        return 'Service Case';
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int issueId) {
    final cubit = context.read<PersonalIssuesCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Issue'),
          content: const Text('Are you sure you want to delete this issue?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.deleteIssue(issueId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 0.0),
            const Column(
              children: [
                Center(
                  child: Text(
                    'Tell Us Your Concern',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Const.aqua,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: BlocBuilder<PersonalIssuesCubit, PersonalIssuesState>(
                builder: (context, state) {
                  if (state.loadStatus == ActionStatus.loading ||
                      state.loadStatus == ActionStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.loadStatus == ActionStatus.error) {
                    return Center(
                        child: Text(
                            'Failed to load issues: ${state.loadErrorMessage}'));
                  }

                  if (state.loadStatus == ActionStatus.success) {
                    final issues = state.issues;
                    log('Loaded Issues: ${issues}', name: 'PersonalIssuesPage');
                    return RefreshIndicator(
                      color: Const.aqua,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        _loadData();
                      },
                      child: issues.isEmpty
                          ? const Center(
                              child: Text(
                                'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: issues.length,
                              itemBuilder: (context, index) {
                                final issue = issues[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PersonalIssueDetailPage(
                                          issue: issue,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                issue.title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  _showDeleteConfirmationDialog(
                                                      context, issue.id!);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(issue.description),
                                          const SizedBox(height: 8),
                                          if (issue.images.isNotEmpty ||
                                              issue.imageUrls.isNotEmpty)
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children:
                                                  // Render remote images
                                                  issue.imageUrls
                                                      .map((imageUrl) {
                                                return Image.network(
                                                  imageUrl,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/no_img.jpg',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  }
                  // Fallback
                  return const Center(child: Text('Failed to load issues'));
                },
              ),
            ),
            BlocBuilder<PersonalIssuesCubit, PersonalIssuesState>(
              builder: (context, state) {
                final bool hasIssues =
                    state.loadStatus == ActionStatus.success &&
                        state.issues.isNotEmpty;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          final issuesCubit =
                              context.read<PersonalIssuesCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: issuesCubit,
                                child: const AddIssuePage(),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF35C5CF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Add an Issue',
                          style: TextStyle(color: Const.aqua, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: hasIssues
                            ? () => _onClickNext(context, state.issues)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              hasIssues ? Const.aqua : const Color(0xFFB2B2B2),
                          disabledBackgroundColor: const Color(0xFFB2B9C4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
