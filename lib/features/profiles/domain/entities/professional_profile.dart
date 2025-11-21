import 'package:equatable/equatable.dart';
import 'package:m2health/features/booking_appointment/add_on_services/domain/entities/add_on_service.dart';
import 'package:m2health/features/profiles/domain/entities/certificate.dart';

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
  final bool isVerified;
  final DateTime? verifiedAt;
  final bool?
      isHomeScreeningAuthorized; // Home screening authorization for nurse
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<Certificate> certificates;
  final List<AddOnService> providedServices;

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
    this.isVerified = false,
    this.verifiedAt,
    this.isHomeScreeningAuthorized,
    this.createdAt,
    this.updatedAt,
    this.certificates = const [],
    this.providedServices = const [],
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
        isVerified,
        verifiedAt,
        isHomeScreeningAuthorized,
        createdAt,
        updatedAt,
        certificates,
        providedServices,
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
    bool? isVerified,
    DateTime? verifiedAt,
    bool? isHomeScreeningAuthorized,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Certificate>? certificates,
    List<AddOnService>? providedServices,
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
        isVerified: isVerified ?? this.isVerified,
        verifiedAt: verifiedAt ?? this.verifiedAt,
        isHomeScreeningAuthorized:
            isHomeScreeningAuthorized ?? this.isHomeScreeningAuthorized,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        certificates: certificates ?? this.certificates,
        providedServices: providedServices ?? this.providedServices);
  }
}
