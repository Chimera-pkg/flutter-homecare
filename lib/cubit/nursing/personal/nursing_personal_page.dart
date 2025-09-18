import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/pages/nursing_add_concern_page.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_case_detail_page.dart';
import 'package:m2health/cubit/nursing/personal/nursing_personal_cubit.dart';
import 'package:m2health/utils.dart'; // Import the utils file
import 'package:m2health/widgets/authentication_required_dialog.dart';
import 'nursing_personal_cubit.dart';
import 'nursing_personal_state.dart';
import 'package:m2health/cubit/nursing/pages/nursing_add_issue_page.dart';
import 'package:intl/intl.dart';

class PersonalPage extends StatefulWidget {
  final String title; // Add title parameter
  final String serviceType; // Add serviceType parameter
  final Function(dynamic)? onItemTap; // Add onItemTap parameter (optional)

  const PersonalPage({
    Key? key,
    required this.title, // Add title to constructor
    required this.serviceType,
    this.onItemTap,
  }) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<NursingPersonalCubit>()
        .loadPersonalDetails(serviceType: widget.serviceType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nurse Services Case",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: BlocConsumer<NursingPersonalCubit, NursingPersonalState>(
                listener: (context, state) => {
                  if (state is NursingPersonalUnauthenticated)
                    showAuthenticationRequiredDialog(context)
                },
                builder: (context, state) {
                  if (state is NursingPersonalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NursingPersonalLoaded) {
                    final issues = state.issues;
                    // Sort issues by latest date first
                    issues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<NursingPersonalCubit>()
                            .loadPersonalDetails(
                                serviceType: widget.serviceType);
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
                                final formattedDate =
                                    DateFormat('EEEE, MMM d, yyyy').format(
                                        issue.createdAt); // Format the date

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PersonalCaseDetailPage(
                                          personalCase: issue.toJson(),
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
                                                  context
                                                      .read<
                                                          NursingPersonalCubit>()
                                                      .deleteIssue(index);
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(issue.description),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Created on: $formattedDate', // Display the formatted date
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          if (issue.images.isNotEmpty)
                                            Wrap(
                                              spacing: 8.0,
                                              runSpacing: 8.0,
                                              children:
                                                  issue.images.map((image) {
                                                return Image.network(
                                                  getImageUrl(image),
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
                  } else {
                    return const Center(child: Text('Failed to load issues'));
                  }
                },
              ),
            ),
            BlocBuilder<NursingPersonalCubit, NursingPersonalState>(
              builder: (context, state) {
                final bool hasIssues =
                    state is NursingPersonalLoaded && state.issues.isNotEmpty;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          showAddConcernPage(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF35C5CF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Add an Issue',
                          style:
                              TextStyle(color: Color(0xFF35C5CF), fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: hasIssues
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NursingAddIssuePage(
                                      issue: state.issues.first,
                                      serviceType: widget.serviceType,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              hasIssues ? Const.tosca : const Color(0xFFB2B9C4),
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
