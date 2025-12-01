import 'package:m2health/features/booking_appointment/personal_issue/domain/entities/personal_issue.dart';

class PersonalIssueModel extends PersonalIssue {
  const PersonalIssueModel({
    super.id,
    required super.type,
    required super.title,
    required super.description,
    super.images,
    super.newImages,
    super.imageUrls,
    super.createdAt,
    super.updatedAt,
  });

  factory PersonalIssueModel.fromJson(Map<String, dynamic> json) {
    return PersonalIssueModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      imageUrls: List<String>.from(json['images'] ?? []),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
    };
  }

  factory PersonalIssueModel.fromEntity(PersonalIssue issue) {
    return PersonalIssueModel(
      id: issue.id,
      type: issue.type,
      title: issue.title,
      description: issue.description,
      images: issue.images,
      newImages: issue.newImages,
      imageUrls: issue.imageUrls,
      createdAt: issue.createdAt,
      updatedAt: issue.updatedAt,
    );
  }
}
