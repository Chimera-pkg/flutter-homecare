part of 'schedule_appointment_cubit.dart';

class ScheduleAppointmentState extends Equatable {
  final ActionStatus status; // for fetching available time slots
  final List<TimeSlot> slots;
  final DateTime? selectedTime;
  final String? errorMessage; // error for fetching slots

  final ActionStatus rescheduleStatus;
  final String? rescheduleErrorMessage;

  const ScheduleAppointmentState({
    this.status = ActionStatus.initial,
    this.slots = const [],
    this.selectedTime,
    this.errorMessage,
    this.rescheduleStatus = ActionStatus.initial,
    this.rescheduleErrorMessage,
  });

  ScheduleAppointmentState copyWith({
    ActionStatus? status,
    List<TimeSlot>? slots,
    DateTime? selectedTime,
    String? errorMessage,
    ActionStatus? rescheduleStatus,
    String? rescheduleErrorMessage,
  }) {
    return ScheduleAppointmentState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      selectedTime: selectedTime ?? this.selectedTime,
      errorMessage: errorMessage ?? this.errorMessage,
      rescheduleStatus: rescheduleStatus ?? this.rescheduleStatus,
      rescheduleErrorMessage:
          rescheduleErrorMessage ?? this.rescheduleErrorMessage,
    );
  }

  factory ScheduleAppointmentState.initial() {
    return const ScheduleAppointmentState();
  }

  factory ScheduleAppointmentState.loading() {
    return const ScheduleAppointmentState(status: ActionStatus.loading);
  }

  factory ScheduleAppointmentState.success({
    required List<TimeSlot> slots,
    DateTime? selectedTime,
  }) {
    return ScheduleAppointmentState(
      status: ActionStatus.success,
      slots: slots,
      selectedTime: selectedTime,
    );
  }

  factory ScheduleAppointmentState.error(String errorMessage) {
    return ScheduleAppointmentState(
      status: ActionStatus.error,
      errorMessage: errorMessage,
    );
  }


  @override
  List<Object?> get props => [status, slots, selectedTime, errorMessage];
}