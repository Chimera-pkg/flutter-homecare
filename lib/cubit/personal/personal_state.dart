import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/medical_record/data/model/medical_record_model.dart';
import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';

class Issue extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String description;
  List<String> images;
  final String mobilityStatus;
  final MedicalRecord? relatedHealthRecord; // Changed from Map to MedicalRecord
  final String addOn;
  final double estimatedBudget;
  final String? caseType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Issue({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.images,
    required this.mobilityStatus,
    this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    this.caseType,
    required this.createdAt,
    required this.updatedAt,
  });

  Issue copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    List<String>? images,
    String? mobilityStatus,
    MedicalRecord? relatedHealthRecord,
    int? relatedHealthRecordId,
    String? addOn,
    double? estimatedBudget,
    String? caseType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Issue(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      mobilityStatus: mobilityStatus ?? this.mobilityStatus,
      relatedHealthRecord: relatedHealthRecord ?? this.relatedHealthRecord,
      addOn: addOn ?? this.addOn,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      caseType: caseType ?? this.caseType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: _parseImages(json['images']),
      mobilityStatus: json['mobility_status'] ?? '',
      relatedHealthRecord: json['related_health_record'] != null
          ? MedicalRecordModel.fromJson(json['related_health_record'])
          : null,
      addOn: json['add_on'] ?? '',
      estimatedBudget: (json['estimated_budget'] as num?)?.toDouble() ?? 0.0,
      caseType: json['case_type'],
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
      'images': images,
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord?.id, // Only send ID
      'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'case_type': caseType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        images,
        mobilityStatus,
        relatedHealthRecord,
        addOn,
        estimatedBudget,
        caseType,
        createdAt,
        updatedAt,
      ];
}

abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object> get props => [];
}

class PersonalInitial extends PersonalState {}

class PersonalLoading extends PersonalState {}

class PersonalLoaded extends PersonalState {
  final List<Issue> issues;

  const PersonalLoaded(this.issues);

  @override
  List<Object> get props => [issues];
}

class PersonalUnauthenticated extends PersonalState {}

class PersonalError extends PersonalState {
  final String message;

  const PersonalError(this.message);

  @override
  List<Object> get props => [message];
}
