part of 'appointment_cubit.dart';

@immutable
abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentLoaded(this.appointments);
}

class AppointmentError extends AppointmentState {
  final String message;
  final bool needLogin;

  AppointmentError(this.message, {this.needLogin = false});
}
