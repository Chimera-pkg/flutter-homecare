import 'package:m2health/cubit/schedule/domain/entities/provider_availability_override.dart';

class ProviderAvailabilityOverrideModel extends ProviderAvailabilityOverride {
  const ProviderAvailabilityOverrideModel({
    required super.id,
    required super.startDatetime,
    required super.endDatetime,
  });

  factory ProviderAvailabilityOverrideModel.fromJson(Map<String, dynamic> json) {
    return ProviderAvailabilityOverrideModel(
      id: json['id'],
      startDatetime: DateTime.parse(json['start_datetime']),
      endDatetime: DateTime.parse(json['end_datetime']),
    );
  }
}