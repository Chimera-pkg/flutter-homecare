import 'package:m2health/cubit/profiles/domain/entities/professional_detail.dart';

class Profile {
  final int id;
  final int userId;
  final String username;
  final String email;
  final int? age;
  final double? weight;
  final double? height;
  final String? phoneNumber;
  final String? homeAddress;
  final String? gender;
  final String? avatar;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProfessionalDetail? professionalDetail;

  Profile({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    this.age,
    this.weight,
    this.height,
    this.phoneNumber,
    this.homeAddress,
    this.gender,
    this.avatar,
    this.createdAt,
    this.updatedAt,
    this.professionalDetail,
  });

  Profile copyWith({
    int? id,
    int? userId,
    String? username,
    String? email,
    int? age,
    double? weight,
    double? height,
    String? phoneNumber,
    String? homeAddress,
    String? gender,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProfessionalDetail? professionalDetail,
  }) {
    return Profile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      homeAddress: homeAddress ?? this.homeAddress,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      professionalDetail: professionalDetail ?? this.professionalDetail,
    );
  }
}
