import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/pages/screening_report_submission_page.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderAppointmentDetailPage extends StatelessWidget {
  final int appointmentId;
  const ProviderAppointmentDetailPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderAppointmentDetailCubit(sl())
        ..fetchProviderAppointmentById(appointmentId),
      child: const ProviderAppointmentDetailView(),
    );
  }
}

class ProviderAppointmentDetailView extends StatelessWidget {
  const ProviderAppointmentDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Detail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: BlocBuilder<ProviderAppointmentDetailCubit,
          ProviderAppointmentDetailState>(
        builder: (context, state) {
          if (state is ProviderAppointmentDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProviderAppointmentDetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is ProviderAppointmentDetailLoaded) {
            final appointment = state.appointment;
            return _buildAppointmentDetails(context, appointment);
          }
          return const Center(child: Text('No appointment details found.'));
        },
      ),
    );
  }

  Widget _buildAppointmentDetails(
      BuildContext context, AppointmentEntity appointment) {
    final localStartTime = appointment.startDatetime.toLocal();
    final localEndTime = appointment.endDatetime?.toLocal();

    final date = DateFormat('EEEE, MMMM dd, yyyy').format(localStartTime);

    final startHour = DateFormat('hh:mm a').format(localStartTime);
    final endHour = localEndTime != null
        ? DateFormat('hh:mm a').format(localEndTime)
        : null;
    final hour = endHour != null ? '$startHour - $endHour' : startHour;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _PatientHeader(appointment: appointment),
              const SizedBox(height: 24),
              _buildSectionTitle('Schedule Appointment'),
              _InfoRow(icon: Icons.calendar_today_outlined, text: date),
              _InfoRow(icon: Icons.access_time_outlined, text: hour),
              const SizedBox(height: 24),
              _buildSectionTitle('Patient Information'),
              _PatientInfoTable(appointment: appointment),
              if (appointment.type == 'screening')
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 24),
                  _buildSectionTitle('Lab Test Information'),
                  _ScreeningRequestInfo(appointment: appointment),
                ])
              else
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 24),
                  _buildSectionTitle('Personal Case'),
                  _PersonalCaseInfo(appointment: appointment),
                ]),
            ],
          ),
        ),
        _ActionButtons(appointment: appointment),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PatientHeader({required this.appointment});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'accepted':
        return const Color(0xFF18B23C);
      case 'pending':
        return const Color(0xFFE59500);
      case 'cancelled':
        return const Color(0xFFED3443);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(appointment.status);
    final patient = appointment.patientProfile!;
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              (patient.avatar != null) ? NetworkImage(patient.avatar!) : null,
          child: (patient.avatar == null)
              ? const Icon(Icons.person, size: 30, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patient.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      patient.homeAddress ?? 'Unknown Location',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  appointment.status.toTitleCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _PatientInfoTable extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PatientInfoTable({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final patient = appointment.patientProfile!;
    final gender = patient.gender != null
        ? patient.gender!.toTitleCase()
        : 'Not Specified';

    return Column(
      children: [
        _buildInfoRow('Full Name', patient.name),
        _buildInfoRow('Age', patient.age.toString()),
        _buildInfoRow('Gender', gender),
        _buildInfoRow('Weight', '${patient.weight} kg'),
        _buildInfoRow('Height', '${patient.height} cm'),
        _buildInfoRow('Address', patient.homeAddress),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
          const Text(': ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }
}

class _ScreeningRequestInfo extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ScreeningRequestInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final screeningData = appointment.screeningRequestData;
    if (screeningData == null) {
      return const Text('No screening request data available.');
    }
    final reports = screeningData.reports;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Const.aqua.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                screeningData.status.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(
                  color: Const.aqua,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Requested Services: ',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...screeningData.services.asMap().entries.map(
          (entry) {
            final index = entry.key + 1;
            final service = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '$index. ${service.name}',
                style: const TextStyle(fontSize: 14),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        if (reports.isNotEmpty && screeningData.status == 'report_ready') ...[
          const Text(
            'Reports',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...reports.map((report) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.red),
                  title: Text('Report #${report.id}'),
                  subtitle: Text(report.file.extname.toUpperCase()),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      final uri = Uri.parse(report.file.url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                  ),
                ),
              ))
        ]
      ],
    );
  }
}

class _PersonalCaseInfo extends StatelessWidget {
  final AppointmentEntity appointment;
  const _PersonalCaseInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    List<String>? servicesList;
    List<PersonalIssue>? issues;

    if (appointment.providerType == 'nurse') {
      final personalCase = appointment.nursingCase;
      servicesList = personalCase?.addOnServices.map((e) => e.name).toList();
      issues = personalCase?.issues;
    } else if (appointment.providerType == 'pharmacist') {
      final personalCase = appointment.pharmacyCase;
      servicesList = personalCase?.addOnServices.map((e) => e.name).toList();
      issues = personalCase?.issues;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (servicesList != null && servicesList.isNotEmpty) ...[
          const Text(
            'Services:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ...servicesList.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final name = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                '$index. $name',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              ),
            );
          }),
        ] else ...[
          const Text.rich(
            TextSpan(
              text: 'Services: ',
              style: TextStyle(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: 'None',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (issues != null && issues.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: issues.length,
            itemBuilder: (context, issueIndex) {
              final issue = issues![issueIndex];
              final images = issue.imageUrls;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    issue.description,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 4),
                  if (images.isNotEmpty)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, imageIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(images[imageIndex]),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        "Created on: ${DateFormat('MMM d, y, HH:yy').format(issue.createdAt!)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          )
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final AppointmentEntity appointment;
  const _ActionButtons({required this.appointment});

  @override
  Widget build(BuildContext context) {
    void refreshAppointmentDetail() {
      context
          .read<ProviderAppointmentDetailCubit>()
          .fetchProviderAppointmentById(appointment.id!);
    }

    if (appointment.status.toLowerCase() == 'cancelled') {
      return const SizedBox.shrink();
    }

    if (appointment.screeningRequestData != null &&
        appointment.type == 'screening' &&
        appointment.screeningRequestData!.status == 'report_ready') {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 10)
        ],
      ),
      child: BlocListener<ProviderAppointmentCubit, ProviderAppointmentState>(
        listener: (context, state) {
          if (state is ProviderAppointmentChangeSucceed) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(state.message ?? 'Appointment updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            refreshAppointmentDetail();
          } else if (state is ProviderAppointmentError) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        },
        child: Builder(builder: (context) {
          final status = appointment.status.toLowerCase();
          final isScreening =
              appointment.type == 'screening'; // Home Health Screening
          final screeningData = appointment.screeningRequestData;

          if (status == 'pending') {
            return Column(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Const.aqua),
                    foregroundColor: Const.aqua,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Arrange Video Consultation'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showDeclineAppointmentDialog(
                              context, appointment.id!);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: Color(0xFFED3443)),
                          foregroundColor: const Color(0xFFED3443),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9DCEFF),
                              Color(0xFF35C5CF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (isScreening && screeningData != null) {
                              context
                                  .read<ProviderAppointmentCubit>()
                                  .acceptAppointment(
                                    appointment.id!,
                                    screeningId: screeningData.id,
                                  );
                            } else {
                              showAcceptAppointmentDialog(
                                  context, appointment.id!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else if (status == 'accepted') {
            if (isScreening) {
              return ElevatedButton(
                onPressed: () {
                  if (screeningData != null) {
                    context
                        .read<ProviderAppointmentCubit>()
                        .confirmSampleCollected(screeningData.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Const.aqua,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Confirm Sample Collected'),
              );
            } else {
              return ElevatedButton(
                onPressed: () async {
                  showCompleteAppointmentDialog(context, appointment.id!);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Mark as Completed'),
              );
            }
          } else if (status == 'completed' &&
              isScreening &&
              screeningData?.status == 'sample_collected') {
            return ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreeningReportSubmissionPage(
                      appointmentId: appointment.id!,
                    ),
                  ),
                );
                refreshAppointmentDetail();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              child: const Text('Upload Reports'),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
