import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/nursing/data/repositories/nursing_appointment_repository_impl.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/usecases/create_nursing_appointment.dart';

void initNursingModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => CreateNursingAppointment(sl()));

  // Repository
  sl.registerLazySingleton<NursingAppointmentRepository>(
    () => NursingAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );
}
