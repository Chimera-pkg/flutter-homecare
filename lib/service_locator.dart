import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:m2health/core/network/token_expiration_interceptor.dart';
import 'package:m2health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m2health/features/booking_appointment/injection.dart';
import 'package:m2health/features/medical_record/injection.dart';
import 'package:m2health/features/payment/injection.dart';
import 'package:m2health/features/pharmacogenomics/injection.dart';
import 'package:m2health/features/profiles/injection.dart';
import 'package:m2health/features/schedule/injection.dart';
import 'package:m2health/features/wellness_genomics/injection.dart';
import 'package:m2health/core/services/appointment_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External Dependencies (like Dio, SharedPreferences, etc.)
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(TokenExpirationInterceptor());
    return dio;
  });
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerLazySingleton(() => AppointmentService(sl()));

  // Feature Module Injectors
  initBookingAppointmentModule(sl);
  initPaymentModule(sl);
  initMedicalRecordModule(sl);
  initProfileModule(sl);
  initPharmacogenomicsModule(sl);
  initWellnessGenomicsModule(sl);
  initScheduleModule(sl);
}
