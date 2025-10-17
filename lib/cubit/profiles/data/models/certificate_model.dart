import 'package:m2health/cubit/profiles/domain/entities/certificate.dart';

class CertificateModel extends Certificate {
  const CertificateModel({
    required super.id,
    required super.title,
    required super.registrationNumber,
    required super.issuedOn,
    required super.fileURL,
    super.createdAt,
    super.updatedAt,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] ?? 0,
      title: json['certificate_title'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      issuedOn: json['issued_on'] ?? '',
      fileURL: json['file_path'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
