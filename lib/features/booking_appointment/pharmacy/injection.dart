import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/pharmacy/data/repositories/pharmacy_appointment_repository_impl.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/repositories/pharmacy_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/pharmacy/domain/usecases/create_pharmacy_appointment.dart';

void initPharmacyModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreatePharmacyAppointment(sl()));

  // Repository
  sl.registerLazySingleton<PharmacyAppointmentRepository>(
    () => PharmacyAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
