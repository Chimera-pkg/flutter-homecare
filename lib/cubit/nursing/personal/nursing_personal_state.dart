import 'dart:convert';

import 'package:equatable/equatable.dart';

class NursingIssue {
  final int id;
  final int userId;
  final String title;
  final String description;
  // final List<String> images; // Change to list of strings
  List<String> images; // Change to list of strings
  final String mobilityStatus;
  // final String relatedHealthRecord;
  final Map<String, dynamic> relatedHealthRecord; // Changed to Map
  final String addOn;
  final double estimatedBudget;
  final String? caseType; // Add case_type field
  final DateTime createdAt;
  final DateTime updatedAt;

  NursingIssue({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.images, // Change to list of strings
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    this.caseType, // Add case_type to constructor
    required this.createdAt,
    required this.updatedAt,
  });
  factory NursingIssue.fromJson(Map<String, dynamic> json) {
    return NursingIssue(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: _parseImages(json['images']),
      mobilityStatus: json['mobility_status'] ?? '',
      // relatedHealthRecord: json['related_health_record'] ?? '',
      relatedHealthRecord: json['related_health_record'] is Map
          ? Map<String, dynamic>.from(json['related_health_record'])
          : {}, // Convert to
      addOn: json['add_on'] ?? '',
      estimatedBudget:
          double.tryParse(json['estimated_budget']?.toString() ?? '') ?? 0.0,
      caseType: json['case_type'], // Add case_type parsing
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  static List<String> _parseImages(dynamic images) {
    if (images == null) return [];
    if (images is List) return images.map((e) => e.toString()).toList();
    if (images is String) {
      try {
        return List<String>.from(jsonDecode(images));
      } catch (e) {
        print("Error parsing images: $e");
        return [];
      }
    }
    return [];
  }

  void updateImageUrls() {
    const String baseUrl = 'https://homecare-api.med-map.org';
    images = images.map((image) {
      if (image.startsWith('http://localhost:3334')) {
        return image.replaceFirst('http://localhost:3334', baseUrl);
      }
      return image;
    }).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'images': images, // Change to list of strings
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord,
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'case_type': caseType, // Add case_type to JSON
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

abstract class NursingPersonalState extends Equatable {
  const NursingPersonalState();

  @override
  List<Object> get props => [];
}

class NursingPersonalInitial extends NursingPersonalState {}

class NursingPersonalLoading extends NursingPersonalState {}

class NursingPersonalLoaded extends NursingPersonalState {
  final List<NursingIssue> issues;

  const NursingPersonalLoaded(this.issues);

  @override
  List<Object> get props => [issues];
}

class NursingPersonalUnauthenticated extends NursingPersonalState {
  const NursingPersonalUnauthenticated();
}

class NursingPersonalError extends NursingPersonalState {
  final String message;

  const NursingPersonalError(this.message);

  @override
  List<Object> get props => [message];
}
