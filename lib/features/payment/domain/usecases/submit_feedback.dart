import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/entities/feedback.dart';
import 'package:m2health/features/payment/domain/repositories/feedback_repository.dart';

class SubmitFeedback {
  final FeedbackRepository repository;

  SubmitFeedback(this.repository);

  Future<Either<Failure, FeedbackEntity>> call(FeedbackParams params) async {
    return await repository.submitFeedback(
      appointmentId: params.appointmentId,
      stars: params.stars,
      text: params.text,
      tips: params.tips,
    );
  }
}

class FeedbackParams extends Equatable {
  final int appointmentId;
  final int stars;
  final String? text;
  final String? tips;

  const FeedbackParams({
    required this.appointmentId,
    required this.stars,
    this.text,
    this.tips,
  });

  @override
  List<Object?> get props => [appointmentId, stars, text, tips];
}