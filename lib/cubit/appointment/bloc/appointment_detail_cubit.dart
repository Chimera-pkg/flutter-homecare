import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:m2health/cubit/appointment/models/appointment.dart';
import 'package:m2health/services/appointment_service.dart';
import 'package:meta/meta.dart';

part 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  final AppointmentService _appointmentService;

  AppointmentDetailCubit(
    this._appointmentService,
  ) : super(AppointmentDetailInitial());

  Future<void> fetchAppointmentDetail(int appointmentId) async {
    try {
      emit(AppointmentDetailLoading());

      final appointment =
          await _appointmentService.fetchAppointmentDetail(appointmentId);

      emit(AppointmentDetailLoaded(appointment));
    } catch (e, stackTrace) {
      log('Error fetching appointment detail: $e',
          stackTrace: stackTrace, error: e, name: 'AppointmentDetailCubit');
      emit(AppointmentDetailError(e.toString()));
    }
  }
}
