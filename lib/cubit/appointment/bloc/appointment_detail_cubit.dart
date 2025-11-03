import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:m2health/cubit/appointment/models/appointment.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';
import 'package:m2health/services/appointment_service.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final AppointmentService _appointmentService;

  AppointmentDetailCubit(Dio dio)
      : _appointmentService = AppointmentService(dio),
        super(AppointmentDetailInitial());

  Future<void> fetchAppointmentDetail(int appointmentId) async {
    try {
      emit(AppointmentDetailLoading());

      // Fetch appointment details and user profile in parallel
      final responses = await Future.wait([
        _appointmentService.fetchPatientAppointmentDetail(appointmentId),
        _appointmentService.fetchProfile(),
      ]);

      final appointment = responses[0] as Appointment;
      final profile = responses[1] as Profile;

      emit(AppointmentDetailLoaded(appointment, profile));
    } catch (e, stackTrace) {
      log('Error fetching appointment detail: $e',
          stackTrace: stackTrace, error: e, name: 'AppointmentDetailCubit');
      emit(AppointmentDetailError(e.toString()));
    }
  }
}
