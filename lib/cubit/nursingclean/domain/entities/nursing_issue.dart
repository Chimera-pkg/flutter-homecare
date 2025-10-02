import 'package:equatable/equatable.dart';
import 'dart:io';

class NursingIssue extends Equatable {
  final String title;
  final String description;
  final List<File> images;

  const NursingIssue({
    required this.title,
    required this.description,
    required this.images,
  });

  @override
  List<Object?> get props => [title, description, images];
}
