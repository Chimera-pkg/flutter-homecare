part of 'provider_appointment_cubit.dart';

@immutable
abstract class ProviderAppointmentState {}

class ProviderAppointmentInitial extends ProviderAppointmentState {}

class ProviderAppointmentLoading extends ProviderAppointmentState {}

class ProviderAppointmentLoaded extends ProviderAppointmentState {
  final List<AppointmentEntity> appointments;

  ProviderAppointmentLoaded(this.appointments);
}

class ProviderAppointmentChangeSucceed extends ProviderAppointmentState {
  final String? message;
  ProviderAppointmentChangeSucceed({this.message});
}

class ProviderAppointmentError extends ProviderAppointmentState {
  final String message;

  ProviderAppointmentError(this.message);
}
