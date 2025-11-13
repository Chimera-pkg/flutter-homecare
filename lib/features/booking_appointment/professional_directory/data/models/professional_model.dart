import 'package:m2health/features/booking_appointment/professional_directory/data/models/review_model.dart';
import 'package:m2health/features/booking_appointment/professional_directory/domain/entities/professional_entity.dart';
import 'package:m2health/features/profiles/data/models/certificate_model.dart';

class ProfessionalModel extends ProfessionalEntity {
  const ProfessionalModel({
    required super.id,
    required super.name,
    required super.avatar,
    required super.experience,
    required super.rating,
    required super.about,
    required super.workingInformation,
    required super.jobTitle,
    required super.workingHours,
    required super.workplace,
    required super.certificates,
    required super.reviews,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
    required super.isFavorite,
    required super.role,
    required super.providerType,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      experience: json['experience'],
      rating: (json['rating'] as num).toDouble(),
      about: json['about'],
      jobTitle: json['job_title'] ?? json['role'],
      workingInformation: json['working_information'] ?? '',
      workingHours: json['working_hours'],
      workplace: json['workplace'],
      certificates: (json['certificates'] as List<dynamic>?)
              ?.map((e) => CertificateModel.fromJson(e))
              .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isFavorite: json['is_favorite'] ?? false,
      role: json['role'],
      providerType: json['provider_type'] ?? json['role'],
    );
  }
}
