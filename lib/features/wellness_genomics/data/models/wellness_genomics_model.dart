import 'package:m2health/features/wellness_genomics/domain/entities/wellness_genomics.dart';

class WellnessGenomicsModel extends WellnessGenomics {
  const WellnessGenomicsModel({
    super.id,
    super.userId,
    super.fullReportPath,
    super.createdAt,
    super.updatedAt,
  });

  factory WellnessGenomicsModel.fromJson(Map<String, dynamic> json) {
    print('[DEBUG] WellnessGenomicsModel.fromJson input: $json');
    return WellnessGenomicsModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()),
      fullReportPath: json['full_report_path']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      // 'full_report_path': fullReportPath, // handle file upload separately
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory WellnessGenomicsModel.fromEntity(WellnessGenomics entity) {
    return WellnessGenomicsModel(
      id: entity.id,
      userId: entity.userId,
      fullReportPath: entity.fullReportPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
