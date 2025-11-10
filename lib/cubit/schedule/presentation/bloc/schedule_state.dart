import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability.dart';
import 'package:m2health/cubit/schedule/domain/entities/provider_availability_override.dart';
import 'package:m2health/cubit/schedule/domain/entities/time_slot.dart';

class ScheduleState extends Equatable {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final List<ProviderAvailability> availabilities;
  final List<ProviderAvailabilityOverride> overrides;
  final List<TimeSlot> availableSlots;
  final bool isPreviewLoading;

  const ScheduleState({
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.availabilities = const [],
    this.overrides = const [],
    this.availableSlots = const [],
    this.isPreviewLoading = false,
  });

  ScheduleState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
    List<ProviderAvailability>? availabilities,
    List<ProviderAvailabilityOverride>? overrides,
    List<TimeSlot>? availableSlots,
    bool? isPreviewLoading,
  }) {
    return ScheduleState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      availabilities: availabilities ?? this.availabilities,
      overrides: overrides ?? this.overrides,
      availableSlots: availableSlots ?? this.availableSlots,
      isPreviewLoading: isPreviewLoading ?? this.isPreviewLoading,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        successMessage,
        availabilities,
        overrides,
        availableSlots,
        isPreviewLoading,
      ];
}