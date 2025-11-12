import 'package:get_it/get_it.dart';
import 'package:m2health/features/schedule/data/datasources/schedule_datasource.dart';
import 'package:m2health/features/schedule/data/repositories/schedule_repository_impl.dart';
import 'package:m2health/features/schedule/domain/repositories/schedule_repository.dart';
import 'package:m2health/features/schedule/domain/usecases/index.dart';

void initScheduleModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetAvailabilities(sl()));
  sl.registerLazySingleton(() => AddAvailability(sl()));
  sl.registerLazySingleton(() => UpdateAvailability(sl()));
  sl.registerLazySingleton(() => DeleteAvailability(sl()));
  sl.registerLazySingleton(() => GetOverrides(sl()));
  sl.registerLazySingleton(() => AddOverride(sl()));
  sl.registerLazySingleton(() => UpdateOverride(sl()));
  sl.registerLazySingleton(() => DeleteOverride(sl()));
  sl.registerLazySingleton(() => GetSlotsPreview(sl()));

  // Repository
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDatasource: sl()),
  );

  // Datasource
  sl.registerLazySingleton<ScheduleRemoteDatasource>(
    () => ScheduleRemoteDatasourceImpl(dio: sl()),
  );
}
