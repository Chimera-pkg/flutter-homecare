import 'package:get_it/get_it.dart';
import 'package:m2health/features/auth/data/datasources/google_auth_source.dart';
import 'package:m2health/features/auth/data/repositories/auth_repository.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';

void initAuthModule(GetIt sl) {
  // Repository
  sl.registerLazySingleton(
    () => AuthRepository(dio: sl(), googleAuthSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton(() => GoogleAuthSource());

  // Cubits
  sl.registerLazySingleton(() => AuthCubit());
}
