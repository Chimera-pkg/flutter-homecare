import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/cubit/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/appointment_entity.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/professional_entity.dart';
import 'package:m2health/cubit/nursingclean/presentation/pages/payment/payment_page.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_cubit.dart';
import 'package:m2health/cubit/profiles/presentation/bloc/profile_state.dart';

class ReviewAppointmentPage extends StatelessWidget {
  final AppointmentEntity appointment;
  final NursingCase nursingCase;
  final ProfessionalEntity professional;

  const ReviewAppointmentPage({
    super.key,
    required this.appointment,
    required this.nursingCase,
    required this.professional,
  });

  void _onCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ),
              const Icon(Icons.warning_outlined, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Are you sure want to cancel this appointment?',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'You can rebook it later from the canceled appointment menu.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<AppointmentCubit>()
                          .cancelAppointment(appointment.id!);
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('Yes, Cancel',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          professional.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfessionalCard(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Schedule Appointment'),
                  _buildScheduleDetails(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Patient Information'),
                  _buildPatientDetails(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Services'),
                  _buildServicesList(nursingCase.addOnServices),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Text(
                        'Estimated Budget',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.info_outline_rounded, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildBudget(nursingCase.addOnServices),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildPatientDetails() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 24),
              Card(
                child: Container(
                  height: 150,
                  color: Colors.grey.shade200,
                  child: const Center(child: Text('Loading Map...')),
                ),
              ),
            ],
          );
        }
        if (profileState is ProfileError) {
          return Center(
              child: Text('Could not load profile: ${profileState.message}'));
        }
        if (profileState is PatientProfileLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPatientInfo(profileState.profile),
              const SizedBox(height: 24),
              Card(
                child: Container(
                  height: 200,
                  child: const Center(
                    child: Text('Google Map Placeholder'),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfessionalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(professional.avatar ?? ''),
              onBackgroundImageError: (_, __) {},
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(professional.role),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xFFE59500).withOpacity(0.1)),
                    child: const Text(
                      'Upcoming',
                      style: TextStyle(
                        color: Color(0xFFE59500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Widget _buildScheduleDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          _buildInfoRowWithIcon(Icons.calendar_today,
              DateFormat('EEEE, MMMM dd, yyyy').format(appointment.date)),
          const SizedBox(height: 8),
          _buildInfoRowWithIcon(
              Icons.access_time,
              DateFormat('h:mm a')
                  .format(DateFormat('HH:mm:ss').parse(appointment.hour))),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(Profile patientProfile) {
    final problem =
        nursingCase.issues.map((issue) => issue.description).join('\n\n');
    return Column(
      children: [
        _buildPatientInfoRow('Full Name', patientProfile.name),
        _buildPatientInfoRow('Age', patientProfile.age?.toString() ?? 'N/A'),
        _buildPatientInfoRow('Gender', patientProfile.gender ?? 'N/A'),
        _buildPatientInfoRow('Problem', problem),
        _buildPatientInfoRow('Address', patientProfile.homeAddress ?? 'N/A'),
      ],
    );
  }

  Widget _buildServicesList(List<AddOnService> services) {
    if (services.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text('No additional services selected.'),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(services.map((s) => s.name).join(', ')),
    );
  }

  Widget _buildBudget(List<AddOnService> services) {
    return Column(
      children: [
        ...services.map((service) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text(service.name),
                  const Spacer(),
                  Text('\$${service.price.toStringAsFixed(2)}'),
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '\$${nursingCase.estimatedBudget.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Text(text),
      ],
    );
  }

  Widget _buildPatientInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:'),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    debugPrint('Appointment ID in Review: ${appointment.id}');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      appointment: appointment,
                      nursingCase: nursingCase,
                      professional: professional,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF35C5CF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Pay',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _onCancel(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
