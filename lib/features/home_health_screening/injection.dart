import 'package:get_it/get_it.dart';
import 'package:m2health/features/home_health_screening/data/datasources/home_health_screening_remote_datasource.dart';
import 'package:m2health/features/home_health_screening/data/repositories/home_health_screening_repository_impl.dart';
import 'package:m2health/features/home_health_screening/domain/repositories/home_health_screening_repository.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/create_screening_appointment.dart';
import 'package:m2health/features/home_health_screening/domain/usecases/get_screening_services.dart';

void initHomeHealthScreeningModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetScreeningServices(sl()));
  sl.registerLazySingleton(() => CreateScreeningAppointment(sl()));

  // Repository
  sl.registerLazySingleton<HomeHealthScreeningRepository>(
    () => HomeHealthScreeningRepositoryImpl(
      remoteDatasource: sl(),
      appointmentService: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton(() => HomeHealthScreeningRemoteDatasource(sl()));
}