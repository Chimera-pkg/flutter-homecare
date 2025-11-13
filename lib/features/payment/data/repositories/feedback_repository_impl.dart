import 'package:dartz/dartz.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/datasources/feedback_remote_data_source.dart';
import 'package:m2health/features/payment/domain/entities/feedback.dart';
import 'package:m2health/features/payment/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, FeedbackEntity>> submitFeedback({
    required int appointmentId,
    required int stars,
    String? text,
    String? tips,
  }) async {
    try {
      final feedback = await remoteDataSource.submitFeedback(
        appointmentId: appointmentId,
        stars: stars,
        text: text,
        tips: tips,
      );
      return Right(feedback);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}