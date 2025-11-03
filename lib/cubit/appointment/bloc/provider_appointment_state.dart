part of 'provider_appointment_cubit.dart';

@immutable
abstract class ProviderAppointmentState {}

class ProviderAppointmentInitial extends ProviderAppointmentState {}

class ProviderAppointmentLoading extends ProviderAppointmentState {}

class ProviderAppointmentLoaded extends ProviderAppointmentState {
  final List<ProviderAppointment> appointments;

  ProviderAppointmentLoaded(this.appointments);
}

class ProviderAppointmentChangeSucceed extends ProviderAppointmentLoaded {
  final String? message;
  ProviderAppointmentChangeSucceed(super.appointments, {this.message});
}

class ProviderAppointmentError extends ProviderAppointmentState {
  final String message;

  ProviderAppointmentError(this.message);
}
