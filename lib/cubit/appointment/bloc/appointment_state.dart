part of 'appointment_cubit.dart';

enum AppointmentStatus { pending, upcoming, completed, cancelled, missed }

enum LoadStatus { initial, loading, success, failure, loadingMore, refreshing }

class AppointmentTabData {
  final List<Appointment> appointments;
  final int currentPage;
  final bool hasMore;
  final LoadStatus status;
  final String? errorMessage;

  AppointmentTabData({
    this.appointments = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.status = LoadStatus.initial,
    this.errorMessage,
  });

  AppointmentTabData copyWith({
    List<Appointment>? appointments,
    int? currentPage,
    bool? hasMore,
    LoadStatus? status,
    String? errorMessage,
  }) {
    return AppointmentTabData(
      appointments: appointments ?? this.appointments,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@immutable
class AppointmentState {
  final Map<AppointmentStatus, AppointmentTabData> tabData;
  final bool isAuthError;

  const AppointmentState({
    required this.tabData,
    this.isAuthError = false,
  });

  factory AppointmentState.initial() {
    return AppointmentState(
      tabData: {
        for (var status in AppointmentStatus.values)
          status: AppointmentTabData(),
      },
    );
  }

  AppointmentState copyWith({
    Map<AppointmentStatus, AppointmentTabData>? tabData,
    bool? isAuthError,
  }) {
    return AppointmentState(
      tabData: tabData ?? this.tabData,
      isAuthError: isAuthError ?? this.isAuthError,
    );
  }
}
