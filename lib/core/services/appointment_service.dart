import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/appointment/models/appointment.dart';
import 'package:m2health/features/appointment/models/paginated_appointment_response.dart';
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

      print('Attempting to accept appointment $appointmentId');
      print(
          'Using endpoint: ${Const.URL_API}/provider/appointments/$appointmentId/accept');
      print('Token: $token');

      final response = await _dio.put(
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

      print('Accept appointment response status: ${response.statusCode}');
      print('Accept appointment response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Appointment accepted successfully');
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
      final userId = await Utils.getSpString(Const.USER_ID);
      final userRole = await Utils.getSpString(Const.ROLE);

      print('=== REJECTING APPOINTMENT DEBUG ===');
      print('Appointment ID: $appointmentId');
      print('User ID: $userId');
      print('User Role: $userRole');
      print('Token present: ${token != null}');
      print('Token length: ${token?.length ?? 0}');
      if (token != null && token.length > 20) {
        print('Token preview: ${token.substring(0, 20)}...');
      }
      print(
          'Full endpoint: ${Const.URL_API}/provider/appointments/$appointmentId/reject');
      print('Base URL: ${Const.URL_API}');
      print('=== SENDING REJECT REQUEST ===');
      final response = await _dio.put(
        '${Const.URL_API}/provider/appointments/$appointmentId/reject',
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

      print('=== REJECT RESPONSE RECEIVED ===');
      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response data: ${response.data}');
      print('Response status message: ${response.statusMessage}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Appointment rejected successfully');
      } else if (response.statusCode == 404) {
        print('❌ Appointment not found (404)');
        throw Exception('Appointment not found or endpoint not available');
      } else if (response.statusCode == 403) {
        print('❌ Permission denied (403)');
        throw Exception('Permission denied to reject this appointment');
      } else if (response.statusCode == 401) {
        print('❌ Authentication failed (401)');
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 422) {
        print('❌ Validation error (422)');
        final errorMessage = response.data['message'] ?? 'Validation failed';
        throw Exception('Validation error: $errorMessage');
      } else {
        print('❌ Unexpected response: ${response.statusCode}');
        throw Exception(
            'Failed to reject appointment: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('=== REJECT APPOINTMENT ERROR ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');

      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response status: ${e.response?.statusCode}');
        print('DioException response data: ${e.response?.data}');
        print('DioException request path: ${e.requestOptions.path}');
        print('DioException request headers: ${e.requestOptions.headers}');

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
  Future<Appointment> fetchAppointmentDetail(int appointmentId) async {
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

      if (response.statusCode == 200 && response.data['data'] != null) {
        return Appointment.fromJson(response.data['data']);
      } else {
        throw Exception(
            'Failed to load appointment detail: ${response.statusCode}');
      }
    } catch (e) {
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

  Future<void> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);

      final response = await _dio.put(
        '${Const.API_APPOINTMENT}/$appointmentId',
        data: {'status': status},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update appointment status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating appointment status: $e');
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
      Map<String, dynamic> appointmentData) async {
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final userId = await Utils.getSpString(Const.USER_ID);

      // Validate required fields before sending
      if (appointmentData['provider_id'] == null) {
        throw Exception('Provider ID is required');
      }
      if (appointmentData['provider_type'] == null ||
          appointmentData['provider_type'].toString().isEmpty) {
        throw Exception('Provider type is required');
      }

      // Ensure data format is correct
      final dataToSend = {
        'user_id': int.tryParse(userId ?? '1') ?? 1,
        'provider_id': appointmentData['provider_id'],
        'provider_type':
            appointmentData['provider_type'].toString().toLowerCase(),
        'type': appointmentData['type'] ?? appointmentData['provider_type'],
        'status': appointmentData['status'] ?? 'pending',
        'date': appointmentData['date'],
        'hour': appointmentData['hour'],
        'summary': appointmentData['summary'] ?? 'Appointment booking',
        'pay_total': (appointmentData['pay_total'] as num?)?.toDouble() ?? 0.0,
        'profile_services_data': appointmentData['profile_services_data'],
      };

      print('Creating appointment with validated data: $dataToSend');

      final response = await _dio.post(
        Const.API_APPOINTMENT,
        data: dataToSend,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('Create appointment response status: ${response.statusCode}');
      print('Create appointment response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 422) {
        final errorData = response.data;
        String errorMessage = 'Validation failed';

        if (errorData != null && errorData['errors'] != null) {
          final errors = errorData['errors'] as List;
          errorMessage = errors
              .map((error) => '${error['field']}: ${error['message']}')
              .join(', ');
        }

        throw Exception('Validation error: $errorMessage');
      } else {
        throw Exception(
            'Failed to create appointment: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print('Error creating appointment: $e');
      if (e is DioException) {
        print('DioException type: ${e.type}');
        print('DioException message: ${e.message}');
        print('DioException response: ${e.response?.data}');

        if (e.response?.statusCode == 422) {
          final errorData = e.response?.data;
          if (errorData != null && errorData['errors'] != null) {
            final errors = errorData['errors'] as List;
            final errorDetails = errors
                .map((error) => '${error['field']}: ${error['message']}')
                .join(', ');
            throw Exception('Validation error: $errorDetails');
          }
        }
      }
      throw Exception('Error creating appointment: $e');
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
