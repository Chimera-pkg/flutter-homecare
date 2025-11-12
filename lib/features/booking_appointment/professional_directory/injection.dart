import 'package:get_it/get_it.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/datasources/professional_remote_datasource.dart';
import 'package:m2health/features/booking_appointment/professional_directory/data/repositories/professional_repository_impl.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/repositories/professional_repository.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/usecases/get_professional_detail.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/usecases/get_professionals.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/usecases/toggle_favorite.dart';

void initProfessionalModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetProfessionals(sl()));
  sl.registerLazySingleton(() => GetProfessionalDetail(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Repository
  sl.registerLazySingleton<ProfessionalRepository>(
    () => ProfessionalRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton(() => ProfessionalRemoteDatasource(sl()));
}
