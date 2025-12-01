import 'package:equatable/equatable.dart';
import 'dart:io';

class PersonalIssue extends Equatable {
  final int? id;
  final String type; // nurse, pharmacist
  final String title;
  final String description;
  final List<File> images; // For new images to upload for CREATE
  final Map<int, File> newImages; // For new images to upload for UPDATE
  final List<String> imageUrls; // For existing images from backend
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PersonalIssue({
    this.id,
    required this.type,
    required this.title,
    required this.description,
    this.images = const [],
    this.newImages = const {},
    this.imageUrls = const [],
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, description, images, newImages, imageUrls];
}