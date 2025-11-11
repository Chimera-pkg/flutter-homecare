import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:m2health/features/appointment/models/appointment.dart';
import 'package:m2health/core/services/appointment_service.dart';
import 'package:meta/meta.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final Dio _dio;
  late final AppointmentService _appointmentService;

  AppointmentCubit(this._dio) : super(AppointmentState.initial()) {
    _appointmentService = AppointmentService(_dio);
  }

  /// Maps the UI tab status to the API status query parameter.
  static String _statusToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return 'accepted'; // 'Upcoming' tab shows 'accepted' appointments
      case AppointmentStatus.pending:
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.missed:
        return status.name;
    }
  }

  /// Fetches appointments for a specific tab, handling pagination and refresh.
  Future<void> fetchAppointments(AppointmentStatus tab,
      {bool isRefresh = false}) async {
    final currentTabData = state.tabData[tab]!;

    // Prevent multiple simultaneous fetches
    if (!isRefresh &&
        (currentTabData.status == LoadStatus.loading ||
            currentTabData.status == LoadStatus.loadingMore ||
            currentTabData.status == LoadStatus.refreshing)) {
      return;
    }

    // If not refreshing and no more data, do nothing
    if (!isRefresh && !currentTabData.hasMore) return;

    final pageToFetch = isRefresh ? 1 : currentTabData.currentPage + 1;
    final currentLoadStatus =
        isRefresh ? LoadStatus.refreshing : LoadStatus.loadingMore;

    // Emit loading state for the specific tab
    emit(state.copyWith(
      tabData: {
        ...state.tabData,
        tab: currentTabData.copyWith(status: currentLoadStatus),
      },
    ));

    log('Fetching appointments for tab: $tab, page: $pageToFetch, loadStatus: $currentLoadStatus',
        name: 'AppointmentCubit');

    try {
      final response = await _appointmentService.fetchPatientAppointments(
        status: _statusToString(tab),
        page: pageToFetch,
      );

      final newAppointments = response.appointments;
      final meta = response.meta;

      final updatedAppointments = isRefresh
          ? newAppointments
          : [...currentTabData.appointments, ...newAppointments];

      // Emit success state for the specific tab
      emit(state.copyWith(
        tabData: {
          ...state.tabData,
          tab: currentTabData.copyWith(
            appointments: updatedAppointments,
            currentPage: meta.currentPage,
            hasMore: meta.currentPage < meta.lastPage,
            status: LoadStatus.success,
          ),
        },
        isAuthError: false,
      ));
    } catch (e) {
      final isAuthError = (e is DioException && e.response?.statusCode == 401);
      emit(state.copyWith(
        tabData: {
          ...state.tabData,
          tab: currentTabData.copyWith(
            status: LoadStatus.failure,
            errorMessage: e.toString(),
          ),
        },
        isAuthError: isAuthError,
      ));
    }
  }

  /// Refreshes all tabs that have already been loaded.
  Future<void> refreshAllTabs() async {
    for (var tab in AppointmentStatus.values) {
      await fetchAppointments(tab, isRefresh: true);
    }
  }

  /// Refreshes specific tabs, e.g., after a status change.
  Future<void> _refreshTabs(List<AppointmentStatus> tabs) async {
    for (var tab in tabs) {
      await fetchAppointments(tab, isRefresh: true);
    }
  }

  Future<void> deleteAppointment(int appointmentId) async {
    try {
      await _appointmentService.deleteAppointment(appointmentId);
      await refreshAllTabs();
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }

  Future<void> cancelAppointment(int appointmentId) async {
    try {
      await _appointmentService.updateAppointmentStatus(
          appointmentId, 'cancelled');
      await _refreshTabs([
        AppointmentStatus.pending,
        AppointmentStatus.upcoming,
        AppointmentStatus.cancelled
      ]);
    } catch (e) {
      print('Error cancelling appointment: $e');
    }
  }
}
