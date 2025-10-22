import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/route/app_routes.dart';
import '../../../widgets/precision_widgets.dart';
import '../../../bloc/nutrition_assessment_cubit.dart';

class BiomarkerUploadScreen extends StatefulWidget {
  const BiomarkerUploadScreen({super.key});

  @override
  State<BiomarkerUploadScreen> createState() => _BiomarkerUploadScreenState();
}

class _BiomarkerUploadScreenState extends State<BiomarkerUploadScreen> {
  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    final path = result.files.single.path;
    if (path != null && mounted) {
      final file = File(path);
      context.read<NutritionAssessmentCubit>().addFile(file);
    }
  }

  void _connectWearableDevice() {
    // Simulate connecting to wearable device
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to wearable device...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitAssessment() async {
    await context.read<NutritionAssessmentCubit>().submitAssessment();

    if (mounted) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Success!'),
          content: const Text(
              'Your Precision Nutrition Assessment has been submitted successfully. Our experts will review your information and create a personalized plan for you.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                GoRouter.of(context)
                    .goNamed(AppRoutes.precisionNutritionAssessmentDetail);
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Biomarker Upload'),
      body: BlocBuilder<NutritionAssessmentCubit, NutritionAssessmentState>(
        builder: (context, state) {
          final existingUrls = state.fileUrls;
          final newFiles = state.files;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Text(
                          'Upload your medical records and connect devices',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'This helps us create a more accurate and personalized nutrition plan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // File Upload Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 48,
                                color: Color(0xFF00B4D8),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Upload Medical Records',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Upload PDF, images, or other medical documents',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SecondaryButton(
                                text: 'Choose File',
                                icon: Icons.file_upload,
                                onPressed: _pickFiles,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Wearable Device Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.watch,
                                size: 48,
                                color: Color(0xFF00B4D8),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Connect Wearable Device',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sync data from your smartwatch, fitness tracker, or other devices',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              SecondaryButton(
                                text: 'Connect Wearable Device',
                                icon: Icons.bluetooth,
                                onPressed: _connectWearableDevice,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Uploaded Files Section
                        if (existingUrls.isNotEmpty || newFiles.isNotEmpty) ...[
                          const Text(
                            'Uploaded Files',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                ...existingUrls.map((url) {
                                  final fileName = url.split('/').last;
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.cloud_done,
                                      color: Colors.green,
                                    ),
                                    title: Text(fileName,
                                        style: const TextStyle(fontSize: 14)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => context
                                          .read<NutritionAssessmentCubit>()
                                          .removeFileUrl(url),
                                    ),
                                  );
                                }),
                                ...newFiles.map((file) {
                                  final fileName = p.basename(file.path);
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.description,
                                      color: Color(0xFF00B4D8),
                                    ),
                                    title: Text(fileName,
                                        style: const TextStyle(fontSize: 14)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => context
                                          .read<NutritionAssessmentCubit>()
                                          .removeFile(file),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),

                // Submit Button
                PrimaryButton(
                  text: 'Submit Assessment',
                  onPressed: state.isLoading ? null : _submitAssessment,
                  isLoading: state.isLoading,
                ),

                // Error Message
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
