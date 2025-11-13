import 'package:equatable/equatable.dart';
import 'package:m2health/features/schedule/domain/entities/time_slot.dart';

class ProviderAvailabilityOverride extends Equatable {
  final DateTime date;
  final bool isUnavailble;
  final List<TimeSlot> slots;

  const ProviderAvailabilityOverride({
    required this.date,
    required this.isUnavailble,
    required this.slots,
  });

  @override
  List<Object?> get props => [date, isUnavailble, slots];
}
