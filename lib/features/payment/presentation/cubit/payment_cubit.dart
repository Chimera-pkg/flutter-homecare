import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/payment/domain/entities/payment.dart';
import 'package:m2health/features/payment/domain/usecases/create_payment.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CreatePayment createPaymentUseCase;

  PaymentCubit({required this.createPaymentUseCase}) : super(PaymentInitial());

  Future<void> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    emit(PaymentLoading());
    final params = PaymentParams(
      appointmentId: appointmentId,
      method: method,
      amount: amount,
    );
    final failureOrPayment = await createPaymentUseCase(params);

    failureOrPayment.fold(
      (failure) => emit(PaymentFailure(failure.message)),
      (payment) => emit(PaymentSuccess(payment)),
    );
  }
}
