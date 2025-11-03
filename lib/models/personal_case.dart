import 'dart:convert';

import 'package:m2health/cubit/nursingclean/data/models/add_on_service_model.dart';
import 'package:m2health/cubit/nursingclean/domain/entities/add_on_service.dart';

class PersonalCase {
  final int id;
  final String title;
  final String description;
  final List<String> images;
  final String mobilityStatus;
  final Map<String, dynamic> relatedHealthRecord;
  final List<AddOnService> addOn;
  final double estimatedBudget;
  final int userId;

  PersonalCase({
    required this.id,
    required this.title,
    required this.description,
    required this.images, // Change to list of strings
    required this.mobilityStatus,
    required this.relatedHealthRecord,
    required this.addOn,
    required this.estimatedBudget,
    required this.userId,
  });

  factory PersonalCase.fromJson(Map<String, dynamic> json) {
    final List<dynamic> addOnData = json['add_on'] ?? [];
    final List<AddOnService> addOns =
        addOnData.map((item) => AddOnServiceModel.fromJson(item)).toList();
    return PersonalCase(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] is String
          ? List<String>.from(jsonDecode(json['images']))
          : List<String>.from(json['images'] ?? []),
      mobilityStatus: json['mobility_status'] ?? '',
      // relatedHealthRecord: json['related_health_record'] ?? '',
      relatedHealthRecord: json['related_health_record'] is Map
          ? Map<String, dynamic>.from(json['related_health_record'])
          : {},
      addOn: addOns,
      estimatedBudget:
          double.tryParse(json['estimated_budget']?.toString() ?? '') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images, // Change to list of strings
      'mobility_status': mobilityStatus,
      'related_health_record': relatedHealthRecord,
      // 'add_on': addOn,
      'estimated_budget': estimatedBudget,
      'user_id': userId,
    };
  }
}
