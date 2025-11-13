import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/bloc/schedule_appointment_cubit.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/presentation/pages/schedule_appointment_page.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/features/appointment/pages/provider_appointment_detail_page.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:m2health/service_locator.dart';

class AppointmentRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'detail',
      name: AppRoutes.appointmentDetail,
      builder: (context, state) {
        final appointmentId = state.extra as int;
        return DetailAppointmentPage(
          appointmentId: appointmentId,
          key: UniqueKey(),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'provider-detail',
      name: AppRoutes.providerAppointmentDetail,
      builder: (context, state) {
        final id = state.extra as int;
        return ProviderAppointmentDetailPage(appointmentId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'schedule-appointment',
      name: AppRoutes.scheduleAppoointment,
      builder: (context, state) {
        final data = state.extra as ScheduleAppointmentPageData;
        return BlocProvider(
          create: (context) => ScheduleAppointmentCubit(
            getAvailableTimeSlots: sl(),
            rescheduleAppointment: sl(),
          ),
          child: ScheduleAppointmentPage(data: data),
        );
      },
    ),
  ];
}
