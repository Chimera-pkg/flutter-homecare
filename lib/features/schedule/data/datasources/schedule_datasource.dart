import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/schedule/data/models/provider_availability_model.dart';
import 'package:m2health/features/schedule/data/models/provider_availability_override_model.dart';
import 'package:m2health/features/schedule/data/models/time_slot_model.dart';
import 'package:m2health/utils.dart';

abstract class ScheduleRemoteDatasource {
  Future<List<ProviderAvailabilityModel>> getAvailabilities();
  Future<ProviderAvailabilityModel> addAvailability(Map<String, dynamic> data);
  Future<ProviderAvailabilityModel> updateAvailability(
      int id, Map<String, dynamic> data);
  Future<void> deleteAvailability(int id);

  // --- Overrides ---
  Future<List<ProviderAvailabilityOverrideModel>> getAllOverrides();
  Future<ProviderAvailabilityOverrideModel> getOverrideByDate(String date);
  Future<void> updateOverride(ProviderAvailabilityOverrideModel data);
  Future<void> deleteOverrideByDate(String date);

  Future<List<TimeSlotModel>> getAvailableSlots(String date, String? timezone);
}

class ScheduleRemoteDatasourceImpl implements ScheduleRemoteDatasource {
  final Dio dio;
  ScheduleRemoteDatasourceImpl({required this.dio});

  Future<Options> _getAuthHeaders() async {
    final token = await Utils.getSpString(Const.TOKEN);
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<ProviderAvailabilityModel>> getAvailabilities() async {
    try {
      final response = await dio.get(
        Const.API_SCHEDULE_AVAILABILITY,
        options: await _getAuthHeaders(),
      );
      return (response.data['data'] as List)
          .map((e) => ProviderAvailabilityModel.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      if (e is DioException) {
        log('DioException: ${e.response?.data}',
            name: 'ScheduleRemoteDatasourceImpl');
      }
      log('Error in getAvailabilities',
          name: 'ScheduleRemoteDatasourceImpl',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ProviderAvailabilityModel> addAvailability(
      Map<String, dynamic> data) async {
    final response = await dio.post(
      Const.API_SCHEDULE_AVAILABILITY,
      data: data,
      options: await _getAuthHeaders(),
    );
    return ProviderAvailabilityModel.fromJson(response.data['data']);
  }

  @override
  Future<ProviderAvailabilityModel> updateAvailability(
      int id, Map<String, dynamic> data) async {
    final response = await dio.put(
      '${Const.API_SCHEDULE_AVAILABILITY}/$id',
      data: data,
      options: await _getAuthHeaders(),
    );
    return ProviderAvailabilityModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteAvailability(int id) async {
    await dio.delete(
      '${Const.API_SCHEDULE_AVAILABILITY}/$id',
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<List<ProviderAvailabilityOverrideModel>> getAllOverrides() async {
    try {
      final response = await dio.get(
        Const.API_SCHEDULE_OVERRIDES,
        options: await _getAuthHeaders(),
      );
      log('Response data: ${response.data}',
          name: 'ScheduleRemoteDatasourceImpl');
      return (response.data['data'] as List)
          .map((e) => ProviderAvailabilityOverrideModel.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      if (e is DioException) {
        log('DioException: ${e.response?.data}',
            name: 'ScheduleRemoteDatasourceImpl');
      }
      log('Error in getAllOverrides',
          name: 'ScheduleRemoteDatasourceImpl',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<ProviderAvailabilityOverrideModel> getOverrideByDate(
      String date) async {
    final response = await dio.get(
      '${Const.API_SCHEDULE_OVERRIDES}/$date',
      options: await _getAuthHeaders(),
    );
    return ProviderAvailabilityOverrideModel.fromJson(response.data['data']);
  }

  @override
  Future<void> updateOverride(ProviderAvailabilityOverrideModel data) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(data.date);
    try {
      final payload = data.toJson();
      await dio.put(
        '${Const.API_SCHEDULE_OVERRIDES}',
        data: payload,
        options: await _getAuthHeaders(),
      );
    } catch (e, stackTrace) {
      if (e is DioException) {
        log('DioException: ${e.response?.data}',
            name: 'ScheduleRemoteDatasourceImpl');
      }
      log('Error in updateOverride',
          name: 'ScheduleRemoteDatasourceImpl',
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteOverrideByDate(String date) async {
    await dio.delete(
      '${Const.API_SCHEDULE_OVERRIDES}/$date',
      options: await _getAuthHeaders(),
    );
  }

  @override
  Future<List<TimeSlotModel>> getAvailableSlots(
      String date, String? timezone) async {
    final response = await dio.get(
      Const.API_SCHEDULE_PREVIEW_SLOTS,
      queryParameters: {
        'date': date,
        'timezone': timezone,
      },
      options: await _getAuthHeaders(),
    );
    return (response.data['data'] as List)
        .map((e) => TimeSlotModel.fromJson(e))
        .toList();
  }
}
