import 'package:m2health/cubit/profiles/data/models/professional_detail_model.dart';
import 'package:m2health/cubit/profiles/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.email,
    super.age,
    super.weight,
    super.height,
    super.phoneNumber,
    super.homeAddress,
    super.gender,
    super.avatar,
    super.createdAt,
    super.updatedAt,
    super.professionalDetail,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      age: json['age'] ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phone_number'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      homeAddress: json['home_address'] ?? '',
      gender: json['gender'] ?? '',
      avatar: json['avatar'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      professionalDetail: json['professionalDetail'] != null
          ? ProfessionalDetailModel.fromJson(json['professionalDetail'])
          : null,
    );
  }

}
