import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/cubit/appointment/bloc/provider_appointment_detail_cubit.dart';
import 'package:m2health/models/provider_appointment.dart';

class ProviderAppointmentDetailPage extends StatelessWidget {
  final int appointmentId;
  const ProviderAppointmentDetailPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderAppointmentDetailCubit()
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
      BuildContext context, ProviderAppointment appointment) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              _PatientHeader(appointment: appointment),
              const SizedBox(height: 24),
              _buildSectionTitle('Schedule Appointment'),
              _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text: DateFormat('EEEE, MMMM dd, yyyy')
                      .format(DateTime.parse(appointment.date))),
              _InfoRow(
                  icon: Icons.access_time_outlined, text: appointment.hour),
              const SizedBox(height: 24),
              _buildSectionTitle('Patient Information'),
              _PatientInfoTable(appointment: appointment),
              const SizedBox(height: 24),
              _buildSectionTitle('Personal Case'),
              _PersonalCaseInfo(appointment: appointment),
            ],
          ),
        ),
        _ActionButtons(appointment: appointment),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  final ProviderAppointment appointment;
  const _PatientHeader({required this.appointment});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage:
              NetworkImage(appointment.patientData['avatar'] ?? ''),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patientData['username'] ?? 'Patient Name',
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
                      appointment.patientData['address'] ?? 'Unknown Location',
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
                  appointment.status,
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
  final ProviderAppointment appointment;
  const _PatientInfoTable({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow('Full Name', appointment.patientData['full_name']),
        _buildInfoRow('Age', appointment.patientData['age']?.toString()),
        _buildInfoRow('Gender', appointment.patientData['gender']),
        _buildInfoRow('Weight', '${appointment.patientData['weight']} kg'),
        _buildInfoRow('Height', '${appointment.patientData['height']} cm'),
        _buildInfoRow('Address', appointment.patientData['address']),
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

class _PersonalCaseInfo extends StatelessWidget {
  final ProviderAppointment appointment;
  const _PersonalCaseInfo({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final personalCase = appointment.personalCase ?? {};
    final images = personalCase['images'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Services: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: personalCase['services'] ?? '-',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Description:\n',
            style: const TextStyle(fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: personalCase['description'] ?? '-',
                style: const TextStyle(color: Colors.black, height: 1.5),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (images.isNotEmpty) ...[
          const Text('Images', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(images[index]),
                  ),
                );
              },
            ),
          )
        ]
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final ProviderAppointment appointment;
  const _ActionButtons({required this.appointment});

  @override
  Widget build(BuildContext context) {
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
      child: Column(
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
                    context
                        .read<ProviderAppointmentCubit>()
                        .rejectAppointment(appointment.id);
                    Navigator.of(context).pop();
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
                  child: const Text('Cancel'),
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
                      context
                          .read<ProviderAppointmentCubit>()
                          .acceptAppointment(appointment.id);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors
                          .transparent, // Make button background transparent
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent, // Remove shadow
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
      ),
    );
  }
}
