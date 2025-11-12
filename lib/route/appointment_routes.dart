import 'package:go_router/go_router.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/features/appointment/pages/provider_appointment_detail_page.dart';
import 'package:m2health/route/navigator_keys.dart';

class AppointmentRoutes {
  static List<GoRoute> routes = [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: 'detail',
      name: AppRoutes.appointmentDetail,
      builder: (context, state) {
        final appointmentId = state.extra as int;
        return DetailAppointmentPage(appointmentId: appointmentId);
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
  ];
}
