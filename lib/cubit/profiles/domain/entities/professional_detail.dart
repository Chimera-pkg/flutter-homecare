import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/profiles/domain/entities/certificate.dart';

class ProfessionalDetail extends Equatable {
  final int id;
  final String jobTitle;
  final String aboutMe;
  final String workingHours;
  final String workPlace;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Certificate> certificates;

  const ProfessionalDetail({
    required this.id,
    required this.jobTitle,
    required this.aboutMe,
    required this.workingHours,
    required this.workPlace,
    this.createdAt,
    this.updatedAt,
    this.certificates = const [],
  });

  @override
  List<Object?> get props => [
        id,
        jobTitle,
        aboutMe,
        workingHours,
        workPlace,
        createdAt,
        updatedAt,
      ];

  ProfessionalDetail copyWith({
    int? id,
    String? jobTitle,
    String? aboutMe,
    String? workingHours,
    String? workPlace,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Certificate>? certificates,
  }) {
    return ProfessionalDetail(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      aboutMe: aboutMe ?? this.aboutMe,
      workingHours: workingHours ?? this.workingHours,
      workPlace: workPlace ?? this.workPlace,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      certificates: certificates ?? this.certificates,
    );
  }
}
