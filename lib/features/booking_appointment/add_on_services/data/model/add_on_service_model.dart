import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';

class AddOnServiceModel extends AddOnService {
  const AddOnServiceModel({
    super.id,
    required super.name,
    required super.price,
    required super.serviceType,
  });

  factory AddOnServiceModel.fromJson(Map<String, dynamic> json) {
    return AddOnServiceModel(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
      serviceType: json['service_type'] ?? 'nursing',
    );
  }
}
