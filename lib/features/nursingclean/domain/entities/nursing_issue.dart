import 'package:equatable/equatable.dart';
import 'dart:io';

class NursingIssue extends Equatable {
  final int? id;
  final String title;
  final String description;
  final List<File> images; // For new images to upload
  final List<String> imageUrls; // For existing images from backend
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NursingIssue({
    this.id,
    required this.title,
    required this.description,
    this.images = const [],
    this.imageUrls = const [],
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, description, images, imageUrls];
}
