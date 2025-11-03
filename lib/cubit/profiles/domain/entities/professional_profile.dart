import 'package:equatable/equatable.dart';
import 'package:m2health/cubit/profiles/domain/entities/certificate.dart';

class ProfessionalProfile extends Equatable {
  final int id;
  final int userId;
  final String? name;
  final String? avatar;
  final int? experience;
  final double? rating;
  final String? about;
  final String? jobTitle;
  final String? workingHours;
  final String? workPlace;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Certificate> certificates;

  const ProfessionalProfile({
    required this.id,
    required this.userId,
    this.name,
    this.avatar,
    this.experience,
    this.rating,
    this.about,
    this.jobTitle,
    this.workingHours,
    this.workPlace,
    this.createdAt,
    this.updatedAt,
    this.certificates = const [],
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        avatar,
        experience,
        rating,
        about,
        jobTitle,
        workingHours,
        workPlace,
        createdAt,
        updatedAt,
        certificates,
      ];

  ProfessionalProfile copyWith({
    int? id,
    int? userId,
    String? name,
    String? avatar,
    int? experience,
    double? rating,
    String? about,
    String? jobTitle,
    String? workingHours,
    String? workPlace,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Certificate>? certificates,
  }) {
    return ProfessionalProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      experience: experience ?? this.experience,
      rating: rating ?? this.rating,
      about: about ?? this.about,
      jobTitle: jobTitle ?? this.jobTitle,
      workingHours: workingHours ?? this.workingHours,
      workPlace: workPlace ?? this.workPlace,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      certificates: certificates ?? this.certificates,
    );
  }
}
