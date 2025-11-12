import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Unit>> processPayment(double amount, String paymentMethod);
}