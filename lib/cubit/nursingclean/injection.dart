import 'package:get_it/get_it.dart';
import 'package:m2health/cubit/nursingclean/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/cubit/nursingclean/data/mappers/nursing_case_mapper.dart';
import 'package:m2health/cubit/nursingclean/data/repositories/nursing_appointment_repository_impl.dart';
import 'package:m2health/cubit/nursingclean/data/repositories/nursing_repository_impl.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/cubit/nursingclean/domain/repositories/nursing_repository.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_appointment.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/create_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_case.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_nursing_services.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/get_professionals.dart';
import 'package:m2health/cubit/nursingclean/domain/usecases/toggle_favorite.dart';

void initNursingModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetNursingServices(sl()));
  sl.registerLazySingleton(() => GetNursingCase(sl()));
  sl.registerLazySingleton(() => CreateNursingCase(sl()));
  sl.registerLazySingleton(() => GetProfessionals(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetNursingAddOnServices(sl()));
  sl.registerLazySingleton(() => CreateNursingAppointment(sl()));

  // Repository
  sl.registerLazySingleton<NursingRepository>(
    () => NursingRepositoryImpl(
      remoteDataSource: sl(),
      mapper: sl(),
    ),
  );
  sl.registerLazySingleton<NursingAppointmentRepository>(
    () => NursingAppointmentRepositoryImpl(
      appointmentService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NursingRemoteDataSource>(
    () => NursingRemoteDataSourceImpl(dio: sl()),
  );

  // Mappers
  sl.registerLazySingleton(() => NursingCaseMapper());
}
