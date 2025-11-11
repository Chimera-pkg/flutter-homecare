import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/bloc/appointment_cubit.dart';
import 'package:m2health/features/appointment/models/appointment.dart';
import 'package:m2health/features/appointment/widgets/cancel_appoinment_dialog.dart';
import 'package:m2health/models/provider.dart';
import 'package:m2health/route/app_routes.dart';
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
  final List<AppointmentStatus> _tabs = AppointmentStatus.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Fetch appointments for the initial tab
    context.read<AppointmentCubit>().refreshAllTabs();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      return;
    }
    final selectedTab = _tabs[_tabController.index];
    final tabData =
        context.read<AppointmentCubit>().state.tabData[selectedTab]!;

    // Fetch data only if it's the first time loading this tab
    if (tabData.status == LoadStatus.initial) {
      _fetchDataForTab(selectedTab);
    }
  }

  void _fetchDataForTab(AppointmentStatus tab, {bool isRefresh = false}) {
    context
        .read<AppointmentCubit>()
        .fetchAppointments(tab, isRefresh: isRefresh);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
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
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Const.aqua,
          labelColor: Const.aqua,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: _tabs
              .map((status) => Tab(
                  text:
                      status.name[0].toUpperCase() + status.name.substring(1)))
              .toList(),
        ),
      ),
      body: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state.isAuthError) {
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
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: _tabs.map((tab) {
              final tabData = state.tabData[tab]!;
              return AppointmentListView(
                key: PageStorageKey('tab_$tab'),
                status: tab,
                tabData: tabData,
                onRefresh: () async => _fetchDataForTab(tab, isRefresh: true),
                onLoadMore: () => _fetchDataForTab(tab),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class AppointmentListView extends StatefulWidget {
  final AppointmentStatus status;
  final AppointmentTabData tabData;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  const AppointmentListView({
    super.key,
    required this.status,
    required this.tabData,
    required this.onRefresh,
    required this.onLoadMore,
  });

  @override
  State<AppointmentListView> createState() => _AppointmentListViewState();
}

class _AppointmentListViewState extends State<AppointmentListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      widget.onLoadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = widget.tabData.appointments;
    final status = widget.tabData.status;

    if (status == LoadStatus.initial ||
        (status == LoadStatus.loading && appointments.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status == LoadStatus.failure && appointments.isEmpty) {
      return Center(
          child: Text(
              widget.tabData.errorMessage ?? 'Failed to load appointments'));
    }

    if (appointments.isEmpty) {
      return RefreshIndicator(
        onRefresh: widget.onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(widget.status),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      backgroundColor: Colors.white,
      color: Const.aqua,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: appointments.length + 1, // +1 for loading indicator
        itemBuilder: (context, index) {
          if (index == appointments.length) {
            if (widget.tabData.status == LoadStatus.loadingMore) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ));
            }
            return const SizedBox.shrink();
          }

          final appointment = appointments[index];
          return _AppointmentListItem(
            key: ValueKey(appointment.id),
            appointment: appointment,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppointmentStatus status) {
    final message = status == AppointmentStatus.upcoming
        ? 'No upcoming appointments found'
        : 'No ${status.name} appointments found';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _AppointmentListItem extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentListItem({
    super.key,
    required this.appointment,
  });

  String _getProviderName(Provider? provider) {
    return provider?.name ?? 'Unknown Provider';
  }

  String? _getAvatarUrl(Provider? provider) {
    return provider?.avatar;
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
    final appointmentStatus = appointment.status;
    final appointmentStatusLower = appointmentStatus.toLowerCase();
    final statusColor = _getStatusColor(appointmentStatusLower);
    final providerName = _getProviderName(appointment.provider);
    final avatarUrl = _getAvatarUrl(appointment.provider);

    final cancelButton = OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CancelAppoinmentDialog(onPressYes: () {
              context
                  .read<AppointmentCubit>()
                  .cancelAppointment(appointment.id);
            });
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
    );

    final rescheduleButton = Container(
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
          GoRouter.of(context).push(
            AppRoutes.bookAppointment,
            extra: BookAppointmentPageData(
              provider: appointment.provider!,
              appointmentId: appointment.id,
              initialDate: DateTime.parse(appointment.date),
              initialTime: DateFormat('HH:mm').parse(appointment.hour),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
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
    );

    final bookAgainButton = Container(
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
          side: const BorderSide(color: Colors.transparent),
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
    );

    final ratingButton = OutlinedButton(
      onPressed: () {
        // Handle rating
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Const.tosca),
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
    );

    return GestureDetector(
      onTap: () {
        // Navigate to detail page, passing only the ID
        context.push(AppRoutes.appointmentDetail, extra: appointment.id);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: (avatarUrl == null || avatarUrl.isEmpty)
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          providerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                                '${appointment.provider?.jobTitle ?? appointment.type} |'),
                            const SizedBox(width: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
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
                          '${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.parse(appointment.date))} | ${appointment.hour}',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // --- Action Buttons ---
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (appointmentStatusLower == 'completed') ...[
                    Expanded(child: ratingButton),
                    const SizedBox(width: 10),
                    Expanded(child: bookAgainButton),
                  ],
                  if (appointmentStatusLower == 'cancelled')
                    Expanded(child: bookAgainButton),
                  if (appointmentStatusLower == 'missed') ...[
                    Expanded(child: cancelButton),
                    const SizedBox(width: 10),
                    Expanded(child: rescheduleButton),
                  ],
                  if (appointmentStatusLower == 'pending' ||
                      appointmentStatusLower == 'accepted' ||
                      appointmentStatusLower == 'upcoming') ...[
                    Expanded(child: cancelButton),
                    const SizedBox(width: 10),
                    Expanded(child: rescheduleButton),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
