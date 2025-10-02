import 'package:equatable/equatable.dart';

class MedicalRecord extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String diseaseName;
  final String? diseaseHistory;
  final String? symptoms;
  final String? specialConsideration;
  final String? treatmentInfo;
  final String? fileUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicalRecord({
    required this.id,
    required this.userId,
    required this.title,
    required this.diseaseName,
    this.diseaseHistory,
    this.symptoms,
    this.specialConsideration,
    this.treatmentInfo,
    this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        diseaseName,
        diseaseHistory,
        symptoms,
        specialConsideration,
        treatmentInfo,
        fileUrl,
        createdAt,
        updatedAt,
      ];
}
