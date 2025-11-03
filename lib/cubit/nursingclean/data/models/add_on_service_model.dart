import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';

class AddOnServiceModel extends AddOnService {
  const AddOnServiceModel({
    super.id,
    required super.name,
    super.description,
    required super.price,
  });

  factory AddOnServiceModel.fromJson(Map<String, dynamic> json) {
    return AddOnServiceModel(
      id: json['id'],
      name: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
    );
  }
}
