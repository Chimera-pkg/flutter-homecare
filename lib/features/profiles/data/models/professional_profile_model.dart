import 'package:m2health/features/profiles/data/models/certificate_model.dart';
import 'package:m2health/features/profiles/domain/entities/professional_profile.dart';

class ProfessionalProfileModel extends ProfessionalProfile {
  const ProfessionalProfileModel({
    required super.id,
    required super.userId,
    super.name,
    super.avatar,
    super.experience,
    super.rating,
    super.about,
    super.jobTitle,
    super.workingHours,
    super.workPlace,
    super.isVerified,
    super.verifiedAt,
    super.createdAt,
    super.updatedAt,
    super.certificates = const [],
  });

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'],
      experience: json['experience'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      about: json['about'] ?? '',
      jobTitle: json['job_title'],
      workingHours: json['working_hours'] ?? '',
      workPlace: json['workplace'] ?? '',
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      certificates: (json['certificates'] as List<dynamic>?)
              ?.map((e) => CertificateModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}