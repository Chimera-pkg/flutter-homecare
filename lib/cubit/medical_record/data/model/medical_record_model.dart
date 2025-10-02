import 'package:m2health/cubit/medical_record/domain/entities/medical_record.dart';

class MedicalRecordModel extends MedicalRecord {
  const MedicalRecordModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.diseaseName,
    super.diseaseHistory,
    super.symptoms,
    super.specialConsideration,
    super.treatmentInfo,
    super.fileUrl,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      diseaseName: json['disease_name'] ?? '',
      diseaseHistory: json['disease_history'],
      symptoms: json['symptoms'],
      specialConsideration: json['special_consideration'],
      treatmentInfo: json['treatment_info'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'disease_name': diseaseName,
      'disease_history': diseaseHistory,
      'symptoms': symptoms,
      'special_consideration': specialConsideration,
      'treatment_info': treatmentInfo,
      'file_url': fileUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
