import 'package:get_it/get_it.dart';
import 'package:m2health/cubit/wellness_genomics/data/datasources/wellness_genomics_remote_datasource.dart';
import 'package:m2health/cubit/wellness_genomics/data/datasources/wellness_genomics_remote_datasource_impl.dart';
import 'package:m2health/cubit/wellness_genomics/data/repositories/wellness_genomics_repository_impl.dart';
import 'package:m2health/cubit/wellness_genomics/domain/repositories/wellness_genomics_repository.dart';
import 'package:m2health/cubit/wellness_genomics/domain/usecases/delete_wellness_genomic.dart';
import 'package:m2health/cubit/wellness_genomics/domain/usecases/get_wellness_genomics.dart';
import 'package:m2health/cubit/wellness_genomics/domain/usecases/store_wellness_genomics.dart';

void initWellnessGenomicsModule(GetIt sl) {
  // Use Cases
  sl.registerLazySingleton(() => GetWellnessGenomics(sl()));
  sl.registerLazySingleton(() => StoreWellnessGenomics(sl()));
  sl.registerLazySingleton(() => DeleteWellnessGenomic(sl()));

  // Repository
  sl.registerLazySingleton<WellnessGenomicsRepository>(
    () => WellnessGenomicsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<WellnessGenomicsRemoteDataSource>(
    () => WellnessGenomicsRemoteDataSourceImpl(dio: sl()),
  );
}
