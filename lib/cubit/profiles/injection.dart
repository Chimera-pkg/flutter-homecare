import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/profiles/data/datasources/profile_remote_datasource.dart';
import 'package:m2health/cubit/profiles/data/datasources/certificate_remote_datasource.dart';
import 'package:m2health/cubit/profiles/data/repositories/profile_repository_impl.dart';
import 'package:m2health/cubit/profiles/data/repositories/certificate_repository_impl.dart';
import 'package:m2health/cubit/profiles/domain/repositories/profile_repository.dart';
import 'package:m2health/cubit/profiles/domain/repositories/certificate_repository.dart';
import 'package:m2health/cubit/profiles/domain/usecases/index.dart';

void initProfileModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => CreateCertificate(sl()));
  sl.registerLazySingleton(() => UpdateCertificate(sl()));
  sl.registerLazySingleton(() => DeleteCertificate(sl()));

  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<CertificateRepository>(
    () => CertificateRepositoryImpl(remoteDatasource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<CertificateRemoteDatasource>(
    () => CertificateRemoteDatasourceImpl(dio: sl<Dio>()),
  );
}
