import 'package:go_router/go_router.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/features/appointment/pages/provider_appointment_detail_page.dart';
import 'package:m2health/core/presentation/views/book_appointment.dart';

class AppointmentRoutes {
  static List<GoRoute> routes = [
    // GoRoute(
    //     path: AppRoutes.providerAppointment,
    //     name: AppRoutes.providerAppointment,
    //     builder: (context, state) {
    //       return const ProviderAppointmentPage();
    //     }),
    GoRoute(
      path: AppRoutes.appointmentDetail,
      builder: (context, state) {
        final appointmentId = state.extra as int;
        return DetailAppointmentPage(appointmentId: appointmentId);
      },
    ),
    GoRoute(
      path: AppRoutes.bookAppointment,
      builder: (context, state) {
        final data = state.extra as BookAppointmentPageData;
        return BookAppointmentPage(data: data);
      },
    ),
    GoRoute(
      path: AppRoutes.providerAppointmentDetail,
      name: AppRoutes.providerAppointmentDetail,
      builder: (context, state) {
        final id = state.extra as int;
        return ProviderAppointmentDetailPage(appointmentId: id);
      },
    ),
  ];
}
