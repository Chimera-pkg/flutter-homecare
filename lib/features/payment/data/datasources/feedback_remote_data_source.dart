import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/model/feedback_model.dart';
import 'package:m2health/utils.dart';

abstract class FeedbackRemoteDataSource {
  Future<FeedbackModel> submitFeedback({
    required int appointmentId,
    required int stars,
    String? text,
    String? tips,
  });
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final Dio dio;

  FeedbackRemoteDataSourceImpl({required this.dio});

  @override
  Future<FeedbackModel> submitFeedback({
    required int appointmentId,
    required int stars,
    String? text,
    String? tips,
  }) async {
    final token = await Utils.getSpString(Const.TOKEN);
    if (token == null) {
      throw const UnauthorizedFailure('User is not authenticated');
    }

    try {
      final response = await dio.post(
        '${Const.URL_API}/feedbacks',
        data: {
          'appointment_id': appointmentId,
          'stars': stars,
          'text': text,
          'tips': tips,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        return FeedbackModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            response.data?['message'] ?? 'Failed to submit feedback');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure(
            'Session expired. Please log in again.');
      }
      if (e.response?.statusCode == 422) {
        // Handle validation errors
        final errors = e.response?.data?['errors'] as List?;
        final message = errors?.first?['message'] ?? 'Invalid data';
        throw ServerFailure(message);
      }
      throw ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
