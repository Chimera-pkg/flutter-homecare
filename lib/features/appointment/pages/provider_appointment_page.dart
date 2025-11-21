import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/bloc/provider_appointment_cubit.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/widgets/provider_appointment_action_dialog.dart';
import 'package:m2health/route/app_routes.dart';

class ProviderAppointmentPage extends StatefulWidget {
  const ProviderAppointmentPage({super.key});

  @override
  State<ProviderAppointmentPage> createState() =>
      _ProviderAppointmentPageState();
}

class _ProviderAppointmentPageState extends State<ProviderAppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<ProviderAppointmentCubit>().fetchProviderAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Const.aqua,
          labelColor: Const.aqua,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: BlocListener<ProviderAppointmentCubit, ProviderAppointmentState>(
        listener: (context, state) {
          log('ProviderAppointmentState changed: $state',
              name: 'ProviderAppointmentPage');
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
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context
                        .read<ProviderAppointmentCubit>()
                        .fetchProviderAppointments();
                  },
                ),
              ),
            );
          }
        },
        child: BlocBuilder<ProviderAppointmentCubit, ProviderAppointmentState>(
          builder: (context, state) {
            if (state is ProviderAppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProviderAppointmentLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildProviderAppointmentList(state.appointments, 'pending'),
                  _buildProviderAppointmentList(state.appointments, 'accepted'),
                  _buildProviderAppointmentList(
                      state.appointments, 'completed'),
                  _buildProviderAppointmentList(
                      state.appointments, 'cancelled'),
                ],
              );
            } else if (state is ProviderAppointmentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProviderAppointmentCubit>()
                            .fetchProviderAppointments();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No appointments found'));
          },
        ),
      ),
    );
  }

  Widget _buildProviderAppointmentList(
      List<AppointmentEntity> appointments, String status) {
    final filteredAppointments = appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == status.toLowerCase())
        .toList();

    Widget buildEmptyState(String status) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No ${status.toLowerCase()} appointments found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<ProviderAppointmentCubit>().fetchProviderAppointments(),
      backgroundColor: Colors.white,
      color: Const.aqua,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          if (filteredAppointments.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: buildEmptyState(status),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 64.0),
              sliver: SliverList.builder(
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return _buildProviderAppointmentCard(appointment, status);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProviderAppointmentCard(
      AppointmentEntity appointment, String status) {
    final patient = appointment.patientProfile!;

    final localStarTime = appointment.startDatetime.toLocal();
    final localEndTime = appointment.endDatetime?.toLocal();
    final date = DateFormat('EEEE, dd MMMM yyyy').format(localStarTime);
    final startHour = DateFormat('hh:mm a').format(localStarTime);
    final endHour = localEndTime != null
        ? DateFormat('hh:mm a').format(localEndTime)
        : null;

    String getStatusDescription(String status) {
      switch (status.toLowerCase()) {
        case 'pending':
          return 'Waiting Approval';
        case 'accepted':
          return 'Accepted';
        case 'completed':
          return 'Completed';
        case 'cancelled':
          return 'Cancelled';
        default:
          return 'Unknown Status';
      }
    }

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).pushNamed(
          AppRoutes.providerAppointmentDetail,
          extra: appointment.id,
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: (patient.avatar != null)
                        ? NetworkImage(patient.avatar!)
                        : null,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              getStatusDescription(status),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const Text(' | ',
                                style: TextStyle(color: Colors.grey)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(appointment.status)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                appointment.status.toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(appointment.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              endHour != null
                                  ? '$startHour - $endHour'
                                  : startHour,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (appointment.summary.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Summary:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.summary,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${appointment.payTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                  if (status.toLowerCase() == 'pending')
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => showDeclineAppointmentDialog(
                              context, appointment.id!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 36),
                          ),
                          child: const Text('Decline'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (appointment.type == 'screening' &&
                                appointment.screeningRequestData != null) {
                              context
                                  .read<ProviderAppointmentCubit>()
                                  .acceptAppointment(
                                    appointment.id!,
                                    screeningId:
                                        appointment.screeningRequestData!.id,
                                  );
                            } else {
                              showAcceptAppointmentDialog(
                                  context, appointment.id!);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF35C5CF),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 36),
                          ),
                          child: const Text('Accept'),
                        ),
                      ],
                    ),
                  if (status.toLowerCase() == 'accepted')
                    ElevatedButton(
                      onPressed: () {
                        if (appointment.type == 'screening' &&
                            appointment.screeningRequestData != null) {
                          context
                              .read<ProviderAppointmentCubit>()
                              .confirmSampleCollected(
                                appointment.screeningRequestData!.id,
                              );
                        } else {
                          showCompleteAppointmentDialog(
                              context, appointment.id!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appointment.type == 'screening'
                            ? Const.aqua
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(appointment.type == 'screening'
                          ? 'Confirm Sample'
                          : 'Mark Complete'),
                    ),
                  if (status.toLowerCase() == 'completed' &&
                      appointment.type == 'screening' &&
                      appointment.screeningRequestData?.status ==
                          'sample_collected')
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<ProviderAppointmentCubit>()
                            .markReportReady(
                                appointment.screeningRequestData!.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Mark Report Ready'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'accepted':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }
}
