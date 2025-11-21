import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';

class ScreeningCategoryModel extends ScreeningCategory {
  const ScreeningCategoryModel({
    required super.id,
    required super.name,
    required super.items,
  });

  factory ScreeningCategoryModel.fromJson(Map<String, dynamic> json) {
    return ScreeningCategoryModel(
      id: json['id'],
      name: json['name'],
      items: (json['items'] as List)
          .map((item) => ScreeningItemModel.fromJson(item))
          .toList(),
    );
  }
}

class ScreeningItemModel extends ScreeningItem {
  const ScreeningItemModel({
    required super.id,
    required super.name,
    required super.price,
    super.description,
  });

  factory ScreeningItemModel.fromJson(Map<String, dynamic> json) {
    return ScreeningItemModel(
      id: json['id'],
      name: json['name'],
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.parse(json['price'].toString()),
      description: json['description'],
    );
  }
}
