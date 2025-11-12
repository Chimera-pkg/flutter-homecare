import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/entities/time_slot.dart';
import 'package:m2health/features/booking_appointment/schedule_appointment/domain/usecases/get_available_time_slot.dart';
import 'package:m2health/features/booking_appointment/personal_issue/presentation/bloc/personal_issues_state.dart';
import 'package:table_calendar/table_calendar.dart'; // For isSameDay

part 'schedule_appointment_state.dart';

class ScheduleAppointmentCubit extends Cubit<ScheduleAppointmentState> {
  final GetAvailableTimeSlots _getAvailableTimeSlots;

  ScheduleAppointmentCubit(
      {required GetAvailableTimeSlots getAvailableTimeSlots})
      : _getAvailableTimeSlots = getAvailableTimeSlots,
        super(const ScheduleAppointmentState());

  Future<void> fetchSlots({
    required int providerId,
    required String providerType,
    required DateTime date,
    TimeSlot? currentlyBookedSlot,
  }) async {
    emit(ScheduleAppointmentState.loading());

    final params = GetAvailableTimeSlotsParams(
      providerId: providerId,
      providerType: providerType,
      date: date,
    );
    final result = await _getAvailableTimeSlots(params);

    result.fold(
      (failure) => emit(ScheduleAppointmentState.error(failure.message)),
      (slots) {
        List<TimeSlot> finalSlots = List<TimeSlot>.from(slots);
        DateTime? newSelectedTime;

        // --- Reschedule Logic ---
        if (currentlyBookedSlot != null &&
            isSameDay(currentlyBookedSlot.startTime, date) &&
            !finalSlots.any(
                (slot) => slot.startTime == currentlyBookedSlot.startTime)) {
          finalSlots.add(currentlyBookedSlot);
          finalSlots.sort((a, b) => a.startTime.compareTo(b.startTime));
        }

        // Pre-select the time if it's the currently booked one on this day
        if (currentlyBookedSlot != null &&
            isSameDay(currentlyBookedSlot.startTime, date)) {
          newSelectedTime = currentlyBookedSlot.startTime;
        }
        // --- End Reschedule Logic ---

        emit(ScheduleAppointmentState.success(
          slots: finalSlots,
          selectedTime: newSelectedTime,
        ));
      },
    );
  }

  void selectTime(DateTime time) {
    emit(state.copyWith(selectedTime: time));
  }

  Future<void> rescheduleAppointment({
    required int appointmentId,
    required DateTime newTime,
  }) async {
    emit(state.copyWith(
      rescheduleStatus: ActionStatus.loading,
      rescheduleErrorMessage: null,
    ));

    try {
      // Simulate rescheduling logic
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(rescheduleStatus: ActionStatus.success));
    } catch (e, stackTrace) {
      log('Error rescheduling appointment: $e',
          stackTrace: stackTrace, error: e, name: 'ScheduleAppointmentCubit');
      emit(state.copyWith(
        rescheduleStatus: ActionStatus.error,
        rescheduleErrorMessage:
            'Failed to reschedule appointment. Please try again.',
      ));
    }
  }
}
