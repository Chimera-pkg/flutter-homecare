import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/extensions/string_extensions.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/bloc/appointment_detail_cubit.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/features/payment/presentation/pages/payment_page.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/core/presentation/widgets/gradient_button.dart'; // Assuming you have this

class DetailAppointmentPage extends StatefulWidget {
  final int appointmentId;

  const DetailAppointmentPage({super.key, required this.appointmentId});

  @override
  State<DetailAppointmentPage> createState() => _DetailAppointmentPageState();
}

class _DetailAppointmentPageState extends State<DetailAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentDetailCubit(sl<AppointmentService>())
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
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<AppointmentDetailCubit>()
                      .fetchAppointmentDetail(widget.appointmentId);
                },
                child: _buildContent(context, state.appointment),
              );
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

  Widget _buildContent(BuildContext context, AppointmentEntity appointment) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderCard(appointment.provider!, appointment.status),
          const SizedBox(height: 16),
          _buildScheduleCard(appointment),
          const SizedBox(height: 16),
          _buildPatientInfo(appointment.patientProfile!),
          const SizedBox(height: 16),
          _buildConcernInfo(appointment),
          const SizedBox(height: 16),
          _buildPaymentSummary(appointment),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProfessionalEntity? provider, String status) {
    if (provider == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: (provider.avatar != null)
                ? NetworkImage(provider.avatar!)
                : null,
            child: (provider.avatar == null)
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
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
                Text(provider.jobTitle ?? provider.role),
                const SizedBox(height: 8),
                _StatusTag(status: status.toTitleCase()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(AppointmentEntity appointment) {
    final localStartTime = appointment.startDatetime.toLocal();
    final localEndTime = appointment.endDatetime?.toLocal();

    final date = DateFormat('EEEE, MMMM dd, yyyy').format(localStartTime);

    final startHour = DateFormat('hh:mm a').format(localStartTime);
    final endHour = localEndTime != null
        ? DateFormat('hh:mm a').format(localEndTime)
        : null;
    final hour = endHour != null ? '$startHour - $endHour' : startHour;

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
            text: date,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.access_time,
            text: hour,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(Profile profile) {
    final gender = profile.gender != null
        ? profile.gender!.toTitleCase()
        : 'Not specified';

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
          _InfoRow(label: 'Gender', text: gender),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Address',
            text: profile.homeAddress ?? 'N/A',
            isFlexible: true,
          ),
          const SizedBox(height: 12),
          // Placeholder for map
          // const Card(
          //   child: SizedBox(
          //     height: 200,
          //     child: Center(
          //       child: Text('Google Map Placeholder'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildConcernInfo(AppointmentEntity appointment) {
    List<PersonalIssue>? issues;

    if (appointment.providerType == 'nurse') {
      issues = appointment.nursingCase?.issues;
    } else if (appointment.providerType == 'pharmacist') {
      issues = appointment.pharmacyCase?.issues;
    }

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
          if (issues != null && issues.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues![index];
                final images = issue.imageUrls;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issue.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        issue.description,
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 8),
                      if (images.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, imageIndex) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  images[imageIndex],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(AppointmentEntity appointment) {
    List<AddOnService> addOns = [];
    if (appointment.providerType == 'nurse') {
      final nursingCase = appointment.nursingCase;
      if (nursingCase != null && nursingCase.addOnServices.isNotEmpty) {
        addOns = nursingCase.addOnServices;
      }
    }
    final total = appointment.payTotal;
    final isPaid = appointment.payment != null;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPaid ? 'Payment Details' : 'Estimated Budget',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          if (appointment.payment != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Payment Date'),
                const Spacer(),
                Text(DateFormat('MMM dd, yyyy, hh:mm a')
                    .format(appointment.payment!.createdAt.toLocal())),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Payment Method'),
                const Spacer(),
                Text(appointment.payment!.method),
              ],
            ),
            const SizedBox(height: 8),
            // TODO: Order completed date still use updatedat
            Row(
              children: [
                const Text('Order Completed'),
                const Spacer(),
                Text(DateFormat('MMM dd, yyyy, hh:mm a')
                    .format(appointment.payment!.updatedAt.toLocal())),
              ],
            ),
            const Divider(height: 20),
          ],
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
                '\$$total',
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

  Widget _buildActionButtons(
      BuildContext context, AppointmentEntity appointment) {
    final status = appointment.status.toLowerCase();
    bool isHorizontalLayout = true;

    Widget payButton = ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                appointment: appointment,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF35C5CF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text('Pay',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )));

    Widget cancelButton = ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return CancelAppoinmentDialog(
              onPressYes: () {
                // Call the list cubit to update the list
                context
                    .read<AppointmentCubit>()
                    .cancelAppointment(appointment.id!);
                // Pop dialog
                Navigator.of(dialogContext).pop();
                // Pop detail page
                context.pop();
              },
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text(
        'Cancel Booking',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    Widget rescheduleButton = GradientButton(
      text: 'Reschedule',
      gradient: const LinearGradient(
        colors: [Color(0xFF35C5CF), Color(0xFF9DCEFF)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScheduleAppointmentPage(
              professional: appointment.provider!,
              currentAppointment: appointment,
              isSubmitting: false,
              onTimeSlotSelected: (datetime) {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );

    Widget bookAgainButton = GradientButton(
      text: 'Book Again',
      onPressed: () {
        // TODO: Handle Book Again logic
        // context.push(AppRoutes.nursingFlowStart);
      },
    );

    Widget rateButton = OutlinedButton(
      onPressed: () {
        // TODO: Handle Rating logic
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
    );

    List<Widget> buttons;
    switch (status) {
      case 'pending':
        if (appointment.payment == null) {
          buttons = [payButton, cancelButton];
          isHorizontalLayout = false; // user vertical layout
        } else {
          buttons = [cancelButton, rescheduleButton];
        }
        break;
      case 'accepted':
        buttons = [cancelButton, rescheduleButton];
        break;
      case 'completed':
        buttons = [rateButton, bookAgainButton];
        break;
      case 'cancelled':
        buttons = [bookAgainButton];
        break;
      default:
        buttons = [];
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
        padding: const EdgeInsets.all(16).copyWith(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: isHorizontalLayout
            ? Row(
                spacing: 16,
                children:
                    buttons.map((button) => Expanded(child: button)).toList(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: buttons,
              ));
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
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
