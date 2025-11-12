import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/domain/entities/feedback.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, FeedbackEntity>> submitFeedback({
    required int appointmentId,
    required int stars,
    String? text,
    String? tips,
  });
}