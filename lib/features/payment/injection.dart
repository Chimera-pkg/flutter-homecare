import 'package:get_it/get_it.dart';
import 'package:m2health/features/payment/data/datasources/feedback_remote_data_source.dart';
import 'package:m2health/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:m2health/features/payment/data/repositories/feedback_repository_impl.dart';
import 'package:m2health/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:m2health/features/payment/domain/repositories/feedback_repository.dart';
import 'package:m2health/features/payment/domain/repositories/payment_repository.dart';
import 'package:m2health/features/payment/domain/usecases/create_payment.dart';
import 'package:m2health/features/payment/domain/usecases/submit_feedback.dart';

void initPaymentModule(GetIt sl) {
  // Use Cases
  sl.registerLazySingleton(() => CreatePayment(sl()));
  sl.registerLazySingleton(() => SubmitFeedback(sl()));

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSourceImpl(dio: sl()),
  );
}
