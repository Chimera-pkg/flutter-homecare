import 'package:m2health/cubit/profiles/data/models/certificate_model.dart';
import 'package:m2health/cubit/profiles/domain/entities/professional_detail.dart';

class ProfessionalDetailModel extends ProfessionalDetail {
  const ProfessionalDetailModel({
    required super.id,
    required super.jobTitle,
    required super.aboutMe,
    required super.workingHours,
    required super.workPlace,
    super.createdAt,
    super.updatedAt,
    super.certificates = const [],
  });

  factory ProfessionalDetailModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalDetailModel(
      id: json['id'] ?? 0,
      jobTitle: json['job_title'] ?? '',
      aboutMe: json['about_me'] ?? '',
      workingHours: json['working_hours'] ?? '',
      workPlace: json['workplace'] ?? '',
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
