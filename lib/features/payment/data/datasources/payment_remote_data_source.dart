import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/payment/data/model/payment_model.dart';
import 'package:m2health/utils.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<PaymentModel> createPayment({
    required int appointmentId,
    required String method,
    required double amount,
  }) async {
    final token = await Utils.getSpString(Const.TOKEN);
    if (token == null) {
      throw const UnauthorizedFailure('User is not authenticated');
    }

    try {
      final response = await dio.post(
        '${Const.URL_API}/payments', // API Endpoint
        data: {
          'appointment_id': appointmentId,
          'method': method,
          'amount': amount,
          'status': 'pending', // As per your API spec
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The API returns the created payment object
        return PaymentModel.fromJson(response.data);
      } else {
        throw ServerFailure(
            response.data?['message'] ?? 'Failed to create payment');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedFailure('Session expired. Please log in again.');
      }
      throw ServerFailure(
          e.response?.data?['message'] ?? e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}