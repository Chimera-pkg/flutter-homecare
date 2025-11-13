import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/error/failures.dart';
import 'package:m2health/features/appointment/models/appointment.dart';
import 'package:m2health/features/appointment/models/paginated_appointment_response.dart';
// ignore: unused_import
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/features/booking_appointment/nursing/domain/usecases/create_nursing_appointment.dart';
import 'package:m2health/features/profiles/data/models/profile_model.dart';
import 'package:m2health/features/profiles/domain/entities/profile.dart';
import 'package:m2health/core/data/models/provider_appointment.dart';
import 'package:m2health/utils.dart';

class AppointmentService {
  final Dio _dio;

  AppointmentService(this._dio);

  /// Accept provider appointment - Fixed endpoint
  Future<void> acceptProviderAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        '${Const.URL_API}/provider/appointments/$appointmentId/accept',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            // Allow all status codes so we can handle them manually
            return status != null && status < 500;
          },
        ),
      );

      log('Accept appointment response status: ${response.statusCode}',
          name: 'AppointmentService');
      log('Accept appointment response data: ${response.data}',
          name: 'AppointmentService');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('Appointment accepted successfully', name: 'AppointmentService');
      } else if (response.statusCode == 404) {
        throw Exception('Appointment not found or endpoint not available');
      } else if (response.statusCode == 403) {
        throw Exception('Permission denied to accept this appointment');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      } else {
        throw Exception(
            'Failed to accept appointment: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error accepting appointment: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');

        if (e.response?.statusCode == 404) {
          throw Exception(
              'Accept endpoint not found. Please check if the API supports this endpoint.');
        } else if (e.response?.statusCode == 403) {
          throw Exception(
              'Permission denied. You may not be authorized to accept this appointment.');
        } else if (e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        }
      }
      throw Exception('Error accepting appointment: $e');
    }
  }

  /// Reject provider appointment - Enhanced with detailed debugging
  Future<void> rejectProviderAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        '${Const.URL_API}/provider/appointments/$appointmentId/cancel',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Appointment rejected successfully');
      } else if (response.statusCode == 404) {
        log('❌ Appointment not found (404)');
        throw Exception('Appointment not found or endpoint not available');
      } else if (response.statusCode == 403) {
        log('❌ Permission denied (403)');
        throw Exception('Permission denied to reject this appointment');
      } else if (response.statusCode == 401) {
        log('❌ Authentication failed (401)');
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 422) {
        log('❌ Validation error (422)');
        final errorMessage = response.data['message'] ?? 'Validation failed';
        throw Exception('Validation error: $errorMessage');
      } else {
        log('❌ Unexpected response: ${response.statusCode}');
        throw Exception(
            'Failed to reject appointment: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      log(
        'Error rejecting appointment: $e',
        name: 'AppointmentService',
      );

      if (e is DioException) {
        log('DioException type: ${e.type}');
        log('DioException message: ${e.message}');
        log('DioException response status: ${e.response?.statusCode}');
        log('DioException response data: ${e.response?.data}');
        log('DioException request path: ${e.requestOptions.path}');
        log('DioException request headers: ${e.requestOptions.headers}');

        if (e.response?.statusCode == 404) {
          throw Exception(
              'Reject endpoint not found. Please check if the API supports this endpoint.');
        } else if (e.response?.statusCode == 403) {
          throw Exception(
              'Permission denied. You may not be authorized to reject this appointment.');
        } else if (e.response?.statusCode == 401) {
          throw Exception('Authentication failed. Please login again.');
        }
      }

      throw Exception('Error rejecting appointment: $e');
    }
  }

  /// Complete provider appointment - Fixed endpoint
  Future<void> completeProviderAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      print('Attempting to complete appointment $appointmentId');
      print(
          'Using endpoint: ${Const.URL_API}/provider/appointments/$appointmentId/complete');

      final response = await _dio.post(
        '${Const.URL_API}/provider/appointments/$appointmentId/complete',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print('Complete appointment response status: ${response.statusCode}');
      print('Complete appointment response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Appointment completed successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Appointment not found or endpoint not available');
      } else {
        throw Exception(
            'Failed to complete appointment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error completing appointment: $e');
      throw Exception('Error completing appointment: $e');
    }
  }

  /// Fetch provider appointments
  Future<List<ProviderAppointment>> fetchProviderAppointments(
      String providerType) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      print('Fetching provider appointments for: $providerType');
      print(
          'Using endpoint: ${Const.URL_API}/provider/appointments?provider_type=$providerType');

      final response = await _dio.get(
        '${Const.URL_API}/provider/appointments',
        queryParameters: {'provider_type': providerType},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print(
          'Fetch provider appointments response status: ${response.statusCode}');
      print('Fetch provider appointments response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null || response.data['data'] == null) {
          return [];
        }

        final data = response.data['data'] as List;
        return data.map((json) => ProviderAppointment.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Provider appointments endpoint not found');
      } else {
        throw Exception(
            'Failed to load provider appointments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching provider appointments: $e');
      throw Exception('Error fetching provider appointments: $e');
    }
  }

  // Other existing methods...

  Future<PaginatedAppointmentsResponse> fetchPatientAppointments({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };

      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await _dio.get(
        Const.API_APPOINTMENT,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      log('Response data: ${response.data['data']}',
          name: 'AppointmentService');

      if (response.statusCode == 200 && response.data != null) {
        return PaginatedAppointmentsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching patient appointments: $e',
          stackTrace: stackTrace, name: 'AppointmentService');
      rethrow;
    }
  }

  /// Fetches the detail for an appointment.
  Future<AppointmentEntity> fetchAppointmentDetail(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final response = await _dio.get(
        '${Const.API_APPOINTMENT}/$appointmentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return AppointmentModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        log('DioException fetching appointment detail: ${e.message}',
            error: e, name: 'AppointmentService');
      } else {
        log('Error fetching appointment detail: $e',
            error: e, name: 'AppointmentService');
      }
      rethrow;
    }
  }

  Future<Profile> fetchProfile() async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await Dio().get(
        '${Const.URL_API}/profiles', // Assuming this is the correct endpoint
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final profileData = response.data['data'];
        if (profileData is Map<String, dynamic>) {
          return ProfileModel.fromJson(profileData);
        } else {
          throw Exception('Unexpected profile response format');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      log('Error fetching profile: $e',
          error: e, stackTrace: stackTrace, name: 'AppointmentService');
      throw Exception('Failed to load profile: $e');
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.post(
        '${Const.API_APPOINTMENT}/$appointmentId/cancel',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      log('Cancel appointment response status: ${response.statusCode}',
          name: 'AppointmentService');
    } catch (e) {
      if (e is DioException) {
        log('DioException cancelling appointment: ${e.message}',
            error: e, name: 'AppointmentService');
      } else {
        log('Error cancelling appointment: $e',
            error: e, name: 'AppointmentService');
      }
      rethrow;
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.delete(
        '${Const.API_APPOINTMENT}/$appointmentId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete appointment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }

  Future<Map<String, dynamic>> createAppointment(
      Map<String, dynamic> payload) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Validate required fields before sending
      if (payload['provider_id'] == null) {
        throw Exception('Provider ID is required');
      }
      if (payload['provider_type'] == null ||
          payload['provider_type'].toString().isEmpty) {
        throw Exception('Provider type is required');
      }

      log('Creating appointment with payload:\n$payload',
          name: 'AppointmentService');

      final response = await _dio.post(
        Const.API_APPOINTMENT,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      log('Create appointment response status: ${response.statusCode}',
          name: 'AppointmentService');
      log('Create appointment response data: ${response.data}',
          name: 'AppointmentService');

      return response.data;
    } catch (e, stackTrace) {
      log(
        'Error creating appointment',
        name: 'AppointmentService',
        error: e,
        stackTrace: stackTrace,
      );
      if (e is DioException) {
        log('DioException message: ${e.message}', name: 'AppointmentService');
        log('DioException response: ${e.response?.data}',
            name: 'AppointmentService');

        if (e.response?.data['code'] == 'E_VALIDATION_ERROR') {
          final errorData = e.response?.data;
          if (errorData != null && errorData['errors'] != null) {
            final errors = errorData['errors'] as List;
            final errorDetails = errors
                .map((error) => '${error['field']}: ${error['message']}')
                .join(', ');
          }
        }
        throw BadRequestFailure(e.response?.data['message']);
      }
      throw Exception('Unknown error creating appointment.');
    }
  }

  Future<Map<String, dynamic>> updateAppointment(
      int appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      // Ensure user_id is included and is a number
      final dataToSend = appointmentData;

      print('Updating appointment $appointmentId with data: $dataToSend');

      final response = await _dio.put(
        '${Const.API_APPOINTMENT}/$appointmentId',
        data: dataToSend, // Send as Map, not JSON string
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Update appointment response status: ${response.statusCode}');
      print('Update appointment response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
            'Failed to update appointment: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error updating appointment: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');

        if (e.response?.statusCode == 422) {
          final errorDetails = e.response?.data;
          throw Exception(
              'Validation error: ${errorDetails ?? 'Invalid data provided'}');
        }
      }
      throw Exception('Error updating appointment: $e');
    }
  }
}
