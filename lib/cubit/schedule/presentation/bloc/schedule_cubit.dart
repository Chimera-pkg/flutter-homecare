import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/cubit/schedule/domain/usecases/index.dart';
import 'package:m2health/cubit/schedule/presentation/bloc/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetAvailabilities getAvailabilities;
  final AddAvailability addAvailability;
  final UpdateAvailability updateAvailability;
  final DeleteAvailability deleteAvailability;
  final GetOverrides getOverrides;
  final AddOverride addOverride;
  final UpdateOverride updateOverride;
  final DeleteOverride deleteOverride;
  final GetAvailableSlots getAvailableSlots;

  ScheduleCubit({
    required this.getAvailabilities,
    required this.addAvailability,
    required this.updateAvailability,
    required this.deleteAvailability,
    required this.getOverrides,
    required this.addOverride,
    required this.updateOverride,
    required this.deleteOverride,
    required this.getAvailableSlots,
  }) : super(const ScheduleState());

  Future<void> loadSchedules() async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final results = await Future.wait([
      getAvailabilities(),
      getOverrides(),
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
            availabilities: availabilities as List<ProviderAvailability>,
            overrides: overrides as List<ProviderAvailabilityOverride>,
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
  Future<void> saveOverride(AddOverrideParams params) async {
    final result = await addOverride(params);
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(state.copyWith(
            successMessage: 'Date override added!', error: null));
        loadSchedules();
      },
    );
  }

  Future<void> updateOverrideRule(UpdateOverrideParams params) async {
    final result = await updateOverride(params);
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(state.copyWith(
            successMessage: 'Date override updated!', error: null));
        loadSchedules();
      },
    );
  }

  Future<void> deleteOverrideRule(int id) async {
    final result = await deleteOverride(id);
    result.fold(
      (failure) =>
          emit(state.copyWith(error: failure.message, successMessage: null)),
      (_) {
        emit(state.copyWith(
            successMessage: 'Date override removed!', error: null));
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
    final params = GetAvailableSlotsParams(
      date: DateFormat('yyyy-MM-dd').format(date),
      timezone: timezone,
    );

    final result = await getAvailableSlots(params);
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
