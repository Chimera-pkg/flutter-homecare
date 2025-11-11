import 'package:equatable/equatable.dart';
import 'package:m2health/features/nursing/domain/entities/reviewer.dart';
import 'package:m2health/features/profiles/domain/entities/certificate.dart';

class ProfessionalEntity extends Equatable {
  final int id;
  final String name;
  final String? avatar;
  final int? experience;
  final double? rating;
  final String? about;
  final String? jobTitle;
  final String? workingInformation;
  final String? workingHours;
  final String? workplace;
  final List<Certificate>? certificates;
  final List<ReviewEntity>? reviews;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final bool isFavorite;
  final String role;
  final String providerType;

  const ProfessionalEntity({
    required this.id,
    required this.name,
    this.avatar,
    required this.experience,
    required this.rating,
    this.about,
    this.workingInformation,
    this.jobTitle,
    this.workingHours,
    this.workplace,
    required this.certificates,
    required this.reviews,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.role,
    required this.providerType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        experience,
        rating,
        about,
        workingInformation,
        jobTitle,
        workingHours,
        workplace,
        certificates,
        reviews,
        userId,
        createdAt,
        updatedAt,
        isFavorite,
        role,
        providerType,
      ];
}
