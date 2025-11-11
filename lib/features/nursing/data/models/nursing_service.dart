import 'package:m2health/features/nursing/domain/entities/nursing_service_entity.dart';

class NursingServiceModel extends NursingServiceEntity {
  const NursingServiceModel({
    required String title,
    required String description,
    required String imagePath,
    required String color,
    required String opacity,
  }) : super(
          title: title,
          description: description,
          imagePath: imagePath,
          color: color,
          opacity: opacity,
        );

  factory NursingServiceModel.fromMap(Map<String, dynamic> map) {
    return NursingServiceModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      color: map['color'] ?? '',
      opacity: map['opacity'] ?? '',
    );
  }
}
