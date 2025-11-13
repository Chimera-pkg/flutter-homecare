import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/data/datasources/schedule_appointment_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/data/repositories/schedule_appointment_repository_impl.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/repositories/schedule_appointment_repository.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/reschedule_appointment.dart';

void initScheduleAppointmentModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetAvailableTimeSlots(sl()));
  sl.registerLazySingleton(() => RescheduleAppointment(sl()));

  // Repository
  sl.registerLazySingleton<ScheduleAppointmentRepository>(
    () => ScheduleAppointmentRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton(
    () => ScheduleAppointmentRemoteDataSource(dio: sl()),
  );
}
