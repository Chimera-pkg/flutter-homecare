import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional: for checking network connection

  PaymentRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, Payment>> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    // if (await networkInfo.isConnected) { // Optional
    try {
      final payment = await remoteDataSource.createPayment(
        appointmentId: appointmentId,
        method: method,
        amount: amount,
      );
      return Right(payment);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
    // } else {
    //   return Left(NetworkFailure('No internet connection'));
    // }
  }
}
