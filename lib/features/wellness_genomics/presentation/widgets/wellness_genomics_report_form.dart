import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:m2health/features/wellness_genomics/presentation/bloc/wellness_genomics_cubit.dart';
import 'package:m2health/features/wellness_genomics/presentation/bloc/wellness_genomics_state.dart';
import 'package:m2health/utils.dart';

class WellnessGenomicsReportForm extends StatelessWidget {
  const WellnessGenomicsReportForm({super.key});

  Future<void> _pickAndUploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'pdf'],
    );
    log('File picked: ${result?.files.single.name}',
        name: 'WellnessGenomicsReportForm');

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      await context.read<WellnessGenomicsCubit>().uploadReport(file);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Report'),
          content:
              const Text('Are you sure you want to delete this report file?'),
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
                context.read<WellnessGenomicsCubit>().delete();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WellnessGenomicsCubit, WellnessGenomicsState>(
      listener: (context, state) {
        // The listener is more specific now
        if (state is WellnessGenomicsError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: _buildUploadWidget(context, state),
        );
      },
    );
  }

  Widget _buildUploadWidget(BuildContext context, WellnessGenomicsState state) {
    if (state is WellnessGenomicsUploading) {
      return _buildUploadingState(context, state);
    }
    if (state is WellnessGenomicsReady) {
      final report = state.data.fullReportPath;
      if (report != null && report.isNotEmpty) {
        return _buildReadyState(context, state);
      }
    }
    if (state is WellnessGenomicsLoading) {
      return _buildLoadingState(context);
    }
    return _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('empty'),
      onTap: () => _pickAndUploadFile(context),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF35C5CF)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_upload_outlined,
                  size: 28, color: Color(0xFF35C5CF)),
              const SizedBox(height: 4),
              Text(
                'Tap to upload your report',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      key: const ValueKey('loading'),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF35C5CF)),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF35C5CF),
        ),
      ),
    );
  }

  Widget _buildUploadingState(
      BuildContext context, WellnessGenomicsUploading state) {
    return Container(
      key: const ValueKey('uploading'),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.fileName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF35C5CF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyState(BuildContext context, WellnessGenomicsReady state) {
    return GestureDetector(
      key: const ValueKey('ready'),
      onTap: () {
        Utils.openPDF(context, state.data.fullReportPath!);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.data.fullReportPath!.split('/').last,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Color(0xFF35C5CF), size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Ready',
                        style: TextStyle(
                            color: Color(0xFF35C5CF),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ],
        ),
      ),
    );
  }
}
