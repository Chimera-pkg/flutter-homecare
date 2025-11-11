import 'package:m2health/features/schedule/domain/entities/provider_availability.dart';

class ProviderAvailabilityModel extends ProviderAvailability {
  const ProviderAvailabilityModel({
    required super.id,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    super.timezone,
  });

  factory ProviderAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return ProviderAvailabilityModel(
      id: json['id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      timezone: json['timezone'],
    );
  }
}