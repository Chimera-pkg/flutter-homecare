import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/domain/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';

class CreatePayment {
  final PaymentRepository repository;

  CreatePayment(this.repository);

  Future<Either<Failure, Payment>> call(PaymentParams params) async {
    return await repository.createPayment(
      appointmentId: params.appointmentId,
      method: params.method,
      amount: params.amount,
    );
  }
}

class PaymentParams extends Equatable {
  final int appointmentId;
  final String method;
  final double amount;

  const PaymentParams({
    required this.appointmentId,
    required this.method,
    required this.amount,
  });

  @override
  List<Object?> get props => [appointmentId, method, amount];
}