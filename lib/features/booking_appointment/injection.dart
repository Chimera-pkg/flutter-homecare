import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/add_on_services/injection.dart';
import 'package:m2health/features/booking_appointment/nursing/injection.dart';
import 'package:m2health/features/booking_appointment/personal_issue/injection.dart';
import 'package:m2health/features/booking_appointment/pharmacy/injection.dart';
import 'package:m2health/features/booking_appointment/professional_directory/injection.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/injection.dart';

void initBookingAppointmentModule(GetIt sl) {
  // Main flow modules
  initNursingModule(sl);
  initPharmacyModule(sl);

  // Shared modules
  initAddOnServiceModule(sl);
  initPersonalIssueModule(sl);
  initProfessionalModule(sl);
  initScheduleAppointmentModule(sl);
}
