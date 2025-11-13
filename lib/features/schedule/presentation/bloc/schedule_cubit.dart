import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';
import 'package:m2health/features/schedule/domain/usecases/index.dart';
import 'package:m2health/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetAvailabilities getAvailabilities;
  final AddAvailability addAvailability;
  final UpdateAvailability updateAvailability;
  final DeleteAvailability deleteAvailability;
  final GetAllOverrides getAllOverrides;
  final UpdateOverride updateOverride;
  final DeleteOverride deleteOverride;
  final GetSlotsPreview getSlotsPreview;

  ScheduleCubit({
    required this.getAvailabilities,
    required this.addAvailability,
    required this.updateAvailability,
    required this.deleteAvailability,
    required this.getAllOverrides,
    required this.updateOverride,
    required this.deleteOverride,
    required this.getSlotsPreview,
  }) : super(const ScheduleState());

  Future<void> loadSchedules() async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final results = await Future.wait([
      getAvailabilities(),
      getAllOverrides(),
    ]);

    final availabilitiesResult = results[0];
    final overridesResult = results[1];

    availabilitiesResult.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (availabilities) {
        overridesResult.fold(
          (failure) =>
              emit(state.copyWith(isLoading: false, error: failure.message)),
          (overrides) => emit(state.copyWith(
            isLoading: false,
            availabilities: List<ProviderAvailability>.from(availabilities),
            overrides: List<ProviderAvailabilityOverride>.from(overrides),
          )),
        );
      },
    );
  }

  // --- Weekly ---
  Future<void> saveWeeklyRule(AddAvailabilityParams params) async {
    // Set timezone
    String timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
    log('Timezone: $timezone', name: 'ScheduleCubit');
    final result = await addAvailability(params.copyWith(timezone: timezone));
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(
            state.copyWith(successMessage: 'Availability added!', error: null));
        loadSchedules();
      },
    );
  }

  Future<void> updateWeeklyRule(UpdateAvailabilityParams params) async {
    // Set timezone
    String timezone = (await FlutterTimezone.getLocalTimezone()).identifier;
    log('Timezone: $timezone', name: 'ScheduleCubit');
    final result =
        await updateAvailability(params.copyWith(timezone: timezone));
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(state.copyWith(
            successMessage: 'Availability updated!', error: null));
        loadSchedules();
      },
    );
  }

  Future<void> deleteWeeklyRule(int id) async {
    final result = await deleteAvailability(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(state.copyWith(
            successMessage: 'Availability removed!', error: null));
        loadSchedules();
      },
    );
  }

  // --- Overrides ---
  Future<void> setDateUnavailable(DateTime date) async {
    final override = ProviderAvailabilityOverride(
      date: date,
      isUnavailble: true,
      slots: const [],
    );
    await _upsertOverride(override);
  }

  Future<void> addSlotToDate(
      DateTime date, DateTime start, DateTime end) async {
    final existing = state.overrides.firstWhere(
      (o) => isSameDay(o.date, date),
      orElse: () => ProviderAvailabilityOverride(
        date: date,
        isUnavailble: false,
        slots: const [],
      ),
    );

    // Convert the local DateTime (from UI) to UTC ISO String
    // Example: Local 9AM (+7) -> UTC 2AM -> "2025-11-10T02:00:00.000Z"
    final newSlot = TimeSlot(
      startTime: start.toUtc().toIso8601String(),
      endTime: end.toUtc().toIso8601String(),
    );

    final updatedSlots = List<TimeSlot>.from(existing.slots)..add(newSlot);

    final updatedOverride = ProviderAvailabilityOverride(
      date: date,
      isUnavailble: false,
      slots: updatedSlots,
    );

    await _upsertOverride(updatedOverride);
  }

  /// 3. Remove a specific slot from a date
  Future<void> removeSlotFromDate(DateTime date, TimeSlot slotToRemove) async {
    final existing = state.overrides.firstWhere(
      (o) => isSameDay(o.date, date),
      orElse: () => throw Exception("Override not found"),
    );

    final updatedSlots = List<TimeSlot>.from(existing.slots)
      ..remove(slotToRemove);

    final updatedOverride = ProviderAvailabilityOverride(
      date: date,
      isUnavailble: false,
      slots: updatedSlots,
    );

    await _upsertOverride(updatedOverride);
  }

  ///  Delete the override entirely (Revert to Weekly)
  Future<void> revertToWeekly(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    emit(state.copyWith(isLoading: true));
    final result = await deleteOverride(dateStr);
    result.fold(
      (failure) {
        log('Failed to delete override: ${failure.message}',
            name: 'ScheduleCubit');
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (_) {
        emit(state.copyWith(
            isLoading: false, successMessage: 'Reverted to weekly schedule'));
        loadSchedules();
      },
    );
  }

  /// Helper to call the Update/Upsert usecase
  Future<void> _upsertOverride(ProviderAvailabilityOverride override) async {
    emit(state.copyWith(isLoading: true));
    final result = await updateOverride(override);
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) {
        emit(state.copyWith(
            isLoading: false, successMessage: 'Schedule updated successfully'));
        loadSchedules();
      },
    );
  }

  // --- Preview ---
  Future<void> loadPreviewSlots(DateTime date) async {
    emit(state.copyWith(isPreviewLoading: true, availableSlots: []));

    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    final String timezone = currentTimeZone.identifier;
    log('Timezone: $timezone', name: 'ScheduleCubit');
    final params = GetSlotsPreviewParams(
      date: DateFormat('yyyy-MM-dd').format(date),
      timezone: timezone,
    );

    final result = await getSlotsPreview(params);
    result.fold(
      (failure) =>
          emit(state.copyWith(isPreviewLoading: false, error: failure.message)),
      (slots) =>
          emit(state.copyWith(isPreviewLoading: false, availableSlots: slots)),
    );
  }

  void clearMessages() {
    emit(state.copyWith(error: null, successMessage: null));
  }
}
