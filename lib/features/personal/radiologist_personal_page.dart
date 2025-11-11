import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/personal/personal_case_detail_page.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/core/presentation/widgets/add_concern_page.dart';
import 'package:m2health/core/presentation/widgets/image_preview.dart';
import 'personal_cubit.dart';
import 'personal_state.dart';
import 'package:m2health/core/presentation/widgets/radiologist_add_issue_page.dart';
import 'package:intl/intl.dart';

class RadiologistPersonalPage extends StatefulWidget {
  final String title;
  final String serviceType;
  final Function(dynamic)? onItemTap;

  const RadiologistPersonalPage({
    Key? key,
    required this.title,
    required this.serviceType,
    this.onItemTap,
  }) : super(key: key);

  @override
  _RadiologistPersonalPageState createState() =>
      _RadiologistPersonalPageState();
}

class _RadiologistPersonalPageState extends State<RadiologistPersonalPage> {
  @override
  void initState() {
    super.initState();
    context.read<PersonalCubit>().loadPersonalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Radiologist Services Case",
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
                    'Tell Us Your Radiology Concern',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload your medical images and describe your symptoms\nfor professional radiological analysis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
            Expanded(
              child: BlocBuilder<PersonalCubit, PersonalState>(
                builder: (context, state) {
                  if (state is PersonalLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PersonalLoaded) {
                    final issues = state.issues;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PersonalCubit>().loadPersonalDetails();
                      },
                      child: issues.isEmpty
                          ? const Center(
                              child: Text(
                                'No radiology cases added yet.\nPlease add your medical images and symptoms\nso our radiologists can assist you.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: issues.length,
                              itemBuilder: (context, index) {
                                final issue = issues[index];
                                final formattedDate =
                                    DateFormat('EEEE, MMM d, yyyy')
                                        .format(issue.createdAt);

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
                                            children: [
                                              Icon(Icons.medical_services,
                                                  color: Color(0xFF35C5CF)),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  issue.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                formattedDate,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            issue.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF35C5CF)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'Radiology Case',
                                                  style: TextStyle(
                                                    color: Color(0xFF35C5CF),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    return const Center(
                        child: Text('Failed to load radiology cases'));
                  }
                },
              ),
            ),
            BlocBuilder<PersonalCubit, PersonalState>(
              builder: (context, state) {
                final bool hasIssues =
                    state is PersonalLoaded && state.issues.isNotEmpty;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 352,
                      height: 58,
                      child: OutlinedButton(
                        onPressed: () {
                          showRadiologistConcernPage(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF35C5CF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Add Radiology Case',
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
                                    builder: (context) =>
                                        RadiologistAddIssuePage(
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

void showRadiologistConcernPage(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => BlocProvider.value(
      value: context.read<PersonalCubit>(),
      child: RadiologistAddConcernPage(),
    ),
  );
}

class RadiologistAddConcernPage extends StatefulWidget {
  @override
  _RadiologistAddConcernPageState createState() =>
      _RadiologistAddConcernPageState();
}

class _RadiologistAddConcernPageState extends State<RadiologistAddConcernPage> {
  TextEditingController _issueTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _symptomsController = TextEditingController();

  final List<File?> _images = List.filled(1, null);

  Future<void> setImageAt(int index, File? image) async {
    setState(() {
      _images[index] = image;
    });
  }

  Future<void> _submitData() async {
    final issueTitle = _issueTitleController.text;
    final description = _descriptionController.text;
    final symptoms = _symptomsController.text;

    if (issueTitle.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Case title and description are required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Create FormData for radiologist case
      FormData formData = FormData.fromMap({
        "user_id": 1,
        "title": issueTitle,
        "description": description,
        "symptoms": symptoms,
        "mobility_status": "ambulatory", // Default for radiology
        "related_health_record_id": 33,
        "add_on": "radiology_analysis",
        "estimated_budget": 1500, // Higher budget for radiology services
        "case_type": "radiology",
      });

      // Add medical images to FormData
      for (final image in _images.where((img) => img != null)) {
        formData.files.add(
          MapEntry(
            "images[]",
            await MultipartFile.fromFile(
              image!.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      print('Sending radiologist case with data:');
      print('Headers: Bearer $token');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files}');

      final response = await Dio().post(
        '${Const.API_PERSONAL_CASES}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Radiology case submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        // Refresh the personal page
        context.read<PersonalCubit>().loadPersonalDetails();
      } else {
        throw Exception('Failed to submit data: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting case: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Radiology Case',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
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
                  'Describe your radiology concern',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                  hintText: 'Case Title (e.g., Chest X-Ray Analysis)',
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
              height: 100,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Describe your medical concern in detail...',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 338,
              height: 80,
              child: TextField(
                controller: _symptomsController,
                decoration: InputDecoration(
                  hintText:
                      'Current symptoms (e.g., chest pain, shortness of breath)...',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload Medical Images',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Upload X-rays, CT scans, MRI, or other medical images',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ImagePreview(
                    imageFile: _images[0],
                    onChooseImage: (image) => setImageAt(0, image),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: 352,
          height: 58,
          child: ElevatedButton(
            onPressed: _submitData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF35C5CF),
            ),
            child: const Text(
              'Add Case',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
