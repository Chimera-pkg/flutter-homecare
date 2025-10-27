import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:m2health/cubit/appointment/provider_appointment_cubit.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:m2health/const.dart';
import 'package:dio/dio.dart';
import 'package:m2health/utils.dart';
import 'package:m2health/views/appointment/provider_appointment_detail_page.dart';

class ProviderAppointmentPage extends StatefulWidget {
  final String? providerType;

  const ProviderAppointmentPage({super.key, required this.providerType});

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
    context
        .read<ProviderAppointmentCubit>()
        .fetchProviderAppointments(widget.providerType);
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
        title: Text(
          '${widget.providerType?.toUpperCase() ?? "Provider"} Appointments',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<ProviderAppointmentCubit>()
                  .fetchProviderAppointments(widget.providerType);
            },
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
          if (state is ProviderAppointmentLoaded) {
            // Check if we just successfully updated an appointment
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Appointment updated successfully'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
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
                        .fetchProviderAppointments(widget.providerType);
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
                            .fetchProviderAppointments(widget.providerType);
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
      List<ProviderAppointment> appointments, String status) {
    final filteredAppointments = appointments
        .where((appointment) =>
            appointment.status.toLowerCase() == status.toLowerCase())
        .toList();

    if (filteredAppointments.isEmpty) {
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
      onRefresh: () async {
        context
            .read<ProviderAppointmentCubit>()
            .fetchProviderAppointments(widget.providerType);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          return _buildProviderAppointmentCard(appointment, status);
        },
      ),
    );
  }

  Widget _buildProviderAppointmentCard(
      ProviderAppointment appointment, String status) {
    final patientData = appointment.patientData;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ProviderAppointmentDetailPage(
                appointmentId: appointment.id,
              );
            },
          ),
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
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (patientData['avatar'] != null &&
                            patientData['avatar'].toString().isNotEmpty)
                        ? NetworkImage(patientData['avatar'])
                        : null,
                    child: (patientData['avatar'] == null ||
                            patientData['avatar'].toString().isEmpty)
                        ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPatientName(appointment),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              appointment.type,
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
                                    .withOpacity(0.1),
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
                              '${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.parse(appointment.date))}',
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
                              appointment.hour,
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
                          onPressed: () => _rejectAppointment(appointment.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(80, 36),
                          ),
                          child: const Text('Reject'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _acceptAppointment(appointment.id),
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
                      onPressed: () => _completeAppointment(appointment.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Mark Complete'),
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

  void _acceptAppointment(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Appointment'),
          content:
              const Text('Are you sure you want to accept this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<ProviderAppointmentCubit>()
                    .acceptAppointment(appointmentId);
              },
              child:
                  const Text('Accept', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _rejectAppointment(int appointmentId) {
    print('=== UI: REJECT APPOINTMENT TRIGGERED ===');
    print('Appointment ID to reject: $appointmentId');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.red),
              SizedBox(width: 8),
              Text('Reject Appointment'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to reject this appointment?'),
              const SizedBox(height: 8),
              Text(
                'Appointment ID: $appointmentId',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                print('Reject appointment cancelled by user');
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                print('User confirmed rejection of appointment $appointmentId');
                Navigator.of(context).pop();

                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Rejecting appointment...'),
                      ],
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: Colors.orange,
                  ),
                );

                // Call the cubit to reject appointment
                print('Calling cubit to reject appointment $appointmentId');
                context
                    .read<ProviderAppointmentCubit>()
                    .rejectAppointment(appointmentId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _completeAppointment(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Appointment'),
          content: const Text('Mark this appointment as completed?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<ProviderAppointmentCubit>()
                    .completeAppointment(appointmentId);
              },
              child:
                  const Text('Complete', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentDetail(ProviderAppointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Appointment Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            'Patient',
                            appointment.patientData['username'] ??
                                appointment.patientData['name'] ??
                                'Unknown'),
                        _buildDetailRow('Type', appointment.type),
                        _buildDetailRow('Status', appointment.status),
                        _buildDetailRow(
                            'Date',
                            DateFormat('EEEE, dd MMMM yyyy')
                                .format(DateTime.parse(appointment.date))),
                        _buildDetailRow('Time', appointment.hour),
                        _buildDetailRow('Total',
                            '\$${appointment.payTotal.toStringAsFixed(2)}'),
                        if (appointment.summary.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Summary:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(appointment.summary),
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Related Medical Record Section
                        const Text(
                          'Related Medical Record:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<Map<String, dynamic>?>(
                          future: _fetchRelatedMedicalRecord(appointment.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Error loading medical record: ${snapshot.error}',
                                  style: TextStyle(color: Colors.red[800]),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                    'No related medical record found for this appointment'),
                              );
                            } else {
                              return _buildMedicalRecordCard(snapshot.data!);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        if (appointment.status.toLowerCase() == 'pending') ...[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _rejectAppointment(appointment.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _acceptAppointment(appointment.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF35C5CF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                  child: const Text('Accept'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (appointment.status.toLowerCase() == 'accepted') ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _completeAppointment(appointment.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text('Mark as Complete'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchRelatedMedicalRecord(
      int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final currentUserId = await Utils.getSpString(Const.USER_ID);
      final userRole = await Utils.getSpString(Const.ROLE);

      print('=== MEDICAL RECORD FETCH DEBUG ===');
      print('Target appointment ID: $appointmentId');
      print('Current user ID: $currentUserId');
      print('Current user role: $userRole');
      print('Token present: ${token != null}');

      // Find the appointment to get the patient user_id
      final appointments = context.read<ProviderAppointmentCubit>().state;
      ProviderAppointment? targetAppointment;

      if (appointments is ProviderAppointmentLoaded) {
        targetAppointment = appointments.appointments.firstWhere(
          (appointment) => appointment.id == appointmentId,
          orElse: () => throw Exception('Appointment not found'),
        );
      }

      if (targetAppointment == null) {
        print('ERROR: Could not find appointment with ID: $appointmentId');
        return null;
      }
      final patientUserId = targetAppointment.userId;
      print('Patient user_id: $patientUserId');

      // Try multiple API call approaches
      List<Map<String, dynamic>> allPersonalCases = [];

      // Approach 1: Basic call without filters
      print('\n=== APPROACH 1: Basic API call ===');
      try {
        final basicResponse = await Dio().get(
          '${Const.API_PERSONAL_CASES}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );
        print('Basic call status: ${basicResponse.statusCode}');
        print('Basic call response: ${basicResponse.data}');

        if (basicResponse.statusCode == 200 &&
            basicResponse.data['data'] != null) {
          allPersonalCases.addAll(
              List<Map<String, dynamic>>.from(basicResponse.data['data']));
        }
      } catch (e) {
        print('Basic call failed: $e');
      }

      // Approach 2: Call with pagination
      print('\n=== APPROACH 2: Paginated call ===');
      try {
        final paginatedResponse = await Dio().get(
          '${Const.API_PERSONAL_CASES}',
          queryParameters: {
            'page': 1,
            'limit': 50,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        print('Paginated call status: ${paginatedResponse.statusCode}');
        print('Paginated call response: ${paginatedResponse.data}');

        if (paginatedResponse.statusCode == 200 &&
            paginatedResponse.data['data'] != null) {
          final paginatedData =
              List<Map<String, dynamic>>.from(paginatedResponse.data['data']);
          for (var item in paginatedData) {
            if (!allPersonalCases
                .any((existing) => existing['id'] == item['id'])) {
              allPersonalCases.add(item);
            }
          }
        }
      } catch (e) {
        print('Paginated call failed: $e');
      }

      // Approach 3: Try with user filter
      print('\n=== APPROACH 3: User filter call ===');
      try {
        final userFilterResponse = await Dio().get(
          '${Const.API_PERSONAL_CASES}',
          queryParameters: {
            'user_id': patientUserId,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        print('User filter call status: ${userFilterResponse.statusCode}');
        print('User filter call response: ${userFilterResponse.data}');

        if (userFilterResponse.statusCode == 200 &&
            userFilterResponse.data['data'] != null) {
          final userFilterData =
              List<Map<String, dynamic>>.from(userFilterResponse.data['data']);
          for (var item in userFilterData) {
            if (!allPersonalCases
                .any((existing) => existing['id'] == item['id'])) {
              allPersonalCases.add(item);
            }
          }
        }
      } catch (e) {
        print('User filter call failed: $e');
      }

      // Approach 4: Try with include parameter
      print('\n=== APPROACH 4: Include relationships ===');
      try {
        final includeResponse = await Dio().get(
          '${Const.API_PERSONAL_CASES}',
          queryParameters: {
            'include': 'relatedHealthRecord,user',
            'with': 'relatedHealthRecord',
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        print('Include call status: ${includeResponse.statusCode}');
        print('Include call response: ${includeResponse.data}');

        if (includeResponse.statusCode == 200 &&
            includeResponse.data['data'] != null) {
          final includeData =
              List<Map<String, dynamic>>.from(includeResponse.data['data']);
          for (var item in includeData) {
            if (!allPersonalCases
                .any((existing) => existing['id'] == item['id'])) {
              allPersonalCases.add(item);
            }
          }
        }
      } catch (e) {
        print('Include call failed: $e');
      }

      print('\n=== CONSOLIDATED RESULTS ===');
      print('Total unique personal cases found: ${allPersonalCases.length}');

      if (allPersonalCases.isEmpty) {
        print('No personal cases found with any approach');
        return null;
      }

      // Log all cases for debugging
      print('All personal cases:');
      for (var personalCase in allPersonalCases) {
        print(
            '  Case ID: ${personalCase['id']}, User ID: ${personalCase['user_id']}, Related Record ID: ${personalCase['related_health_record_id']}');
      }

      return _processPersonalCases(allPersonalCases, patientUserId, token);
    } catch (e) {
      print('Error fetching related medical record: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _processPersonalCases(
      List<Map<String, dynamic>> personalCases,
      int patientUserId,
      String? token) async {
    print(
        'Processing ${personalCases.length} personal cases for user $patientUserId');

    // Filter cases for the specific patient user_id (try both int and string comparison)
    final patientCases = personalCases.where((personalCase) {
      final caseUserId = personalCase['user_id'];
      return caseUserId == patientUserId ||
          caseUserId.toString() == patientUserId.toString();
    }).toList();

    print('Patient-specific cases found: ${patientCases.length}');

    if (patientCases.isEmpty) {
      print('No cases found for patient user_id: $patientUserId');
      print('Available user_ids in personal cases:');
      for (var personalCase in personalCases) {
        print('  - User ID: ${personalCase['user_id']}');
      }
      return null;
    }

    // Find personal case that has related_health_record_id
    for (var personalCase in patientCases) {
      if (personalCase['related_health_record_id'] != null) {
        final recordId = personalCase['related_health_record_id'];
        print('Found case with related_health_record_id: $recordId');

        // Check if relatedHealthRecord is already included in the response
        if (personalCase['relatedHealthRecord'] != null) {
          print('RelatedHealthRecord found in response');
          return Map<String, dynamic>.from(personalCase['relatedHealthRecord']);
        } else {
          print('Fetching medical record separately...');

          try {
            final medicalRecordResponse = await Dio().get(
              '${Const.API_MEDICAL_RECORDS}/$recordId',
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
              ),
            );

            if (medicalRecordResponse.statusCode == 200) {
              print('Successfully fetched medical record');
              return Map<String, dynamic>.from(
                  medicalRecordResponse.data['data'] ?? {});
            }
          } catch (e) {
            print('Error fetching medical record $recordId: $e');
          }
        }
      }
    }

    print(
        'No personal case found with related_health_record_id for this patient');
    return null;
  }

  Widget _buildMedicalRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record['title'] ?? 'Medical Record',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Disease Name', record['disease_name'] ?? 'N/A'),
            _buildDetailRow(
                'Disease History', record['disease_history'] ?? 'N/A'),
            if (record['symptoms'] != null &&
                record['symptoms'].toString().isNotEmpty)
              _buildDetailRow('Symptoms', record['symptoms']),
            if (record['special_consideration'] != null &&
                record['special_consideration'].toString().isNotEmpty)
              _buildDetailRow(
                  'Special Consideration', record['special_consideration']),
            if (record['treatment_info'] != null &&
                record['treatment_info'].toString().isNotEmpty)
              _buildDetailRow('Treatment Info', record['treatment_info']),
          ],
        ),
      ),
    );
  }

  String _getPatientName(ProviderAppointment appointment) {
    final patientData = appointment.patientData;

    // Try different possible name fields in order of preference
    final possibleNames = [
      patientData['username'],
      patientData['name'],
      patientData['patient_name'],
      patientData['user']?['username'],
      patientData['user']?['name'],
    ];

    for (var name in possibleNames) {
      if (name != null && name.toString().isNotEmpty) {
        return name.toString();
      }
    }

    // If patient data is empty, show user ID as fallback
    if (patientData.isEmpty) {
      return 'Patient (ID: ${appointment.userId})';
    }

    return 'Unknown Patient';
  }
}
