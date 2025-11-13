import 'package:intl/intl.dart';
import 'package:m2health/features/schedule/data/models/time_slot_model.dart';
import 'package:m2health/features/schedule/domain/entities/provider_availability_override.dart';

class ProviderAvailabilityOverrideModel extends ProviderAvailabilityOverride {
  const ProviderAvailabilityOverrideModel({
    required super.date,
    required super.isUnavailble,
    required super.slots,
  });

  factory ProviderAvailabilityOverrideModel.fromJson(
      Map<String, dynamic> json) {
    return ProviderAvailabilityOverrideModel(
      date: DateTime.parse(json['date']),
      isUnavailble: json['is_unavailable'],
      slots: (json['slots'] as List)
          .map((slotJson) => TimeSlotModel.fromJson(slotJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'is_unavailable': isUnavailble,
      'slots': slots.map((slot) {
        if (slot is TimeSlotModel) {
          return slot.toJson();
        }
        throw Exception('Slot is not a TimeSlotModel');
      }).toList(),
    };
  }

  factory ProviderAvailabilityOverrideModel.fromEntity(
      ProviderAvailabilityOverride entity) {
    return ProviderAvailabilityOverrideModel(
      date: entity.date,
      isUnavailble: entity.isUnavailble,
      slots: entity.slots
          .map((slot) => TimeSlotModel(
                startTime: slot.startTime,
                endTime: slot.endTime,
              ))
          .toList(),
    );
  }
}
