import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_bloc.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_event.dart';
import 'package:m2health/cubit/nursing/presentation/bloc/nursing_case/nursing_case_state.dart';
import 'package:m2health/cubit/nursing/presentation/pages/add_concern_page.dart';
import 'package:m2health/cubit/nursing/presentation/pages/nursing_case_form_page.dart';

class NursingConcernPage extends StatefulWidget {
  final String title;
  final String serviceType;

  const NursingConcernPage({
    Key? key,
    required this.title,
    required this.serviceType,
  }) : super(key: key);

  @override
  _NursingConcernPageState createState() => _NursingConcernPageState();
}

class _NursingConcernPageState extends State<NursingConcernPage> {
  @override
  void initState() {
    super.initState();
    context.read<NursingCaseBloc>().add(GetNursingCasesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nurse Services Case",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              child: BlocBuilder<NursingCaseBloc, NursingCaseState>(
                builder: (context, state) {
                  if (state is NursingCaseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NursingCaseLoaded) {
                    final issues = state.nursingCases;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<NursingCaseBloc>()
                            .add(GetNursingCasesEvent());
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
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          issue.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(issue.description),
                                        const SizedBox(height: 8),
                                        if (issue.images.isNotEmpty)
                                          Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children: issue.images.map((image) {
                                              return Image.file(
                                                image,
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
                                );
                              },
                            ),
                    );
                  } else if (state is NursingCaseError) {
                    return Center(
                        child: Text('Failed to load issues: ${state.message}'));
                  } else {
                    return const Center(child: Text('Failed to load issues'));
                  }
                },
              ),
            ),
            BlocBuilder<NursingCaseBloc, NursingCaseState>(
              builder: (context, state) {
                final bool hasIssues =
                    state is NursingCaseLoaded && state.nursingCases.isNotEmpty;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddConcernPage(),
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
                                    builder: (context) => NursingCaseFormPage(),
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
