part of 'appointment_detail_cubit.dart';

@immutable
abstract class AppointmentDetailState {}

class AppointmentDetailInitial extends AppointmentDetailState {}

class AppointmentDetailLoading extends AppointmentDetailState {}

class AppointmentDetailLoaded extends AppointmentDetailState {
  final Appointment appointment;
  final Profile profile;
  AppointmentDetailLoaded(this.appointment, this.profile);
}

class AppointmentDetailError extends AppointmentDetailState {
  final String message;
  AppointmentDetailError(this.message);
}
