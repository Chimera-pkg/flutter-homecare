import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/data/models/time_slot_model.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';
import 'package:timezone/timezone.dart' as tz;

class ScheduleAppointmentRemoteDataSource {
  final Dio dio;

  ScheduleAppointmentRemoteDataSource({required this.dio});

  Future<List<TimeSlotModel>> getAvailableTimeSlots(
      GetAvailableTimeSlotsParams params) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(params.date);
    final String timezone = tz.local.name;

    final queryParams = {
      'provider_id': params.providerId,
      'provider_type': params.providerType,
      'date': formattedDate,
      'timezone': timezone,
    };

    log('Query Params: $queryParams', name: 'ScheduleRemoteDataSource');

    try {
      final response = await dio.get(
        '${Const.URL_API}/schedule/slots',
        queryParameters: queryParams,
      );

      final dataList = response.data['data'] as List;
      return dataList.map((json) => TimeSlotModel.fromJson(json)).toList();
    } catch (e) {
      if (e is DioException) {
        log('DioException: ${e.response?.data ?? e.message}',
            name: 'ScheduleRemoteDataSource');
      } else {
        log('Error: $e', name: 'ScheduleRemoteDataSource');
      }
      rethrow;
    }
  }

  Future<void> rescheduleAppointment({
    required int appointmentId,
    required DateTime newTime,
  }) async {
    final localTime = tz.TZDateTime.from(newTime, tz.local);
    final formattedTime = localTime.toIso8601String();

    final body = {
      'start_datetime': formattedTime,
    };

    log('Rescheduling Appointment $appointmentId with body: $body',
        name: 'ScheduleRemoteDataSource');

    try {
      await dio.post(
        '${Const.URL_API}/appointments/$appointmentId/reschedule',
        data: body,
      );
    } catch (e) {
      if (e is DioException) {
        log('DioException: ${e.response?.data ?? e.message}',
            name: 'ScheduleRemoteDataSource');
      } else {
        log('Error: $e', name: 'ScheduleRemoteDataSource');
      }
      rethrow;
    }
  }
}
