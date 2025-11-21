part of 'screening_report_cubit.dart';

enum ScreeningReportAction { upload, delete, finalize }

@immutable
abstract class ScreeningReportState {}

class ScreeningReportInitial extends ScreeningReportState {}

class ScreeningReportLoading extends ScreeningReportState {}

class ScreeningReportLoaded extends ScreeningReportState {
  final AppointmentEntity appointment;
  ScreeningReportLoaded(this.appointment);
}

class ScreeningReportActionSuccess extends ScreeningReportState {
  final String message;
  final AppointmentEntity? updatedAppointment;
  final ScreeningReportAction action;
  ScreeningReportActionSuccess(this.message, {this.updatedAppointment, required this.action});
}

class ScreeningReportError extends ScreeningReportState {
  final String message;
  ScreeningReportError(this.message);
}