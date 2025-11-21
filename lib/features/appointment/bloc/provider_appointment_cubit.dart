import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/data/models/appointment_model.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/service_locator.dart';
import 'package:m2health/utils.dart';
import 'package:meta/meta.dart';
import 'package:m2health/core/services/appointment_service.dart';

part 'provider_appointment_state.dart';

class ProviderAppointmentCubit extends Cubit<ProviderAppointmentState> {
  final Dio _dio;
  late final AppointmentService _appointmentService;

  ProviderAppointmentCubit(this._dio) : super(ProviderAppointmentInitial()) {
    _appointmentService = AppointmentService(_dio);
  }

  Future<void> fetchProviderAppointments() async {
    try {
      emit(ProviderAppointmentLoading());

      final token = await Utils.getSpString(Const.TOKEN);
      var queryParam = <String, dynamic>{};
      final providerType = await AppointmentManager.getProviderType();
      if (providerType != null) {
        queryParam['provider_type'] = providerType;
      }
      final response = await sl<Dio>().get(
        Const.API_PROVIDER_APPOINTMENTS,
        queryParameters: queryParam,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<dynamic> appointmentsJson = response.data['data'] ?? [];

      final List<AppointmentEntity> appointments = appointmentsJson
          .map((e) => AppointmentModel.fromJson(e))
          .cast<AppointmentEntity>()
          .toList();

      emit(ProviderAppointmentLoaded(appointments));
    } catch (e, stackTrace) {
      log('Error fetching appointments: $e',
          name: 'ProviderAppointmentCubit', error: e, stackTrace: stackTrace);
      emit(ProviderAppointmentError('Failed to fetch appointments'));
    }
  }

  Future<void> acceptAppointment(int appointmentId, {int? screeningId}) async {
    try {
      log('Accepting appointment $appointmentId (screeningId: $screeningId)', name: 'ProviderAppointmentCubit');

      if (screeningId != null) {
        await _appointmentService.acceptScreeningRequest(screeningId);
      } else {
        await _appointmentService.acceptProviderAppointment(appointmentId);
      }

      emit(ProviderAppointmentChangeSucceed(
          message: 'Appointment accepted successfully'));

      fetchProviderAppointments();
    } catch (e) {
      log('Error accepting appointment: $e');
      emit(ProviderAppointmentError(
          'Error accepting appointment: ${e.toString()}'));
    }
  }

  Future<void> rejectAppointment(int appointmentId) async {
    try {
      final currentState = state;
      log('Current state type: ${currentState.runtimeType}');

      await _appointmentService.rejectProviderAppointment(appointmentId);

      emit(ProviderAppointmentChangeSucceed(
          message: 'Appointment declined successfully'));

      fetchProviderAppointments();
    } catch (e, stackTrace) {
      log('Error rejecting appointment: $e',
          name: 'ProviderAppointmentCubit', error: e, stackTrace: stackTrace);
      emit(ProviderAppointmentError(
          'Error rejecting appointment: ${e.toString()}'));
    }
  }

  Future<void> completeAppointment(int appointmentId) async {
    try {
      log('Completing appointment $appointmentId');

      await _appointmentService.completeProviderAppointment(appointmentId);

      emit(ProviderAppointmentChangeSucceed(
          message: 'Appointment completed successfully'));

      fetchProviderAppointments();
    } catch (e) {
      log('Error completing appointment: $e');
      emit(ProviderAppointmentError(
          'Error completing appointment: ${e.toString()}'));
    }
  }

  Future<void> confirmSampleCollected(int screeningId) async {
    try {
      log('Confirming sample collected for screening $screeningId');
      await _appointmentService.confirmScreeningSampleCollected(screeningId);

      emit(ProviderAppointmentChangeSucceed(
          message: 'Sample collection confirmed successfully'));

      fetchProviderAppointments();
    } catch (e) {
      log('Error confirming sample: $e');
      emit(
          ProviderAppointmentError('Error confirming sample: ${e.toString()}'));
    }
  }

  Future<void> markReportReady(int screeningId) async {
    try {
      log('Marking report ready for screening $screeningId');
      await _appointmentService.markScreeningReportReady(screeningId);

      emit(ProviderAppointmentChangeSucceed(message: 'Report marked as ready'));

      fetchProviderAppointments();
    } catch (e) {
      log('Error marking report ready: $e');
      emit(ProviderAppointmentError(
          'Error marking report ready: ${e.toString()}'));
    }
  }
}
