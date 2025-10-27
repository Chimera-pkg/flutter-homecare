import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/appointment/appointment_cubit.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/models/appointment.dart';
import 'package:m2health/services/provider_service.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:m2health/views/book_appointment.dart';

class AppointmentPage extends StatefulWidget {
  static const String route = '/appointment';
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ProviderService _providerService;
  final Map<String, Map<String, dynamic>> _providerCache = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _providerService = ProviderService(Dio());
    context.read<AppointmentCubit>().fetchAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get provider data with fallback mechanism
  Future<Map<String, dynamic>?> _getProviderDataWithFallback(
      Appointment appointment) async {
    // Return existing data if it has essential information
    if (!appointment.needsProviderDataFallback) {
      return appointment.profileServiceData;
    }

    // Extract provider name from summary
    final providerName = appointment.extractProviderNameFromSummary();
    if (providerName == null) {
      return appointment.profileServiceData;
    }

    // Check cache first
    final cacheKey = '${providerName}_${appointment.getProviderType()}';
    if (_providerCache.containsKey(cacheKey)) {
      return _providerCache[cacheKey];
    }

    try {
      // Fetch provider data
      final providerData = await _providerService.getProviderByName(
        providerName: providerName,
        providerType: appointment.getProviderType(),
      );

      if (providerData != null) {
        // Cache the result
        _providerCache[cacheKey] = providerData;
        return providerData;
      }
    } catch (e) {
      print('Error fetching provider data: $e');
    }

    // Return original data as fallback
    return appointment.profileServiceData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Appointment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actionsPadding: const EdgeInsets.only(right: 10),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/Filter.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // Handle filter action
            },
          ),

          // IconButton(
          //   icon: const Icon(Icons.medical_services),
          //   onPressed: () async {
          //     // Check if user is a provider and navigate to provider appointments
          //     final isProvider = await AppointmentManager.isProvider();
          //     if (isProvider) {
          //       AppointmentManager.navigateToAppointmentPage(context);
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text(
          //               'This feature is only available for healthcare providers'),
          //         ),
          //       );
          //     }
          //   },
          // ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Const.aqua,
          labelColor: Const.aqua,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
            Tab(text: 'Missed'),
          ],
        ),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state is AppointmentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AppointmentLoaded) {
            return Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildAppointmentList(state.appointments, 'pending'),
                      buildAppointmentList(state.appointments, 'upcoming'),
                      buildAppointmentList(state.appointments, 'completed'),
                      buildAppointmentList(state.appointments, 'cancelled'),
                      buildAppointmentList(state.appointments, 'missed'),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is AppointmentError) {
            if (state.needLogin) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Authentication Required'),
                      content: const Text(
                        'Your session has expired or you are not logged in. Please sign in to continue.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Sign In'),
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            GoRouter.of(context).go(AppRoutes.signIn);
                          },
                        ),
                      ],
                    );
                  },
                );
              });
            }
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No appointments found'));
          }
        },
      ),
      // bottomNavigationBar: CustomBottomAppBar(),
    );
  }

  Widget buildAppointmentList(List<Appointment> appointments, String status) {
    List<Appointment> filteredAppointments;

    // Special handling for Upcoming tab to show accepted
    if (status == 'upcoming') {
      // For "Upcoming" tab, show both accepted appointments
      filteredAppointments = appointments
          .where((appointment) =>
              appointment.status.toLowerCase() == 'accepted' ||
              appointment.status.toLowerCase() == 'upcoming')
          .toList();
    } else {
      // For other tabs, filter by exact status
      filteredAppointments = appointments
          .where((appointment) =>
              appointment.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    // Sort by date (newest first)
    filteredAppointments.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.date);
        final dateB = DateTime.parse(b.date);
        return dateB.compareTo(dateA);
      } catch (e) {
        // In case of parsing error, keep original order
        return 0;
      }
    });

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              status == 'upcoming'
                  ? 'No upcoming appointments found'
                  : 'No ${status.toLowerCase()} appointments found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _AppointmentListItem(
          key: ValueKey(appointment.id), // Add a unique key for performance
          appointment: appointment,
          getProviderData: _getProviderDataWithFallback,
        );
      },
    );
  }
}

/// An optimized widget for displaying a single appointment item.
/// It uses a StatefulWidget to ensure the Future for fetching provider data
/// is called only once, preventing lag during scrolling.
class _AppointmentListItem extends StatefulWidget {
  final Appointment appointment;
  final Future<Map<String, dynamic>?> Function(Appointment) getProviderData;

  const _AppointmentListItem({
    super.key,
    required this.appointment,
    required this.getProviderData,
  });

  @override
  __AppointmentListItemState createState() => __AppointmentListItemState();
}

class __AppointmentListItemState extends State<_AppointmentListItem> {
  late Future<Map<String, dynamic>?> _providerDataFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the data once when the widget is initialized and store the future.
    _providerDataFuture = widget.getProviderData(widget.appointment);
  }

  String _getProviderName(
      Map<String, dynamic> profile, Appointment appointment) {
    if (profile['name'] != null && profile['name'].toString().isNotEmpty) {
      return profile['name'].toString();
    }
    if (profile['username'] != null &&
        profile['username'].toString().isNotEmpty) {
      return profile['username'].toString();
    }
    if (profile['provider_name'] != null &&
        profile['provider_name'].toString().isNotEmpty) {
      return profile['provider_name'].toString();
    }
    if (profile['pharmacist_name'] != null &&
        profile['pharmacist_name'].toString().isNotEmpty) {
      return profile['pharmacist_name'].toString();
    }
    if (profile['nurse_name'] != null &&
        profile['nurse_name'].toString().isNotEmpty) {
      return profile['nurse_name'].toString();
    }
    // Final fallback to extract from summary
    return appointment.extractProviderNameFromSummary() ?? 'Unknown Provider';
  }

  String? _getAvatarUrl(Map<String, dynamic> profile) {
    if (profile['avatar'] != null && profile['avatar'].toString().isNotEmpty) {
      return profile['avatar'].toString();
    }
    if (profile['image'] != null && profile['image'].toString().isNotEmpty) {
      return profile['image'].toString();
    }
    if (profile['photo'] != null && profile['photo'].toString().isNotEmpty) {
      return profile['photo'].toString();
    }
    if (profile['profile_image'] != null &&
        profile['profile_image'].toString().isNotEmpty) {
      return profile['profile_image'].toString();
    }
    return null;
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'accepted':
      case 'upcoming':
        return const Color(0xFFE59500); // Orange
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final appointmentStatus = appointment.status;
    final appointmentStatusLower = appointmentStatus.toLowerCase();
    final statusColor = _getStatusColor(appointmentStatusLower);

    return FutureBuilder<Map<String, dynamic>?>(
      future: _providerDataFuture,
      builder: (context, snapshot) {
        final effectiveProfile =
            snapshot.data ?? appointment.profileServiceData;
        final providerName = _getProviderName(effectiveProfile, appointment);
        final avatarUrl = _getAvatarUrl(effectiveProfile);

        return GestureDetector(
          onTap: () {
            context.push(AppRoutes.appointmentDetail, extra: {
              'id': appointment.id,
              'user_id': appointment.userId,
              'type': appointment.type,
              'status': appointment.status,
              'date': appointment.date,
              'hour': appointment.hour,
              'summary': appointment.summary,
              'pay_total': appointment.payTotal,
              'profile_services_data': effectiveProfile,
            });
          },
          child: Stack(
            children: [
              // Show loading indicator if data is being fetched
              if (snapshot.connectionState == ConnectionState.waiting &&
                  appointment.needsProviderDataFallback)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                ),
              Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                (avatarUrl != null && avatarUrl.isNotEmpty)
                                    ? NetworkImage(avatarUrl)
                                    : null,
                            child: (avatarUrl == null || avatarUrl.isEmpty)
                                ? const Icon(Icons.person,
                                    size: 30, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  providerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text('${appointment.type} |'),
                                    const SizedBox(width: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            statusColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        appointmentStatus,
                                        style: TextStyle(color: statusColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${DateFormat('EEEE').format(DateTime.parse(appointment.date))}, ${DateFormat('dd MMMM yyyy').format(DateTime.parse(appointment.date))} | ${appointment.hour}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (appointmentStatusLower == 'completed')
                            Row(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Handle rating
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          const BorderSide(color: Const.tosca),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Rating',
                                      style: TextStyle(
                                        color: Const.tosca,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF40E0D0), // Tosca color
                                        Color(0xFF35C5CF),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    ),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      // Handle book again
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Book Again',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (appointmentStatusLower == 'cancelled')
                            Container(
                              width: 350,
                              height: 41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF40E0D0), // Tosca color
                                    Color(0xFF35C5CF),
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                              ),
                              child: OutlinedButton(
                                onPressed: () {
                                  // Handle book again
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                      color: Colors.transparent),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Book Again',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (appointmentStatusLower == 'missed')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    final appointmentId = appointment.id;
                                    context
                                        .read<AppointmentCubit>()
                                        .deleteAppointment(appointmentId);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel Bookings',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF35C5CF),
                                        Color(0xFF9DCEFF),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    ),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      final appointmentId = appointment
                                          .id; // Get the appointment ID
                                      final profile = effectiveProfile;
                                      context.push(
                                        AppRoutes.bookAppointment,
                                        extra: BookAppointmentPageData(
                                          pharmacist: profile,
                                          appointmentId:
                                              appointmentId, // Pass the appointment ID
                                          initialDate: DateTime.parse(
                                              appointment
                                                  .date), // Pre-fill date
                                          initialTime: DateFormat('HH:mm')
                                              .parse(appointment
                                                  .hour), // Pre-fill time
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reschedule',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (appointmentStatusLower == 'pending' ||
                              appointmentStatusLower == 'accepted' ||
                              appointmentStatusLower == 'upcoming')
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    final appointmentId = appointment.id;

                                    // Show confirmation dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(16.0),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: IconButton(
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                              const Icon(Icons.warning_outlined,
                                                  size: 50, color: Colors.red),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'Are you sure to cancel this booking?',
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(); // Close dialog
                                                    },
                                                    child: const Text('No'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Close dialog and cancel the appointment
                                                      Navigator.of(context)
                                                          .pop();
                                                      context
                                                          .read<
                                                              AppointmentCubit>()
                                                          .cancelAppointment(
                                                              appointmentId);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.red,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                        'Yes, Cancel'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel Booking',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF35C5CF),
                                        Color(0xFF9DCEFF),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    ),
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      final appointmentId = appointment
                                          .id; // Get the appointment ID

                                      final profile = effectiveProfile;
                                      print(effectiveProfile);
                                      context.push(
                                        AppRoutes.bookAppointment,
                                        extra: BookAppointmentPageData(
                                          pharmacist: profile,
                                          appointmentId:
                                              appointmentId, // Pass the appointment ID
                                          initialDate: DateTime.parse(
                                              appointment
                                                  .date), // Pre-fill date
                                          initialTime: DateFormat('HH:mm')
                                              .parse(appointment
                                                  .hour), // Pre-fill time
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reschedule',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
