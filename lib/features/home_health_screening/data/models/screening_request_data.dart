import 'package:m2health/features/home_health_screening/data/models/screening_category_model.dart';
import 'package:m2health/features/home_health_screening/domain/entities/screening_service.dart';

class ScreeningRequestData {
  final int id;
  final int appointmentId;
  final String status;
  final List<ScreeningItem> services;
  final List<ScreeningReport> reports;

  ScreeningRequestData({
    required this.id,
    required this.appointmentId,
    required this.status,
    required this.services,
    required this.reports,
  });

  factory ScreeningRequestData.fromJson(Map<String, dynamic> json) {
    return ScreeningRequestData(
      id: json['id'] ?? 0,
      appointmentId: json['appointment_id'] ?? 0,
      status: json['status'] ?? 'submitted',
      services: (json['services_snapshot'] as List? ?? [])
          .map((e) => ScreeningItemModel.fromJson(e))
          .toList(),
      reports: (json['reports'] as List? ?? [])
          .map((e) => ScreeningReport.fromJson(e))
          .toList(),
    );
  }
}

class ScreeningReport {
  final int id;
  final ScreeningFile file;

  ScreeningReport({required this.id, required this.file});

  factory ScreeningReport.fromJson(Map<String, dynamic> json) {
    return ScreeningReport(
      id: json['id'] ?? 0,
      file: ScreeningFile.fromJson(json['file'] ?? {}),
    );
  }
}

class ScreeningFile {
  final int id;
  final String url;
  final String extname;

  ScreeningFile({required this.id, required this.url, required this.extname});

  factory ScreeningFile.fromJson(Map<String, dynamic> json) {
    return ScreeningFile(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      extname: json['extname'] ?? '',
    );
  }
}
