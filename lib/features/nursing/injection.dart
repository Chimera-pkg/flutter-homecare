import 'package:get_it/get_it.dart';
import 'package:m2health/features/nursing/data/datasources/nursing_remote_datasource.dart';
import 'package:m2health/features/nursing/data/mappers/nursing_case_mapper.dart';
import 'package:m2health/features/nursing/data/repositories/nursing_appointment_repository_impl.dart';
import 'package:m2health/features/nursing/data/repositories/nursing_repository_impl.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_appointment_repository.dart';
import 'package:m2health/features/nursing/domain/repositories/nursing_repository.dart';
import 'package:m2health/features/nursing/domain/usecases/create_personal_issue.dart';
import 'package:m2health/features/nursing/domain/usecases/create_nursing_appointment.dart';
import 'package:m2health/features/nursing/domain/usecases/create_nursing_case.dart';
import 'package:m2health/features/nursing/domain/usecases/delete_personal_issue.dart';
import 'package:m2health/features/nursing/domain/usecases/get_nursing_add_on_services.dart';
import 'package:m2health/features/nursing/domain/usecases/get_personal_issues.dart';
import 'package:m2health/features/nursing/domain/usecases/get_professional_detail.dart';
import 'package:m2health/features/nursing/domain/usecases/get_professionals.dart';
import 'package:m2health/features/nursing/domain/usecases/toggle_favorite.dart';
import 'package:m2health/features/nursing/domain/usecases/update_personal_issue.dart';

void initNursingModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetNursingCase(sl()));
  sl.registerLazySingleton(() => CreateNursingCase(sl()));
  sl.registerLazySingleton(() => UpdateNursingCase(sl()));
  sl.registerLazySingleton(() => GetProfessionals(sl()));
  sl.registerLazySingleton(() => GetProfessionalDetail(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerLazySingleton(() => GetNursingAddOnServices(sl()));
  sl.registerLazySingleton(() => CreateNursingAppointment(sl()));
  sl.registerLazySingleton(() => AddPersonalIssue(sl()));
  sl.registerLazySingleton(() => DeletePersonalIssue(sl()));

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
