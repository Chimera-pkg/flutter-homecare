import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:m2health/features/appointment/appointment_module.dart';
import 'package:m2health/features/appointment/models/appointment.dart';
import 'package:m2health/models/provider_appointment.dart';
import 'package:m2health/services/appointment_service.dart';
import 'package:meta/meta.dart';

part 'provider_appointment_detail_state.dart';

class ProviderAppointmentDetailCubit
    extends Cubit<ProviderAppointmentDetailState> {
  final AppointmentService _appointmentService;
  ProviderAppointmentDetailCubit(this._appointmentService)
      : super(ProviderAppointmentDetailInitial());

  Future<void> fetchProviderAppointmentById(int appointmentId) async {
    try {
      emit(ProviderAppointmentDetailLoading());
      final appointment =
          await _appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ProviderAppointmentDetailLoaded(appointment));
    } catch (e) {
      log('Error fetching appointment detail: $e',
          name: 'ProviderAppointmentDetailCubit');
      emit(ProviderAppointmentDetailError('Error: $e'));
    }
  }
}
