import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  });
}
