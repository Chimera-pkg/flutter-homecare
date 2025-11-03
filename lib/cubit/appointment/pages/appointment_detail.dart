import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/cubit/appointment/bloc/appointment_detail_cubit.dart';
import 'package:m2health/cubit/appointment/models/appointment.dart';
import 'package:m2health/cubit/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/models/personal_case.dart';
import 'package:m2health/widgets/gradient_button.dart'; // Assuming you have this

class DetailAppointmentPage extends StatefulWidget {
  final int appointmentId;

  const DetailAppointmentPage({super.key, required this.appointmentId});

  @override
  State<DetailAppointmentPage> createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  bool _isConcernExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Use context.read<Dio>() assuming Dio is provided in your main app
      create: (context) => AppointmentDetailCubit(context.read<Dio>())
        ..fetchAppointmentDetail(widget.appointmentId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Appointment Detail',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AppointmentDetailCubit, AppointmentDetailState>(
          listener: (context, state) {
            // You can show SnackBars here on error if needed
          },
          builder: (context, state) {
            if (state is AppointmentDetailLoading ||
                state is AppointmentDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AppointmentDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is AppointmentDetailLoaded) {
              return _buildContent(context, state.appointment, state.profile);
            }
            return const Center(child: Text('Something went wrong.'));
          },
        ),
        // Use bottomNavigationBar for the action buttons
        bottomNavigationBar:
            BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
          builder: (context, state) {
            if (state is AppointmentDetailLoaded) {
              return _buildActionButtons(context, state.appointment);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, Appointment appointment, Profile profile) {
    final personalCase = appointment.personalCase;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderCard(appointment.provider, appointment.status),
          const SizedBox(height: 16),
          _buildScheduleCard(appointment),
          const SizedBox(height: 16),
          _buildPatientInfo(profile),
          const SizedBox(height: 16),
          _buildConcernInfo(personalCase),
          const SizedBox(height: 16),
          _buildPaymentSummary(appointment),
        ],
      ),
    );
  }

  Widget _buildProviderCard(AppointmentProvider? provider, String status) {
    if (provider == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage:
                  (provider.avatar != null && provider.avatar!.isNotEmpty)
                      ? NetworkImage(provider.avatar!)
                      : null,
              child: (provider.avatar == null || provider.avatar!.isEmpty)
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (provider.jobTitle != null) Text(provider.jobTitle!),
                  const SizedBox(height: 8),
                  _StatusTag(status: status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(Appointment appointment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Appointment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.calendar_today,
            text: _formatDate(appointment.date),
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.access_time,
            text: appointment.hour,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(Profile profile) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Full name', text: profile.name),
          const SizedBox(height: 12),
          _InfoRow(label: 'Age', text: '${profile.age} years old'),
          const SizedBox(height: 12),
          _InfoRow(label: 'Gender', text: profile.gender ?? 'N/A'),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Address',
            text: profile.homeAddress ?? 'N/A',
            isFlexible: true,
          ),
          const SizedBox(height: 12),
          // Placeholder for map
          const Card(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text('Google Map Placeholder'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConcernInfo(PersonalCase? personalCase) {
    if (personalCase == null) return const SizedBox.shrink();
    final description = personalCase.description;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient Problem',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            personalCase.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            description,
            maxLines: _isConcernExpanded ? null : 2,
            overflow: _isConcernExpanded
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
          if (_isConcernExpanded)
            Row(
              children: personalCase.images.map((imageUrl) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          InkWell(
            onTap: () {
              setState(() {
                _isConcernExpanded = !_isConcernExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                _isConcernExpanded ? 'View Less' : 'View More',
                style: const TextStyle(
                  color: Const.aqua,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(Appointment appointment) {
    final addOns = appointment.personalCase?.addOn ?? [];
    final total = appointment.payTotal;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (appointment.payment != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Payment Method'),
                const Spacer(),
                Text(appointment.payment!.method),
              ],
            ),
          ],
          const Divider(height: 16),
          const Text(
            'Services',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (addOns.isEmpty)
            const Text('No add-on services selected.')
          else
            ...addOns.map(
              (addOn) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(addOn.name)),
                    const SizedBox(width: 16),
                    Text('${addOn.price}'),
                  ],
                ),
              ),
            ),
          const Divider(height: 16),
          Row(
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                '$total',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Const.aqua,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ACTION BUTTONS ---

  Widget _buildActionButtons(BuildContext context, Appointment appointment) {
    final status = appointment.status.toLowerCase();

    // Define Buttons
    Widget bookAgainButton = Expanded(
      child: GradientButton(
        text: 'Book Again',
        onPressed: () {
          // TODO: Handle Book Again logic
          // This should likely navigate to the nursing flow
          // context.push(AppRoutes.nursingFlowStart);
        },
      ),
    );

    Widget cancelButton = Expanded(
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return CancelAppoinmentDialog(
                onPressYes: () {
                  // Call the list cubit to update the list
                  context
                      .read<AppointmentCubit>()
                      .cancelAppointment(appointment.id);
                  // Pop dialog
                  Navigator.of(dialogContext).pop();
                  // Pop detail page
                  context.pop();
                },
              );
            },
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Cancel Booking',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    Widget rescheduleButton = Expanded(
      child: GradientButton(
        text: 'Reschedule',
        gradient: const LinearGradient(
          colors: [Color(0xFF35C5CF), Color(0xFF9DCEFF)],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        onPressed: () {
          // TODO: Handle Reschedule logic
          // This should navigate to the booking page with provider info
        },
      ),
    );

    Widget rateButton = Expanded(
      child: OutlinedButton(
        onPressed: () {
          // TODO: Handle Rating logic
          // This should show a rating dialog or page
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Const.tosca),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          'Rating',
          style: TextStyle(
            color: Const.tosca,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Logic to select buttons
    List<Widget> buttons;
    switch (status) {
      case 'pending':
      case 'accepted': // "Upcoming"
        buttons = [cancelButton, const SizedBox(width: 16), rescheduleButton];
        break;
      case 'completed':
        buttons = [rateButton, const SizedBox(width: 16), bookAgainButton];
        break;
      case 'cancelled':
        buttons = [bookAgainButton]; // Only "Book Again"
        break;
      default:
        buttons = [];
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    // Return the button bar
    return Container(
      padding: const EdgeInsets.all(8.0).copyWith(
        top: 16.0,
        bottom: 16.0 +
            MediaQuery.of(context).padding.bottom, // Respect the safe area
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: buttons,
      ),
    );
  }

  // --- HELPER WIDGETS ---

  String _formatDate(String date) {
    try {
      final DateTime parsedDate = DateTime.parse(date);
      return DateFormat('EEEE, MMMM dd, yyyy').format(parsedDate);
    } catch (e) {
      return date; // Fallback to original string
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? label;
  final bool isFlexible;

  const _InfoRow({
    required this.text,
    this.icon,
    this.label,
    this.isFlexible = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(text, style: const TextStyle(fontSize: 14));

    return Row(
      crossAxisAlignment:
          isFlexible ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Const.aqua, size: 20),
          const SizedBox(width: 16),
        ],
        if (label != null) ...[
          SizedBox(
            width: 80,
            child: Text(label!),
          ),
          const SizedBox(width: 8, child: Text(':')),
          const SizedBox(width: 2),
        ],
        isFlexible ? Flexible(child: textWidget) : textWidget,
      ],
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String status;
  const _StatusTag({required this.status});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'accepted':
        return const Color(0xFFE59500); // Orange
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
