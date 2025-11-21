import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/const.dart';
import 'package:m2health/core/domain/entities/appointment_entity.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:m2health/utils.dart';
import 'package:meta/meta.dart';

part 'screening_report_state.dart';

class ScreeningReportCubit extends Cubit<ScreeningReportState> {
  final AppointmentService appointmentService;
  final Dio dio;

  ScreeningReportCubit({
    required this.appointmentService,
    required this.dio,
  }) : super(ScreeningReportInitial());

  Future<void> fetchReports(int appointmentId) async {
    try {
      emit(ScreeningReportLoading());
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      emit(ScreeningReportError('Failed to fetch reports: $e'));
    }
  }

  Future<void> uploadReport(
      int appointmentId, int screeningRequestId, File file) async {
    try {
      emit(ScreeningReportLoading());

      final token = await Utils.getSpString(Const.TOKEN);
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "screening_request_id": screeningRequestId,
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      await dio.post(
        '${Const.URL_API}/screening-reports',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Refresh data
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Report uploaded successfully',
        updatedAppointment: appointment,
        action: ScreeningReportAction.upload,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error uploading: $e');
      emit(ScreeningReportError('Failed to upload report: $e'));
      fetchReports(appointmentId);
    }
  }

  Future<void> deleteReport(int appointmentId, int reportId) async {
    try {
      emit(ScreeningReportLoading());

      final token = await Utils.getSpString(Const.TOKEN);
      await dio.delete(
        '${Const.URL_API}/screening-reports/$reportId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Refresh data
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Report deleted successfully',
        updatedAppointment: appointment,
        action: ScreeningReportAction.delete,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error deleting: $e');
      emit(ScreeningReportError('Failed to delete report: $e'));
      fetchReports(appointmentId);
    }
  }

  Future<void> markReady(int appointmentId, int screeningRequestId) async {
    try {
      emit(ScreeningReportLoading());

      final token = await Utils.getSpString(Const.TOKEN);
      await dio.post(
        '${Const.URL_API}/screening-requests/$screeningRequestId/report-ready',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Refresh data
      final appointment =
          await appointmentService.fetchAppointmentDetail(appointmentId);
      emit(ScreeningReportActionSuccess(
        'Reports marked as ready',
        updatedAppointment: appointment,
        action: ScreeningReportAction.finalize,
      ));
      emit(ScreeningReportLoaded(appointment));
    } catch (e) {
      log('Error marking ready: $e');
      emit(ScreeningReportError('Failed to mark ready: $e'));
      fetchReports(appointmentId);
    }
  }
}
