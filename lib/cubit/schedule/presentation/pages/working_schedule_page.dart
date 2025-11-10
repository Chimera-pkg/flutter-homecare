import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_cubit.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_state.dart';
import 'package:m2health/cubit/schedule/presentation/widgets/date_specific_hours_tab.dart';
import 'package:m2health/cubit/schedule/presentation/widgets/schedule_preview_tab.dart';
import 'package:m2health/cubit/schedule/presentation/widgets/weekly_hours_tab.dart';
import 'package:m2health/service_locator.dart';

class WorkingSchedulePage extends StatefulWidget {
  const WorkingSchedulePage({super.key});

  @override
  State<WorkingSchedulePage> createState() => _WorkingSchedulePageState();
}

class _WorkingSchedulePageState extends State<WorkingSchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleCubit(
        getAvailabilities: sl(),
        addAvailability: sl(),
        updateAvailability: sl(),
        deleteAvailability: sl(),
        getOverrides: sl(),
        addOverride: sl(),
        updateOverride: sl(),
        deleteOverride: sl(),
        getAvailableSlots: sl(),
      )
        // Pass provider info to the cubit
        ..loadSchedules(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Working Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Const.aqua,
            indicatorColor: Const.aqua,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Weekly Hours'),
              Tab(text: 'Date-specific Hours'),
              Tab(text: 'Preview'),
            ],
          ),
        ),
        body: BlocListener<ScheduleCubit, ScheduleState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.error!), backgroundColor: Colors.red));
              context.read<ScheduleCubit>().clearMessages();
            }
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: Colors.green));
              context.read<ScheduleCubit>().clearMessages();
            }
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              WeeklyHoursTab(),
              const DateSpecificHoursTab(),
              const SchedulePreviewTab(),
            ],
          ),
        ),
      ),
    );
  }
}
