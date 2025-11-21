import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/bloc/screening_report/screening_report_cubit.dart';
import 'package:m2health/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreeningReportSubmissionPage extends StatelessWidget {
  final int appointmentId;

  const ScreeningReportSubmissionPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScreeningReportCubit(
        appointmentService: sl(),
        dio: sl(),
      )..fetchReports(appointmentId),
      child: const ScreeningReportSubmissionView(),
    );
  }
}

class ScreeningReportSubmissionView extends StatelessWidget {
  const ScreeningReportSubmissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Lab Reports',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocConsumer<ScreeningReportCubit, ScreeningReportState>(
        listener: (context, state) {
          if (state is ScreeningReportActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            if (state.action == ScreeningReportAction.finalize) {
              context.pop(true); // Return success to caller
            }
          } else if (state is ScreeningReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ScreeningReportLoading &&
              state is! ScreeningReportLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          AppointmentEntity? appointment;
          if (state is ScreeningReportLoaded) {
            appointment = state.appointment;
          } else if (state is ScreeningReportActionSuccess) {
            appointment = state.updatedAppointment;
          }

          if (appointment == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final screeningData = appointment.screeningRequestData;
          if (screeningData == null) {
            return const Center(child: Text('Invalid screening data'));
          }

          final reports = screeningData.reports;
          final isFinalized = screeningData.status == 'report_ready';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please upload all necessary lab reports before marking them as ready.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Uploaded Reports (${reports.length})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: reports.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.upload_file,
                                  size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text('No reports uploaded yet',
                                  style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: reports.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            return Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side:
                                      BorderSide(color: Colors.grey.shade200)),
                              child: ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Const.aqua.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.picture_as_pdf,
                                      color: Const.aqua),
                                ),
                                title: Text(
                                  'Report #${report.id}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(report.file.extname.toUpperCase()),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.visibility_outlined,
                                          color: Colors.grey),
                                      onPressed: () async {
                                        final uri = Uri.parse(report.file.url);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      },
                                    ),
                                    if (!isFinalized)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  const Text('Delete Report?'),
                                              content: const Text(
                                                  'Are you sure you want to delete this report?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(ctx),
                                                    child:
                                                        const Text('Cancel')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      context
                                                          .read<
                                                              ScreeningReportCubit>()
                                                          .deleteReport(
                                                              appointment!.id!,
                                                              report.id);
                                                    },
                                                    child: const Text('Delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red))),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
                if (!isFinalized) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'pdf',
                            'jpg',
                            'png',
                            'jpeg',
                            'doc',
                            'docx'
                          ],
                        );

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          if (context.mounted) {
                            context.read<ScreeningReportCubit>().uploadReport(
                                appointment!.id!, screeningData.id, file);
                          }
                        }
                      },
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Upload New Report'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Const.aqua),
                        foregroundColor: Const.aqua,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: reports.isEmpty
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Finalize Reports?'),
                                  content: const Text(
                                      'Once marked as ready, reports will be sent to the patient and you cannot modify them anymore.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          context
                                              .read<ScreeningReportCubit>()
                                              .markReady(appointment!.id!,
                                                  screeningData.id);
                                        },
                                        child: const Text('Confirm',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Const.aqua,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text('Mark Reports as Ready'),
                    ),
                  ),
                ] else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Reports Finalized',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
