import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:m2health/features/medical_record/domain/entities/medical_record.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_bloc.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_event.dart';
import 'package:m2health/features/medical_record/presentation/bloc/medical_record_state.dart';
import 'package:m2health/core/presentation/views/file_viewer_page.dart';
import 'package:m2health/features/medical_record/presentation/pages/medical_record_form_page.dart';

class MedicalRecordDetailPage extends StatelessWidget {
  final MedicalRecord record;

  const MedicalRecordDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicalRecordBloc, MedicalRecordState>(
      listener: (context, state) {
        if (state.deleteStatus == DeleteStatus.loading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Deleting...')));
        } else if (state.deleteStatus == DeleteStatus.success) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context);
        } else if (state.deleteStatus == DeleteStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.deleteError ?? 'Failed to delete')));
        }
      },
      child: Scaffold(
        backgroundColor: Const.grayLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            record.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MedicalRecordFormPage(recordToEdit: record),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernCard(
                title: 'Patient Current Status',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Disease Name', record.diseaseName),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                        'Disease History', record.diseaseHistory ?? 'N/A'),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      'Special Consideration',
                      record.specialConsideration ?? 'None',
                      isChip: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (record.fileUrl != null && record.fileUrl!.isNotEmpty)
                _buildModernCard(
                  title: 'Records File',
                  content: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC3545),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          record.fileUrl!.toLowerCase().endsWith('.pdf')
                              ? Icons.picture_as_pdf
                              : Icons.image,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FileViewerPage(url: record.fileUrl),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF28A745)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'View Only',
                                  style: TextStyle(
                                    color: Color(0xFF28A745),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  _launchUrl(context, record.fileUrl);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Color(0xFF28A745)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text(
                                  'Download',
                                  style: TextStyle(
                                    color: Color(0xFF28A745),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String? url) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File URL is not available.')),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              context
                  .read<MedicalRecordBloc>()
                  .add(DeleteMedicalRecordEvent(record));
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF212529),
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isChip = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 8),
        if (isChip)
          Builder(builder: (context) {
            final conditions =
                value.split(', ').where((s) => s.isNotEmpty).toList();

            if (conditions.isEmpty ||
                (conditions.length == 1 && conditions[0] == 'None')) {
              return _buildChip('None');
            }

            return Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children:
                  conditions.map((condition) => _buildChip(condition)).toList(),
            );
          })
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6C757D),
              height: 1.5,
            ),
          ),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDEE2E6)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF495057),
        ),
      ),
    );
  }
}
