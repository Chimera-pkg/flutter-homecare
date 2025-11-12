part of 'provider_appointment_detail_cubit.dart';

@immutable
abstract class ProviderAppointmentDetailState {}

class ProviderAppointmentDetailInitial extends ProviderAppointmentDetailState {}

class ProviderAppointmentDetailLoading extends ProviderAppointmentDetailState {}

class ProviderAppointmentDetailLoaded extends ProviderAppointmentDetailState {
  final AppointmentEntity appointment;

  ProviderAppointmentDetailLoaded(this.appointment);
}

class ProviderAppointmentDetailError extends ProviderAppointmentDetailState {
  final String message;

  ProviderAppointmentDetailError(this.message);
}