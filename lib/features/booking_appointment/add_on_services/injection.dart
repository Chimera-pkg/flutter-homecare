import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/datasources/add_on_service_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/add_on_services/data/repositories/add_on_service_repository_impl.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/repositories/add_on_service_repository.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/usecases/get_add_on_services.dart';

void initAddOnServiceModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetAddOnServices(sl()));

  // Repository
  sl.registerLazySingleton<AddOnServiceRepository>(
    () => AddOnServiceRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton(() => AddOnServiceRemoteDatasource(sl()));
}
