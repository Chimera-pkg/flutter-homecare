import 'package:equatable/equatable.dart';

class NursingServiceEntity extends Equatable {
  final String title;
  final String description;
  final String imagePath;
  final String color;
  final String opacity;

  const NursingServiceEntity({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.color,
    required this.opacity,
  });

  @override
  List<Object?> get props => [title, description, imagePath, color, opacity];
}
