import 'package:get_it/get_it.dart';
import 'package:m2health/cubit/medical_record/data/datasources/medical_record_remote_data_source.dart';
import 'package:m2health/cubit/medical_record/data/repositories/medical_record_repository_impl.dart';
import 'package:m2health/cubit/medical_record/domain/repositories/medical_record_repository.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/create_medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/delete_medical_record.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/get_medical_records.dart';
import 'package:m2health/cubit/medical_record/domain/usecases/update_medical_record.dart';

void initMedicalRecordModule(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetMedicalRecords(sl()));
  sl.registerLazySingleton(() => CreateMedicalRecord(sl()));
  sl.registerLazySingleton(() => UpdateMedicalRecord(sl()));
  sl.registerLazySingleton(() => DeleteMedicalRecord(sl()));

  // Repository
  sl.registerLazySingleton<MedicalRecordRepository>(
    () => MedicalRecordRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MedicalRecordRemoteDataSource>(
    () => MedicalRecordRemoteDataSourceImpl(dio: sl()),
  );
}
