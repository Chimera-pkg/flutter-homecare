import 'package:get_it/get_it.dart';
import 'package:m2health/features/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource.dart';
import 'package:m2health/features/pharmacogenomics/data/datasources/pharmacogenomics_remote_datasource_impl.dart';
import 'package:m2health/features/pharmacogenomics/data/repositories/pharmacogenomics_repository_impl.dart';
import 'package:m2health/features/pharmacogenomics/domain/repositories/pharmacogenomics_repository.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/delete_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/get_pharmacogenomics.dart';
import 'package:m2health/features/pharmacogenomics/domain/usecases/store_pharmacogenomics.dart';

void initPharmacogenomicsModule(GetIt sl) {
  // Use Cases
  sl.registerLazySingleton(() => GetPharmacogenomics(sl()));
  sl.registerLazySingleton(() => StorePharmacogenomics(sl()));
  sl.registerLazySingleton(() => DeletePharmacogenomic(sl()));

  // Repository
  sl.registerLazySingleton<PharmacogenomicsRepository>(
    () => PharmacogenomicsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PharmacogenomicsRemoteDataSource>(
    () => PharmacogenomicsRemoteDataSourceImpl(dio: sl()),
  );
}
