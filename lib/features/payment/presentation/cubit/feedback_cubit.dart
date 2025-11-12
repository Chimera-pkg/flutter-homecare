import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/payment/domain/entities/feedback.dart';
import 'package:m2health/features/payment/domain/usecases/submit_feedback.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final SubmitFeedback submitFeedbackUseCase;

  FeedbackCubit({required this.submitFeedbackUseCase}) : super(FeedbackInitial());

  Future<void> submitFeedback({
    required int appointmentId,
    required int stars,
    String? text,
    String? tips,
  }) async {
    emit(FeedbackLoading());
    final params = FeedbackParams(
      appointmentId: appointmentId,
      stars: stars,
      text: text,
      tips: tips,
    );
    final failureOrFeedback = await submitFeedbackUseCase(params);

    failureOrFeedback.fold(
      (failure) => emit(FeedbackFailure(failure.message)),
      (feedback) => emit(FeedbackSuccess(feedback)),
    );
  }
}