import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/cubit/medical_record/injection.dart';
import 'package:m2health/cubit/nursingclean/injection.dart';
import 'package:m2health/cubit/pharmacogenomics/injection.dart';
import 'package:m2health/cubit/profiles/injection.dart';
import 'package:m2health/cubit/wellness_genomics/injection.dart';
import 'package:m2health/services/appointment_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External Dependencies (like Dio, SharedPreferences, etc.)
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(() => AppointmentService(sl()));

  // Feature Module Injectors
  initNursingModule(sl);
  initMedicalRecordModule(sl);
  initProfileModule(sl);
  initPharmacogenomicsModule(sl);
  initWellnessGenomicsModule(sl);
}
