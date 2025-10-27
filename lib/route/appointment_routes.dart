import 'package:go_router/go_router.dart';
import 'package:m2health/cubit/appointment/appointment_module.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/views/book_appointment.dart';

class AppointmentRoutes {
  static List<GoRoute> routes = [
    GoRoute(
        path: AppRoutes.providerAppointment,
        name: AppRoutes.providerAppointment,
        builder: (context, state) {
          return const ProviderAppointmentPage();
        }),
    GoRoute(
      path: AppRoutes.appointmentDetail,
      builder: (context, state) {
        final appointmentData = state.extra as Map<String, dynamic>;
        return DetailAppointmentPage(appointmentData: appointmentData);
      },
    ),
    GoRoute(
      path: AppRoutes.bookAppointment,
      builder: (context, state) {
        final data = state.extra as BookAppointmentPageData;
        return BookAppointmentPage(data: data);
      },
    ),
  ];
}
